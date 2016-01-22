//
//  MLIDSelectionController.m
//  医家
//
//  Created by 洛耳 on 16/1/22.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLIDSelectionController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MLBindPatientController.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "IWHttpTool.h"
#import "yijia-Swift.h"
#import "MLIDSelectionController.h"
#import "MLUserModel.h"
#import "MLUserInfo.h"

@interface MLIDSelectionController ()<UITableViewDelegate , UITableViewDataSource>

@end

@implementation MLIDSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置右上角的下一步按钮
    self.title =@"身份选择";
    UIBarButtonItem *youBtnBarItem1 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem = youBtnBarItem1;
    //关闭手势退出
    self.fd_interactivePopDisabled = YES;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
//    AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.isUp = YES;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isUp = @"否";
}

//一共有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"患者";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"监护人";
    }else {
        cell.textLabel.text = @"游客";
    }
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showMessage:@"" toView:self.view];
    //发送网络请求
    if (indexPath.row == 0) {//患者
        //跳转到首页
        //取出数据
        [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
        NSDictionary *dict = @{@"id":[MLUserInfo sharedMLUserInfo].user,@"uuid":[MLUserInfo sharedMLUserInfo].token,@"type":@"1"};
        NSDictionary *params = @{@"params":[MLJson json:dict]};
        [IWHttpTool postWithURL:[MLInterface sfxz] params:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            //跳转到首页
            //解析
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
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请检查网络" toView:self.view];
        }];
    }else if (indexPath.row == 1) {//监护人
        [MBProgressHUD hideHUDForView:self.view];
        //跳转到绑定监护患者界面
        //跳到身份选择页面
        MLBindPatientController *vc = [[MLBindPatientController alloc] init];
        vc.shenfenzheng = self.shenfenzheng;
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else {//游客
        //跳转到首页
        //取出数据
        [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
        NSDictionary *dict = @{@"id":[MLUserInfo sharedMLUserInfo].user,@"uuid":[MLUserInfo sharedMLUserInfo].token,@"type":@"3"};
        NSDictionary *params = @{@"params":[MLJson json:dict]};
        [IWHttpTool postWithURL:[MLInterface sfxz] params:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
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
            NSLog(@"%@",json);
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请检查网络" toView:self.view];
        }];
    }
}
@end
