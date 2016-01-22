//
//  MLLslbController.swift
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLLslbController: UIViewController , UITableViewDelegate , UITableViewDataSource , UIActionSheetDelegate{
    //是否是第一次进入
    var isNew : Bool! = true
    var tableView : UITableView!
    var tableArray : NSMutableArray = NSMutableArray()
    //时间
    var dateStr : NSString! = NSString()
    //时间选择按钮
    var btn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史量表"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        //添加右上角图标查看
        let textSize : CGSize = MLGongju().计算文字宽高("图表查看", sizeMake: CGSizeMake(10000, 10000), font: Theme.中字体)
        let righBtn = UIButton(frame: CGRectMake(0, 0, textSize.width, textSize.height))
        righBtn.setTitle("图表查看", forState: UIControlState.Normal)
        righBtn.titleLabel?.font = Theme.中字体
        righBtn.addTarget(self, action: "dianjinishiliangbiao", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarItem = UIBarButtonItem(customView: righBtn)
        self.navigationItem.rightBarButtonItem = rightBarItem
        //初始化
        chushihua()
        //取出数据库
        cloneData()
        //开始下拉刷新
        self.tableView.header.beginRefreshing()
    }
    
    //MARK: - 初始化
    func chushihua(){
        //月份选择按钮
        let btn : UIButton = UIButton()
        self.btn = btn
        btn.frame = CGRectMake(0, 0, Theme.pingmuF.width, 44)
        let str = NSDate().dateZhuangStrNianYue()
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.backgroundColor = Theme.baseBackgroundColor
        btn.addTarget(self, action: "dianjishijian", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        self.tableView = UITableView(frame: CGRectMake(0, btn.frame.height, Theme.pingmuF.width, Theme.pingmuF.height - 64 - btn.frame.height), style: UITableViewStyle.Plain)
        let view : UIView = UIView()
        self.tableView.tableFooterView = view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //下拉刷新
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.view.addSubview(self.tableView)
    }
    //MARK: - 下拉刷新
    func loadNewData(){
        //网络请求
        if self.isNew == true {
            self.dateStr = NSDate().dateZhuangStrNianYue()
        }
        let dict : NSMutableDictionary = ["patientId":"1" , "date" : self.dateStr]
        let params : NSDictionary = ["params":MLJson.json(dict as [NSObject : AnyObject])]
        IWHttpTool.postWithURL(MLInterface.历史量表, params: params as [NSObject : AnyObject], success: { (json ) -> Void in
            print("\(json)")
            //关闭下拉刷新
            self.tableView.header.endRefreshing()
            MLWebModel.setupReplacedKeyFromPropertyName({ () -> [NSObject : AnyObject]! in
                return ["data":"dataList"]
            })
            let model = MLWebModel(keyValues: json)
            if model.state != "9000" {
                MBProgressHUD.showError("不明的问题,开发人员要减薪了!", toView: self.view)
                return
            }
            //转ID
            MLLslbModel.setupReplacedKeyFromPropertyName({ () -> [NSObject : AnyObject]! in
                return ["id":"hostID"]
            })
            let datas : NSMutableArray = MLLslbModel.objectArrayWithKeyValuesArray(model.data)
            if self.isNew == true {
                self.isNew = false
                //删除数据库全部数据
                MLLslbModel.truncateTable({ (resBlock) -> Void in
                    //添加数据到数据库
                    MLLslbModel.saveModels(datas as [AnyObject], resBlock: nil)
                })
            }
            self.tableArray = datas
            self.tableView.reloadData()
            
            }, failure: { (error) -> Void in
                //关闭下拉刷新
                self.tableView.header.endRefreshing()
                MBProgressHUD.showError("请检查网络", toView: self.view)
        })
    }
    //MARK: - 数据库
    func cloneData(){
        //取出数据库
        MLLslbModel.selectWhere(nil, groupBy: nil, orderBy: "hostID", limit: nil) { (selectResults) -> Void in
            //主线程刷新UI
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if selectResults == nil {
                    return
                }
                self.tableArray = (NSMutableArray)(array: selectResults)
                self.tableView.reloadData()
            })
        }
    }
    //MARK: - tableView代理数据源方法
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let model : MLLslbModel = self.tableArray[indexPath.row] as! MLLslbModel
        let mrilb = MLLsmrController()
        let date : NSDate = NSDate.strZhuanDateCN(model.createDate)
        let dateStr : NSString = NSDate.DateZhuanStrCN(date)
        mrilb.title = dateStr as String
        mrilb.hidesBottomBarWhenPushed = true
        mrilb.model = model
        self.navigationController?.pushViewController(mrilb, animated: true)
        mrilb.hidesBottomBarWhenPushed = false
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let ID  = "cell"
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(ID)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: ID)
        }
        let model : MLLslbModel = self.tableArray[indexPath.row] as! MLLslbModel
        //切个字符串
        let strArray : NSArray = model.colour.componentsSeparatedByString(",")
        let r : NSString = strArray[0] as! NSString
        let g : NSString = strArray [1] as! NSString
        let b : NSString = strArray [2] as! NSString
        cell.textLabel?.textColor = UIColor(red: CGFloat(r.floatValue)/255.0, green: CGFloat(g.floatValue)/255.0, blue: CGFloat(b.floatValue)/255.0, alpha: 1)
        cell.detailTextLabel?.textColor = UIColor(red: CGFloat(r.floatValue)/255.0, green: CGFloat(g.floatValue)/255.0, blue: CGFloat(b.floatValue)/255.0, alpha: 1)
        let date : NSDate = NSDate.strZhuanDateCN(model.createDate)
        let dateStr : NSString = NSDate.DateZhuanStrCN(date)
        cell.textLabel?.text = dateStr as String
        cell.detailTextLabel?.text = model.patientStatus
        return cell
    }
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    //MARK: - 点击图表查看
    func dianjinishiliangbiao(){
        let mrilb = MLTbckController()
        mrilb.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mrilb, animated: true)
        mrilb.hidesBottomBarWhenPushed = false
    }
    //MARK: - 点击时间
    func dianjishijian(){
        self.dateStr = NSDate().dateZhuangStrNianYue()
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
                self.btn.setTitle(self.dateStr as String, forState: UIControlState.Normal)
                //开始下拉刷新
                self.tableView.header.beginRefreshing()
                
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
            self.btn.setTitle(self.dateStr as String, forState: UIControlState.Normal)
            //打开下拉刷新,并刷新数据
            //开始下拉刷新
            self.tableView.header.beginRefreshing()
        }
    }
    //MARK: - 滚动时间选择
    func dateValueChanged(datePicker : UIDatePicker){
        let date : NSDate = datePicker.date
        let dateStr : String = date.dateZhuangStrNianYue()
        self.dateStr = dateStr
        print("\(dateStr)")
    }
}
