//
//  MLTbckController.m
//  医家
//
//  Created by 洛耳 on 16/1/21.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLTbckController.h"
#import "PNChart.h"
#import "NSDate+MJ.h"
#import "IWHttpTool.h"
#import "MLJson.h"
#import "MLTbckModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"//json解析
#import "MBProgressHUD+MJ.h"
#import "yijia-Swift.h"

@interface MLTbckController () < UIActionSheetDelegate , UITableViewDelegate , UITableViewDataSource>
@property (nonatomic )PNLineChart *lineChart;
@property (nonatomic , weak)UIButton *btn;
@property (nonatomic , copy)NSString *dateStr;
@property (nonatomic , assign)BOOL isNew;
@property (nonatomic , weak)UITableView *tableView;
@property (nonnull )PNPieChart *pieChart;
/**
 *  时间数组
 */
@property (nonatomic , strong)NSMutableArray *dateArray;
/**
 *  选项数组
 */
@property (nonatomic , strong)NSMutableArray *dataArray;
/**
 *  饼状图
 */
@property (nonatomic , strong)NSMutableArray *intArray;
@end

@implementation MLTbckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图表查看";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    [self chushihua];
    //取出数据库
    [self clonData];
    //开始下拉刷新
    [self.tableView.header beginRefreshing];
}
#pragma mark - 取出数据库
-(void)clonData{
    [MLTbckModel selectWhere:nil groupBy:nil orderBy:@"hostID" limit:nil selectResultsBlock:^(NSArray *selectResults) {
        //主线程刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (selectResults == nil) {
                return;
            }
            
            //解析数据
            self.dateArray = [NSMutableArray array];
            self.dataArray = [NSMutableArray array];
            self.intArray = [NSMutableArray array];
            NSMutableDictionary *dict =  [NSMutableDictionary dictionary];
            for (int i = 0; i< selectResults.count; i++) {
                MLTbckModel *tm = selectResults[i];
                [self.dataArray addObject:[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
                [self.dateArray addObject:[NSDate dateStrZhuanDateStrR:tm.createDate]];
                if (i == 0) {
                    [dict setObject:@"1" forKey:[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
                }else{
                    //取出KEY,判断项数是不是等于key,等于key则key的值加1;不等于key,则添加一个
                    NSNumber *xiang =[NSNumber numberWithInteger:[tm.patientStatus intValue]];
                    if ([[dict allKeys] containsObject:[NSNumber numberWithInteger:[tm.patientStatus intValue]]]){
                        NSString *object = dict[[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
                        int  iii = [object intValue] + 1;
                        [dict setObject:[NSString stringWithFormat:@"%d",iii] forKey:[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
                    }else{
                        [dict setObject:@"1" forKey:xiang];
                    }
                }
            }
            NSArray * colorArray = @[PNMauve,PNRed,PNDeepGreen,PNButtonGrey,PNDeepGreen,PNGreen,PNLightBlue,PNBrown,PNYellow,PNPinkGrey,PNBlack,PNiOSGreenColor];
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i<dict.count; i++) {
                [items addObject:[PNPieChartDataItem dataItemWithValue:[[dict allValues][i] intValue] color:colorArray[i] description:[NSString stringWithFormat:@"%@项",[dict allKeys][i]]]];
            }
            [self.pieChart updateChartData:items];
            [self.pieChart strokeChart];
            //解析完成,刷新数据
            [self.lineChart setXLabels:self.dateArray];
            
            PNLineChartData *data01 = [PNLineChartData new];
            data01.dataTitle = @"Alpha";
            data01.color = PNRed;
            data01.alpha = 0.3f;
            data01.itemCount = self.dataArray.count;
            data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
            data01.getData = ^(NSUInteger index) {
                CGFloat yValue = [self.dataArray[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            self.lineChart.chartData = @[data01];
            [self.lineChart strokeChart];
        }];
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    //月份选择按钮
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.btn = btn;
    NSString *dateStr = [[NSDate date] dateZhuangStrNianYue];
    [btn setTitle:dateStr forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:116/255.0 alpha:1];
    [btn addTarget:self action:@selector(dianjishijian) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //创建uitableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y + btn.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - btn.frame.size.height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 230;
    self.tableView = tableView;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.view addSubview:tableView];
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width, 200.0)];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
    self.lineChart.showCoordinateAxis = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
//    self.lineChart.yFixedValueMax = 300.0;
    self.lineChart.yFixedValueMin = 0.0;
    
//    [self.lineChart setYLabels:@[
//                                 @"0 min",
//                                 @"50 min",
//                                 @"100 min",
//                                 @"150 min",
//                                 @"200 min",
//                                 @"250 min",
//                                 @"300 min",
//                                 ]
//     ];
    
    // Line Chart #1
//    NSArray * data01Array = @[@60.1, @160.1, @126.4, @0.0, @186.2, @127.2, @176.2];
//    PNLineChartData *data01 = [PNLineChartData new];
//    data01.dataTitle = @"Alpha";
//    data01.color = PNRed;
//    data01.alpha = 0.3f;
//    data01.itemCount = data01Array.count;
//    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
//    data01.getData = ^(NSUInteger index) {
//        CGFloat yValue = [data01Array[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    
    // Line Chart #2
    //    NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    //    PNLineChartData *data02 = [PNLineChartData new];
    //    data02.dataTitle = @"Beta";
    //    data02.color = PNTwitterColor;
    //    data02.alpha = 0.5f;
    //    data02.itemCount = data02Array.count;
    //    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    //    data02.getData = ^(NSUInteger index) {
    //        CGFloat yValue = [data02Array[index] floatValue];
    //        return [PNLineChartDataItem dataItemWithY:yValue];
    //    };
    
//    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
    
    //画圆形
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
                       ];
    
    
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 200 )/2, 10, 200.0, 200.0) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    [pieChart strokeChart];
    self.pieChart = pieChart;
}
#pragma mark - 点击时间
-(void)dianjishijian{
    self.dateStr = [[NSDate date] dateZhuangStrNianYue];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {//大于8.0
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(0, 0, alert.view.frame.size.width, datePicker.frame.size.height);
        datePicker.maximumDate = [NSDate date];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        //覆盖日的View
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(datePicker.frame.size.width * 2 / 3 - 20, 12, datePicker.frame.size.width/3, datePicker.frame.size.height)];
        view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        [datePicker addSubview:view];
        view.userInteractionEnabled = NO;
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.btn setTitle:self.dateStr forState:UIControlStateNormal];
            //开始下拉刷新
            [self.tableView.header beginRefreshing ];
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert.view addSubview:datePicker];
        [alert addAction:ok];
        [alert addAction:no];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(0, 0, actionSheet.frame.size.width, datePicker.frame.size.height);
        datePicker.maximumDate = [NSDate date];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        //覆盖日的View
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(datePicker.frame.size.width * 2 / 3 - 20, 12, datePicker.frame.size.width/3, datePicker.frame.size.height)];
        view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        [datePicker addSubview:view];
        view.userInteractionEnabled = NO;
        [actionSheet addSubview:datePicker];
    }
}
#pragma mark - 下拉刷新
-(void)loadNewData{
    //网络加载数据
    [self dateHttp];
}
#pragma mark - tableView代理数据源方法
//一共有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.lineChart];
    }else{
        [cell.contentView addSubview:self.pieChart];
    }
    return cell;
}
//显示什么头部标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"患者情绪波动折线图";
    }else{
        return @"稳定情况饼状图";
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 网络
-(void)dateHttp{
    if ( self.isNew == NO) {
        self.dateStr = [[NSDate date] dateZhuangStrNianYue];
    }
    NSDictionary *dict = @{@"patientId":@"1",@"date":self.dateStr};
    NSDictionary *params = @{@"params":[MLJson json:dict]};
    [IWHttpTool postWithURL:@"http://192.168.1.100:8080/yj/app/dailydosage/queryCountDailyDosageContent?" params:params success:^(id json) {
        //关闭下拉刷新
        [self.tableView.header endRefreshing];
        [MLWebModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"data":@"dataList"};
        }];
        MLWebModel *model = [MLWebModel objectWithKeyValues:json];
        if ([model.state isEqualToString:@"9000"] == NO) {
            [MBProgressHUD showError:@"出现异常" toView:self.view];
            return ;
        }
        //转ID
        [MLTbckModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"id":@"hostID"};
        }];
        NSArray *datas = [MLTbckModel objectArrayWithKeyValuesArray:model.data];
        if (self.isNew == NO) {
            self.isNew = YES;
            //删除数据库数据
            [MLTbckModel truncateTable:^(BOOL res) {
                //保存数据库数据
                [MLTbckModel saveModels:datas resBlock:nil];
            }];
        }
        //解析数据
        self.dateArray = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
        self.intArray = [NSMutableArray array];
        NSMutableDictionary *dict =  [NSMutableDictionary dictionary];
        for (int i = 0; i< datas.count; i++) {
            MLTbckModel *tm = datas[datas.count - 1- i];
            [self.dataArray addObject:[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
            [self.dateArray addObject:[NSDate dateStrZhuanDateStrR:tm.createDate]];
            if (i == 0) {
                [dict setObject:@"1" forKey:[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
            }else{
                //取出KEY,判断项数是不是等于key,等于key则key的值加1;不等于key,则添加一个
                NSNumber *xiang =[NSNumber numberWithInteger:[tm.patientStatus intValue]];
                if ([[dict allKeys] containsObject:[NSNumber numberWithInteger:[tm.patientStatus intValue]]]){
                    NSString *object = dict[[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
                    int  iii = [object intValue] + 1;
                    [dict setObject:[NSString stringWithFormat:@"%d",iii] forKey:[NSNumber numberWithInteger:[tm.patientStatus intValue]]];
                }else{
                    [dict setObject:@"1" forKey:xiang];
                }
            }
        }
        NSArray * colorArray = @[PNMauve,PNRed,PNDeepGreen,PNButtonGrey,PNDeepGreen,PNGreen,PNLightBlue,PNBrown,PNYellow,PNPinkGrey,PNBlack,PNiOSGreenColor];
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i<dict.count; i++) {
            [items addObject:[PNPieChartDataItem dataItemWithValue:[[dict allValues][i] intValue] color:colorArray[i] description:[NSString stringWithFormat:@"%@项",[dict allKeys][i]]]];
        }
        [self.pieChart updateChartData:items];
        [self.pieChart strokeChart];
        //解析完成,刷新数据
        [self.lineChart setXLabels:self.dateArray];
        
        PNLineChartData *data01 = [PNLineChartData new];
        data01.dataTitle = @"Alpha";
        data01.color = PNRed;
        data01.alpha = 0.3f;
        data01.itemCount = self.dataArray.count;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [self.dataArray[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        self.lineChart.chartData = @[data01];
        [self.lineChart strokeChart];
        
    } failure:^(NSError *error) {
        //关闭下拉刷新
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma ios7时间
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //开始下拉刷新
        [self.tableView.header beginRefreshing ];
    }
}
#pragma mark - 滚动时间选择
-(void)dateValueChanged:(UIDatePicker *) datePicert{
    NSDate *date = datePicert.date;
    NSString *dateStr = [date dateZhuangStrNianYue];
    self.dateStr = dateStr;
    [self.btn setTitle:self.dateStr forState:UIControlStateNormal];
}
@end
