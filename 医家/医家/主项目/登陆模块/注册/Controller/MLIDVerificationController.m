//
//  MLIDVerificationController.m
//  医家
//
//  Created by 洛耳 on 16/1/22.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLIDVerificationController.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "IWHttpTool.h"
#import "yijia-Swift.h"
#import "MLIDSelectionController.h"
#import "MLUserModel.h"
#import "MLUserInfo.h"


@interface MLIDVerificationController ()
/**
 *  姓名
 */
@property (nonatomic ,weak)UITextField *yanzhemaField;
/**
 *  身份证号码
 */
@property (nonatomic ,weak)UITextField *mimaField;

@end

@implementation MLIDVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示uinavigationcontroller
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"实名认证";
    //设置右上角的下一步按钮
    UIBarButtonItem *youBtnBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(dianjixiayibu)];
    self.navigationItem.rightBarButtonItem = youBtnBarItem;
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //创建背景图片
    //    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    bg.userInteractionEnabled = YES;
    //    bg.image = [UIImage imageNamed:@"3注册(2)"];
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [self.view addGestureRecognizer:tap];
    //    [self.view addSubview:bg];
    //创建Label
    UILabel *tishi = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 20, self.view.frame.size.width - 20, 30)];
    NSString *dianhua1 = [self.shouji substringWithRange:NSMakeRange(0,3)];
    NSString *dianhua2 = [self.shouji substringWithRange:NSMakeRange(3,4)];
    NSString *dianhua3 = [self.shouji substringWithRange:NSMakeRange(7,4)];
    NSString *str = [NSString stringWithFormat:@"请为用户+86 %@ %@ %@做实名认证",dianhua1,dianhua2,dianhua3];
    tishi.font = [UIFont systemFontOfSize:16];
    tishi.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
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
    //创建验证码输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y, imageView.frame.size.width - 20, 40)];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    //    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入姓名" attributes:attrs1];
    textField.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    textField.tintColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    self.yanzhemaField = textField;
    [self.view addSubview:textField];
    //设置线
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, 41, imageView.frame.size.width, 1)];
    xian.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:xian];
    //创建密码输入框
    UITextField *mimaField = [[UITextField alloc] initWithFrame:CGRectMake(10,  xian.frame.origin.y , imageView.frame.size.width - 20, 40)];
    mimaField.secureTextEntry=YES;
    [imageView addSubview:mimaField];
    mimaField.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    self.mimaField = mimaField;
    
    //设置提示文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    //    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    mimaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入身份证号码" attributes:attrs];
    mimaField.tintColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    //设置清除按钮
    mimaField.clearButtonMode = UITextFieldViewModeAlways;
}


#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
#pragma mark - 点击下一步
-(void)dianjixiayibu{
    if (self.yanzhemaField.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的姓名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    if (self.mimaField.text.length < 10) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的身份证号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    //网络传数据
    NSDictionary *dict = @{@"idCard":self.mimaField.text,@"name":self.yanzhemaField.text,@"password":self.mima,@"phone":self.shouji};
    NSDictionary *params = @{@"params":[MLJson json:dict]};
    [IWHttpTool postWithURL:[MLInterface zc] params:params success:^(id json) {
        NSLog(@"%@",json);
        [MLWebLsmrModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"data":@"data"};
        }];
        MLWebLsmrModel *model = [MLWebLsmrModel objectWithKeyValues:json];
        [MLUserModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        MLUserModel *userModel = [MLUserModel objectWithKeyValues:model.data];
        //保存用户数据
        //保存沙盒
        [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
        [MLUserInfo sharedMLUserInfo].token = userModel.userToken;
        [MLUserInfo sharedMLUserInfo].user = userModel.ID;
        [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
        if ([model.msg isEqualToString:@"9000"]){//存在该用户
#warning 跳到首页,并保存用户ID
            //跳转到主界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else if ([model.msg isEqualToString:@"8000"]){//不存在该用户
#warning 跳到首页,保存用户ID
            //跳到身份选择页面
            MLIDSelectionController *vc = [[MLIDSelectionController alloc] init];
            vc.shenfenzheng = self.mimaField.text;
            [self.navigationController pushViewController:vc animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        }

    } failure:^(NSError *error) {
        NSLog(@"错误");
    }];
}
@end
