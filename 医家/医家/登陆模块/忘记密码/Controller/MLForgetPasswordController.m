//
//  MLForgetPasswordController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/8.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLForgetPasswordController.h"
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
#define zhiti 17
@interface MLForgetPasswordController ()
/**
 *  验证码Field
 */
@property (nonatomic ,weak)UITextField *yanzhemaField;
/**
 *  手机Field
 */
@property (nonatomic ,weak)UITextField *shoujiField;
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

@implementation MLForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示uinavigationcontroller
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"找回密码";
}
#pragma mark - 初始化
-(void)chushihua{
    //创建背景图片
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.userInteractionEnabled = YES;
    bg.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [bg addGestureRecognizer:tap];
    [self.view addSubview:bg];
    //创建对话框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 10 + 64, self.view.frame.size.width - 20, 40)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    //圆角
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    //输入手机号
    UITextField *shoujiField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imageView.frame.size.width - 10, 40)];
    self.shoujiField = shoujiField;
    shoujiField.textColor = [UIColor blackColor];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    shoujiField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs1];
    shoujiField.font = [UIFont systemFontOfSize:zhiti];
    //设置清除按钮
    shoujiField.clearButtonMode = UITextFieldViewModeAlways;
    //弹出数字键盘
    shoujiField.keyboardType = UIKeyboardTypeNumberPad;
    shoujiField.tintColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    [imageView addSubview:shoujiField];
    //创建验证码对话框
    UIImageView *imageView1= [[UIImageView alloc] initWithFrame:CGRectMake(10 , imageView.frame.origin.y + imageView.frame.size.height + 10, self.view.frame.size.width - 20, 40)];
    imageView1.userInteractionEnabled = YES;
    imageView1.backgroundColor = [UIColor whiteColor];
    //圆角
    imageView1.layer.cornerRadius = 3;
    imageView1.layer.masksToBounds = YES;
    [self.view addSubview:imageView1];
    //输入验证码
    UITextField *yanzhenmaField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imageView.frame.size.width - 100, 40)];
    self.yanzhemaField = yanzhenmaField;
    yanzhenmaField.textColor = [UIColor blackColor];
    //设置提示文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    yanzhenmaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:attrs];
    yanzhenmaField.font = [UIFont systemFontOfSize:zhiti];
    yanzhenmaField.tintColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    //设置清除按钮
    yanzhenmaField.clearButtonMode = UITextFieldViewModeAlways;
    //弹出数字键盘
    yanzhenmaField.keyboardType = UIKeyboardTypeNumberPad;
    [imageView1 addSubview:yanzhenmaField];
    //发送验证码
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.size.width - 90, 0, 90, 40)];
    btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(dianjimeishoudao) forControlEvents:UIControlEventTouchUpInside];
    [imageView1 addSubview:btn];
    self.chongfaBtn = btn;
    //判断是否到时间
    if ([MLVerificationCodeInfo sharedMLVerificationCodeInfo].zhaohuiYanzhenma != 0) {
        NSString *str = [NSString stringWithFormat:@"%lds后重发",(long)[MLVerificationCodeInfo sharedMLVerificationCodeInfo].zhaohuiYanzhenma];
        [self.chongfaBtn setTitle:str forState:UIControlStateNormal];
        self.chongfaBtn.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        self.shijianjishi = 0;
        self.chongfaBtn.userInteractionEnabled = NO;
        //创建重发定时器
        self.chongfaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chongfadingshiqi) userInfo:nil repeats:YES];
        self.shijianjishi = chongfashijian - [MLVerificationCodeInfo sharedMLVerificationCodeInfo].zhaohuiYanzhenma;
    }
    //创建验证码对话框
    UIImageView *imageView2= [[UIImageView alloc] initWithFrame:CGRectMake(10 , imageView1.frame.origin.y + imageView1.frame.size.height + 10, self.view.frame.size.width - 20, 40)];
    imageView2.userInteractionEnabled = YES;
    imageView2.backgroundColor = [UIColor whiteColor];
    //圆角
    imageView2.layer.cornerRadius = 3;
    imageView2.layer.masksToBounds = YES;
    [self.view addSubview:imageView2];
    //新密码
    UITextField *mimaField = [[UITextField alloc] initWithFrame:CGRectMake(10,0, imageView.frame.size.width - 10, 40)];
    mimaField.textColor = [UIColor blackColor];
    //设置提示文字
    NSMutableDictionary *attrs2 = [NSMutableDictionary dictionary];
    attrs2[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    self.mimaField = mimaField;
    mimaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"新的密码" attributes:attrs2];
    mimaField.font = [UIFont systemFontOfSize:zhiti];
    //设置清除按钮
    mimaField.clearButtonMode = UITextFieldViewModeAlways;
    mimaField.secureTextEntry=YES;
    mimaField.tintColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    [imageView2 addSubview:mimaField];
    //设置确定按钮
    UIButton *queding = [[UIButton alloc] initWithFrame:CGRectMake(10, imageView2.frame.size.height + imageView2.frame.origin.y + 10, self.view.frame.size.width - 20, 40)];
    [queding setTitle:@"确定" forState:UIControlStateNormal];
    queding.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [queding setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queding addTarget:self action:@selector(dianjixiayibu) forControlEvents:UIControlEventTouchUpInside];
    queding.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    queding.tag = 100;
    [queding.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 34/255.0,119/255.0, 240/255.0,1.0 });
    [queding.layer setBorderColor:colorref];
    //圆角
    queding.layer.cornerRadius = 3;
    queding.layer.masksToBounds = YES;
    [self.view addSubview:queding];
}
#pragma mark - 重发定时器
-(void)chongfadingshiqi{
    self.shijianjishi = self.shijianjishi + 1;
    NSString *str = [NSString stringWithFormat:@"%lds后重发",chongfashijian-self.shijianjishi];
    [MLVerificationCodeInfo sharedMLVerificationCodeInfo].zhaohuiYanzhenma = chongfashijian - self.shijianjishi;
    [self.chongfaBtn setTitle:str forState:UIControlStateNormal];
    if (self.shijianjishi == chongfashijian) {
        self.shijianjishi = 0 ;
        [self.chongfaTimer invalidate];
        self.chongfaTimer = nil;
        [self.chongfaBtn setTitle:@"没收到?" forState:UIControlStateNormal];
        self.chongfaBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
        //btn可以点击
        self.chongfaBtn.userInteractionEnabled = YES;
    }
}
#pragma mark - 点击重发
-(void)dianjimeishoudao{
    if (self.shoujiField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    self.chongfaBtn.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.shijianjishi = 0;
    self.chongfaBtn.userInteractionEnabled = NO;
    //创建重发定时器
    self.chongfaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chongfadingshiqi) userInfo:nil repeats:YES];
    //网络发送验证码
    NSString *url = [MLInterface sharedMLInterface].sendVerifycodeVerificationCode;
    NSDictionary *parameters = @{@"mobile":self.shoujiField.text, @"typeId":@"84"};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLLoinModel *model = [MLLoinModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {//发送成功提示
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.shijianjishi = 0 ;
            [self.chongfaTimer invalidate];
            self.chongfaTimer = nil;
            [self.chongfaBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            self.chongfaBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
            //btn可以点击
            self.chongfaBtn.userInteractionEnabled = YES;
        }
    } failure:^(NSError *error) {//检查网络
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - 点击下一步
-(void)dianjixiayibu{
    if (self.shoujiField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if (self.mimaField.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码不能少于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if (self.yanzhemaField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    //网络发送修改密码请求
    NSString *url = [MLInterface sharedMLInterface].updatePassword;
    NSString *passString = [MD5Tool md5:[self.mimaField.text stringByAppendingString:@"rolle"]];
    NSDictionary *parameters = @{@"mobile":self.shoujiField.text, @"verifycode":self.yanzhemaField.text, @"password":passString,@"appType":@"3"};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLLoinModel *model = [MLLoinModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {//发送成功提示
            [MBProgressHUD showSuccess:@"修改成功"];
            //用户名和用户密码保存到沙盒
            [MLUserInfo sharedMLUserInfo].user = self.shoujiField.text;
            [MLUserInfo sharedMLUserInfo].pwd = passString;
            [MLUserInfo sharedMLUserInfo].token = model.token;
            [MLUserInfo sharedMLUserInfo].loginStatus = NO;
            [MLUserInfo sharedMLUserInfo].userId = model.userId;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Project" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
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
