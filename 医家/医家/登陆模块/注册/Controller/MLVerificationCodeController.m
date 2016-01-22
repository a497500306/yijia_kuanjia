//
//  MLVerificationCodeController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/8.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLVerificationCodeController.h"
#import "MLInterface.h"
#import "IWHttpTool.h"
#import "MLLoinModel.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "MD5Tool.h"
#import "MLReistModel.h"
#import "MLUserInfo.h"
#import "MLVerificationCodeInfo.h"
#define chongfashijian 60
@interface MLVerificationCodeController ()<UITextFieldDelegate>
/**
 *  验证码Field
 */
@property (nonatomic ,weak)UITextField *yanzhemaField;
/**
 *  密码Field
 */
@property (nonatomic ,weak)UITextField *mimaField;
/**
 *  重发Btn
 */
@property (nonatomic ,weak)UIButton *chongfaBtn;
/**
 *  重发定时器
 */
@property (nonatomic,strong) NSTimer *chongfaTimer;
/**
 *  重发时间计时
 */
@property (nonatomic, assign)NSInteger shijianjishi;

@end

@implementation MLVerificationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self chushihua];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示uinavigationcontroller
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"注册";
    //设置右上角的下一步按钮
    UIBarButtonItem *youBtnBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dianjixiayibu)];
    self.navigationItem.rightBarButtonItem = youBtnBarItem;
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.userInteractionEnabled = YES;
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
    //创建Label
    UILabel *tishi = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 20, self.view.frame.size.width - 20, 30)];
    NSString *dianhua1 = [self.shouji substringWithRange:NSMakeRange(0,3)];
    NSString *dianhua2 = [self.shouji substringWithRange:NSMakeRange(3,4)];
    NSString *dianhua3 = [self.shouji substringWithRange:NSMakeRange(7,4)];
    NSString *str = [NSString stringWithFormat:@"验证码短信已发送至+86 %@ %@ %@",dianhua1,dianhua2,dianhua3];
    tishi.font = [UIFont systemFontOfSize:16];
    tishi.textColor = [UIColor whiteColor];
    tishi.textAlignment = NSTextAlignmentLeft;
    tishi.text = str;
    [self.view addSubview:tishi];
    //创建验证码背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, tishi.frame.origin.y + tishi.frame.size.height + 5, self.view.frame.size.width - 40, 81)];
    imageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    //圆角
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    //创建没收到按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.size.width - 80, 0, 80, 40)];
    btn.enabled = NO;
    btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    NSString *s = [NSString stringWithFormat:@"%ds后重发",chongfashijian];
    [btn setTitle:s forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(dianjimeishoudao) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
    self.chongfaBtn = btn;
    //创建重发定时器
    self.chongfaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chongfadingshiqi) userInfo:nil repeats:YES];
    //创建验证码输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y, imageView.frame.size.width - btn.frame.size.width - 20, 40)];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入收到的验证码" attributes:attrs1];
    textField.textColor = [UIColor whiteColor];
    self.yanzhemaField = textField;
    [self.view addSubview:textField];
    //设置线
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, 41, imageView.frame.size.width, 1)];
    xian.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:xian];
    //创建密码输入框
    UITextField *mimaField = [[UITextField alloc] initWithFrame:CGRectMake(10,  xian.frame.origin.y , imageView.frame.size.width - 20, 40)];
    mimaField.delegate = self;
    mimaField.secureTextEntry=YES;
    [imageView addSubview:mimaField];
    mimaField.textColor = [UIColor whiteColor];
    self.mimaField = mimaField;
    
    //设置提示文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    mimaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:attrs];
    //设置清除按钮
    mimaField.clearButtonMode = UITextFieldViewModeAlways;
}
#pragma mark - 点击完成
-(void)dianjixiayibu{
    //跳到验证码界面
    if (self.yanzhemaField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if (self.mimaField.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码不得少于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    //发送创建网络请求
    NSString *url = [MLInterface sharedMLInterface].saveUser;
    //密码
    NSString *mima = [MD5Tool md5:[self.mimaField.text stringByAppendingString:@"rolle"]];
    NSDictionary *parameters = @{@"mobile":self.shouji, @"verifycode":self.yanzhemaField.text,@"password":mima, @"typeId":@"3",@"appType":@"3"};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLReistModel *model = [MLReistModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            //提示创建成功,回到登陆界面
            [MBProgressHUD showSuccess:@"创建成功" toView:self.view];
            //保存到数据库
            //用户名和用户密码保存到沙盒
            [MLUserInfo sharedMLUserInfo].user = self.shouji;
            [MLUserInfo sharedMLUserInfo].pwd = mima;
            [MLUserInfo sharedMLUserInfo].token = model.token;
            [MLUserInfo sharedMLUserInfo].loginStatus = NO;
            [MLUserInfo sharedMLUserInfo].userId = model.userId;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Project" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        //检查网络
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - 重发定时器
-(void)chongfadingshiqi{
    self.shijianjishi = self.shijianjishi + 1;
    NSString *str = [NSString stringWithFormat:@"%lds后重发",chongfashijian-self.shijianjishi];
    [MLVerificationCodeInfo sharedMLVerificationCodeInfo].zhucheYanzhenma = chongfashijian - self.shijianjishi;
    [self.chongfaBtn setTitle:str forState:UIControlStateNormal];
    if (self.shijianjishi == chongfashijian) {
        [MLVerificationCodeInfo sharedMLVerificationCodeInfo].zhucheYanzhenma = 0;
        self.shijianjishi = 0 ;
        [self.chongfaTimer invalidate];
        self.chongfaTimer = nil;
        [self.chongfaBtn setTitle:@"没收到?" forState:UIControlStateNormal];
        //btn可以点击
        self.chongfaBtn.enabled = YES;
    }
}
#pragma mark - 点击重发
-(void)dianjimeishoudao{
    self.shijianjishi = 0;
    self.chongfaBtn.enabled = NO;
    //创建重发定时器
    self.chongfaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chongfadingshiqi) userInfo:nil repeats:YES];
    //网络发送验证码
    NSString *url = [MLInterface sharedMLInterface].sendVerifycodeVerificationCode;
    NSDictionary *parameters = @{@"mobile":self.shouji, @"typeId":@"82"};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLLoinModel *model = [MLLoinModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {//发送成功提示
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {//检查网络
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
@end
