//
//  MLBindPatientController.m
//  医家
//
//  Created by 洛耳 on 16/1/22.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLBindPatientController.h"
#import "MLIDVerificationController.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "IWHttpTool.h"
#import "yijia-Swift.h"
#import "MLIDSelectionController.h"
#import "MLUserModel.h"
#import "MLUserInfo.h"

@interface MLBindPatientController ()
/**
 *  姓名
 */
@property (nonatomic ,weak)UITextField *yanzhemaField;
/**
 *  身份证号码
 */
@property (nonatomic ,weak)UITextField *mimaField;

@end

@implementation MLBindPatientController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self chushihua];
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
    NSString *str = [NSString stringWithFormat:@"请输入需要监护的患者信息"];
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
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"监护的患者姓名" attributes:attrs1];
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
    mimaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"监护的患者身份证号码" attributes:attrs];
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
    if ([self.shenfenzheng isEqualToString:self.mimaField.text] == YES){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能自己监护自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    //网络传数据
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"id":[MLUserInfo sharedMLUserInfo].user,@"uuid":[MLUserInfo sharedMLUserInfo].token,@"type":@"2",@"name":self.yanzhemaField.text,@"idCard":self.mimaField.text};
    NSDictionary *params = @{@"params":[MLJson json:dict]};
    [IWHttpTool postWithURL:[MLInterface sfxz] params:params success:^(id json) {
        //跳转到首页
        [MLWebLsmrModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"data":@"data"};
        }];
        MLWebLsmrModel *model = [MLWebLsmrModel objectWithKeyValues:json];
        if ([model.state isEqualToString:@"9000"]) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.isUp = @"是";
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            [MBProgressHUD showError:model.msg toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
@end
