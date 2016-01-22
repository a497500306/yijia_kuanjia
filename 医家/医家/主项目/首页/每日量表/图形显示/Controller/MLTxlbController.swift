//
//  MLTxlbController.swift
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLTxlbController: UIViewController , UIActionSheetDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图表查看"
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化
        chushihua()
    }
    //MARK: - 初始化
    func chushihua(){
        //月份选择按钮
        let btn : UIButton = UIButton()
        btn.frame = CGRectMake(0, 0, Theme.pingmuF.width, 44)
        let str = NSDate().dateZhuangStrNianYue()
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.backgroundColor = Theme.baseBackgroundColor
        btn.addTarget(self, action: "dianjishijian", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        let LineChart = PNLineChart(frame: CGRectMake(0, 100, Theme.pingmuF.width, 200))
        let array : NSArray = ["1日","2日","X3","X4","X5"]
        LineChart.xLabels = array as [AnyObject]
        var dataArray = [5,3,1,2,7]
        let LineData = PNLineChartData()
        LineData.color = UIColor.redColor()
        LineData.itemCount = (UInt)(dataArray.count)
        LineData.getData = ({(index:UInt)->PNLineChartDataItem in
            let y:CGFloat = (CGFloat)(dataArray[(Int)(index)])
            return PNLineChartDataItem(y: y)
        })
        
        LineChart.chartData = [LineData]
        LineChart.strokeChart()
        self.view.addSubview(LineChart)
        /*
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        self.lineChart.yLabelFormat = @"%1.1f";
        self.lineChart.backgroundColor = [UIColor clearColor];
        [self.lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        self.lineChart.showCoordinateAxis = YES;
        
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        self.lineChart.yFixedValueMax = 300.0;
        self.lineChart.yFixedValueMin = 0.0;
        
        [self.lineChart setYLabels:@[
        @"0 min",
        @"50 min",
        @"100 min",
        @"150 min",
        @"200 min",
        @"250 min",
        @"300 min",
        ]
        ];
        
        // Line Chart #1
        NSArray * data01Array = @[@60.1, @160.1, @126.4, @0.0, @186.2, @127.2, @176.2];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.dataTitle = @"Alpha";
        data01.color = PNFreshGreen;
        data01.alpha = 0.3f;
        data01.itemCount = data01Array.count;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart #2
        NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.dataTitle = @"Beta";
        data02.color = PNTwitterColor;
        data02.alpha = 0.5f;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleCircle;
        data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        self.lineChart.chartData = @[data01, data02];
        [self.lineChart strokeChart];
        self.lineChart.delegate = self;
        
        
        [self.view addSubview:self.lineChart];
        */
    }

    //MARK: - 点击时间
    func dianjishijian(){
        if #available(iOS 8.0, *) {
            let alert = UIAlertController.init(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let datePicker : UIDatePicker = UIDatePicker()
            datePicker.frame = CGRectMake(0, 0, alert.view.frame.width,datePicker.frame.height)
            //            datePicker.frame = CGRectMake(0, 0, 100, 100)
            //            datePicker.selectToday()
            datePicker.maximumDate = NSDate()
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            //覆盖日的View
            let view : UIView = UIView()
            view.frame = CGRectMake(datePicker.frame.width * 2 / 3 - 20, 12, datePicker.frame.width/3, datePicker.frame.height)
            view.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)
            view.userInteractionEnabled = false
            datePicker.addSubview(view)
            let ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                //点击确定
                
            })
            let no = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
            alert.view.addSubview(datePicker)
            alert.addAction(ok)
            alert.addAction(no)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            //            [actionSheet showInView:self.view];
            let actionSheet : UIActionSheet = UIActionSheet(title: "\n\n\n\n\n\n\n\n\n\n\n", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
            actionSheet.actionSheetStyle = UIActionSheetStyle.Default
            actionSheet.showInView(self.view)
            let datePicker : UIDatePicker = UIDatePicker()
            datePicker.frame = CGRectMake(0, 0, actionSheet.frame.width,datePicker.frame.height)
            //            datePicker.frame = CGRectMake(0, 0, 100, 100)
            //            datePicker.selectToday()
            datePicker.maximumDate = NSDate()
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            //覆盖日的View
            let view : UIView = UIView()
            view.frame = CGRectMake(datePicker.frame.width * 2 / 3 - 20, 12, datePicker.frame.width/3, datePicker.frame.height - 20)
            view.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)
            datePicker.addSubview(view)
            view.userInteractionEnabled = false
            actionSheet.addSubview(datePicker)
        }
    }
    //MARK: - ios7滚动时间选择
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            print("点击确定")
        }
    }
    //MARK: - 滚动时间选择
    func dateValueChanged(datePicker : UIDatePicker){
        let date : NSDate = datePicker.date
        let dateStr : String = date.dateZhuangStrNianYue()
        print("\(dateStr)")
    }
}
