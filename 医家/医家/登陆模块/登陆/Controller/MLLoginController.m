//
//  MLLoginController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/8.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLLoginController.h"
#import "IWHttpTool.h"
#import "MD5Tool.h"
#import "MLInterface.h"
#import "MJExtension.h"
#import "MLLoinModel.h"
#import "MLForgetPasswordController.h"
#import "MLRegisteredController.h"
#import "MBProgressHUD+MJ.h"
#import "MLUserInfo.h"

@interface MLLoginController ()<UITextFieldDelegate>
@property (nonatomic ,weak)UITextField *mimaField;
@property (nonatomic ,weak)UITextField *zhanghaoField;
@property (nonatomic ,copy)NSString *nameString;
@property (nonatomic ,copy)NSString *passString;
@end

@implementation MLLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏uinavigationcontroller
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark - 初始化
-(void)chushihua{
    //创建背景图片
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.userInteractionEnabled = YES;
    bg.image = [UIImage imageNamed:@"3注册(2)"];
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [bg addGestureRecognizer:tap];
    [self.view addSubview:bg];
    //创建LOGO
    UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, 100, 100, 90)];
    logo.image = [UIImage imageNamed:@"医家logo"];
    [self.view addSubview:logo];
    //创建账号
    UIImageView *yonghu = [[UIImageView alloc] initWithFrame:CGRectMake(20, logo.frame.origin.y + 15 + logo.frame.size.height, self.view.frame.size.width - 40, 81)];
    yonghu.userInteractionEnabled = YES;
    yonghu.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    //圆角
    yonghu.layer.cornerRadius = 3;
    yonghu.layer.masksToBounds = YES;
    [self.view addSubview:yonghu];
    //创建账号图片
    UIImageView *zhanghaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 23, 23)];
    zhanghaoImage.image = [UIImage imageNamed:@"btn－用户"];
    [yonghu addSubview:zhanghaoImage];
    //创建账号输入框
    UITextField *zhanghaoField = [[UITextField alloc] initWithFrame:CGRectMake(zhanghaoImage.frame.origin.x + zhanghaoImage.frame.size.width + 10, zhanghaoImage.frame.origin.y, yonghu.frame.size.width - zhanghaoImage.frame.size.width - zhanghaoImage.frame.origin.x - 20, zhanghaoImage.frame.size.height)];
    zhanghaoField.delegate = self;
    //弹出数字键盘
    zhanghaoField.keyboardType = UIKeyboardTypeNumberPad;
    zhanghaoField.textColor = [UIColor whiteColor];
    [yonghu addSubview:zhanghaoField];
    //设置提示文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    zhanghaoField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
    //设置清除按钮
    zhanghaoField.clearButtonMode = UITextFieldViewModeAlways;
    self.zhanghaoField = zhanghaoField;
    //线
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(10, 41, yonghu.frame.size.width - 20, 1)];
    xian.backgroundColor = [UIColor whiteColor];
    [yonghu addSubview:xian];
    //创建密码图片
    UIImageView *mimaImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, xian.frame.origin.y + 10, 23, 23)];
    mimaImage.image = [UIImage imageNamed:@"btn－密码"];
    [yonghu addSubview:mimaImage];
    //创建密码输入框
    UITextField *mimaField = [[UITextField alloc] initWithFrame:CGRectMake(mimaImage.frame.origin.x + mimaImage.frame.size.width + 10, mimaImage.frame.origin.y, yonghu.frame.size.width - mimaImage.frame.size.width - mimaImage.frame.origin.x - 20, mimaImage.frame.size.height)];
    mimaField.delegate = self;
    mimaField.secureTextEntry=YES;
    [yonghu addSubview:mimaField];
    
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    mimaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:attrs1];
    mimaField.textColor = [UIColor whiteColor];
    //设置清除按钮
    mimaField.clearButtonMode = UITextFieldViewModeAlways;
    self.mimaField = mimaField;
    //设置登陆按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(yonghu.frame.origin.x, yonghu.frame.size.height + yonghu.frame.origin.y + 15 , yonghu.frame.size.width, 40);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(dianjidenglu) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 100;
    [loginButton.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1.0,1.0, 1.0,1.0 });
    [loginButton.layer setBorderColor:colorref];
    //圆角
    loginButton.layer.cornerRadius = 3;
    loginButton.layer.masksToBounds = YES;
    [self.view addSubview:loginButton];
    //新账户
    UIButton *newUser = [[UIButton alloc] initWithFrame:CGRectMake(0, loginButton.frame.size.height + loginButton.frame.origin.y + 15, (self.view.frame.size.width / 2 ) - 20, 20)];
    [newUser setTitle:@"创建新账户" forState:UIControlStateNormal];
    [newUser addTarget:self action:@selector(dianjiNewUser) forControlEvents:UIControlEventTouchUpInside];
    newUser.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:newUser];
    //线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, newUser.frame.origin.y, 1, newUser.frame.size.height)];
    xian1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:xian1];
    //忘记密码
    UIButton *wanjimima = [[UIButton alloc] initWithFrame:CGRectMake(xian1.frame.origin.x + 20, loginButton.frame.size.height + loginButton.frame.origin.y + 15, (self.view.frame.size.width / 2 ) - 20, 20)];
    [wanjimima setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [wanjimima addTarget:self action:@selector(dianjiWanjimima) forControlEvents:UIControlEventTouchUpInside];
    wanjimima.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:wanjimima];
}

#pragma mark - 限制手机号码只有11位
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.zhanghaoField == textField) {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 点击登陆
-(void)dianjidenglu{
    if (self.zhanghaoField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.mimaField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //网络处理
    self.nameString = self.zhanghaoField.text;
    self.passString = [MD5Tool md5:[self.mimaField.text stringByAppendingString:@"rolle"]];
    NSDictionary *parameters = @{@"typeId":@"3",@"mobile":self.nameString, @"password":self.passString,@"appType":@"3"};
    NSString *url = [MLInterface sharedMLInterface].login;
    [MBProgressHUD showMessage:@"正在登陆" toView:self.view];
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLLoinModel *model = [MLLoinModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD hideHUDForView:self.view];
            //用户名和用户密码保存到沙盒
            [MLUserInfo sharedMLUserInfo].user = self.zhanghaoField.text;
            [MLUserInfo sharedMLUserInfo].pwd = self.passString;
            [MLUserInfo sharedMLUserInfo].loginStatus = NO;
            [MLUserInfo sharedMLUserInfo].token = model.token;
            [MLUserInfo sharedMLUserInfo].userId = model.userId;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Project" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {//提示检查网络
        [MBProgressHUD hideHUDForView:self.view];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - 点击创建新账户
-(void)dianjiNewUser{
    MLRegisteredController *registered = [[MLRegisteredController alloc] init];
    [self.navigationController pushViewController:registered animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}
#pragma mark - 点击忘记密码
-(void)dianjiWanjimima{
    MLForgetPasswordController *fp = [[MLForgetPasswordController alloc] init];
    [self.navigationController pushViewController:fp animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}
#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
@end
