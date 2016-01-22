//
//  MLRegisteredController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/8.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLRegisteredController.h"
#import "MLVerificationCodeController.h"
//#import "MLInterface.h"
#import "MJExtension.h"
#import "MLLoinModel.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import <SMS_SDK/SMSSDK.h>//免费短信

@interface MLRegisteredController ()<UITextFieldDelegate>
@property (nonatomic ,weak)UITextField *textField;
@property (nonatomic ,weak)UIButton *btn;
@end

@implementation MLRegisteredController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示uinavigationcontroller
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"注册";
    //设置右上角的下一步按钮
    UIBarButtonItem *youBtnBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(dianjixiayibu)];
    self.navigationItem.rightBarButtonItem = youBtnBarItem;
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.userInteractionEnabled = YES;
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
    //创建医生和营养师选择对话框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 , 20 + 64, self.view.frame.size.width - 40, 40)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    //圆角
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
//    //医生和营养师选择
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, imageView.frame.size.width - 20, 40)];
//    [btn setTitle:@"医生" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(dianjixuanzhe) forControlEvents:UIControlEventTouchUpInside];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [imageView addSubview:btn];
//    self.btn = btn;
//    //创建箭头
//    UIImageView *jiantouImage = [[UIImageView alloc] initWithFrame:CGRectMake(45, 16, 10, 7)];
//    jiantouImage.userInteractionEnabled = YES;
//    jiantouImage.image = [UIImage imageNamed:@"btn－登录下拉"];
//    [btn addSubview:jiantouImage];
//    //线
//    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, 41, imageView.frame.size.width, 1)];
//    xian.backgroundColor = [UIColor whiteColor];
//    [imageView addSubview:xian];
    //创建+86
    UILabel * label86 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    label86.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    label86.text = @"+86";
    label86.font = [UIFont systemFontOfSize:19];
    [imageView addSubview:label86];
    //竖线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(label86.frame.origin.x + label86.frame.size.width + 5, label86.frame.origin.y, 1, label86.frame.size.width)];
    xian1.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:xian1];
    //创建输入手机号码
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(xian1.frame.origin.x + 11, xian1.frame.origin.y, imageView.frame.size.width - xian1.frame.origin.x - 20, 40)];
    textField.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
//    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入您的手机号码" attributes:attrs1];
    textField.font = [UIFont systemFontOfSize:19];
    textField.tintColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    //设置清除按钮
    textField.clearButtonMode = UITextFieldViewModeAlways;
    //弹出数字键盘
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [imageView addSubview:textField];
    textField.delegate = self;
    self.textField = textField;
}
#pragma mark - 点击下一步
-(void)dianjixiayibu{
    //跳到验证码界面
    if (self.textField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    [MBProgressHUD showMessage:@"正在发送" toView:self.view];
    //发送网络请求
    //发送验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.textField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error == nil) {
            //发送成功,做跳转
            [MBProgressHUD hideHUDForView:self.view];
            MLVerificationCodeController *vc = [[MLVerificationCodeController alloc] init];
            vc.shouji = self.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        }else{
            NSLog(@"%@",error);
            //发送失败,给提示
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.userInfo[@"getVerificationCode"] toView:self.view];
            
            
#warning 需要删除的代码
            MLVerificationCodeController *vc = [[MLVerificationCodeController alloc] init];
            vc.shouji = self.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        }
    }];
}
#pragma mark - 限制手机号码只有11位
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.textField == textField) {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 点击医生营养师选择
-(void)dianjixuanzhe{
    NSLog(@"点击选择");
}

#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
@end
