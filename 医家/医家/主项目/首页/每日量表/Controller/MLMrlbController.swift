//
//  MLMrlbController.swift
//  医家
//
//  Created by 洛耳 on 15/12/31.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLMrlbController: UIViewController , UITableViewDelegate , UITableViewDataSource , UIPickerViewDelegate {
    var tableView : UITableView!
    /// cellFarme组
    var cellFarmes : NSMutableArray! = NSMutableArray()
    /// 模型数组
    var datas : NSMutableArray! = NSMutableArray()
    /// 选择位置
    var row : Int! = 0
    /// 选择框
    var picker : UIPickerView!
    var pickerView : UIView!
    /// 选择提示框
    var textView : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "每日量表"
        self.view.backgroundColor = UIColor.whiteColor()
        //1.初始化
        chushihua()
        //2.取出数据库数据
        cloneData()
        //网络请求
        httpData()
    }
    //MARK: - 取出数据库数据
    func cloneData(){
        //取出数据库  保存的数据
        MLMrlbIsCompleteModel.selectWhere(nil, groupBy: nil, orderBy: "hostID", limit: nil) { (select) -> Void in
            //回主线程
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                MLMrlbModels.selectWhere(nil, groupBy: nil, orderBy: "hostID", limit: nil) { (selectResults) -> Void in
                    //主线程刷新UI
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        if selectResults == nil {
                            return
                        }
                        self.datas = NSMutableArray(array: selectResults)
                        //设置cellFarme
                        let cells : NSMutableArray = NSMutableArray()
                        for var i = 0 ; i < self.datas.count ; i++ {
                            let model : MLMrlbModels = self.datas[i] as! MLMrlbModels
                            let cellM : MLMrlbCellModel = MLMrlbCellModel()
                            cellM.text = model.title
                            let cellF : MLMrlbCellFrame = MLMrlbCellFrame()
                            //判断今天是否保存了数据
                            if select != nil {
                                if  select.count != 0 {
                                    let complete : MLMrlbIsCompleteModel = select[0] as! MLMrlbIsCompleteModel
                                    //判断今天时候填写了量表
                                    let date : NSDate = NSDate().strZhuangDate(complete.date)
                                    if date.isToday() == true  {
                                        cellM.nameID = complete.completes[i] as! NSString
                                        cellM.textID = complete.textIDs[i] as! NSString
                                        //取出nemeID对应的name
                                        for var ii = 0 ; ii < model.optionKey.count ; ii++ {
                                            let key : String = (model.optionKey[ii] as? String)!
                                            if  key == cellM.nameID {
                                              cellM.name = model.option[ii] as! String
                                            }
                                        }
                                    }
                                }
                            }
                            cellF.cellModel = cellM
                            cells.addObject(cellF)
                        }
                        self.cellFarmes = cells
                        //刷新UI
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    //MARK: - 网络请求
    func httpData(){
        //网络请求
        let params : NSMutableDictionary = ["":""]
        IWHttpTool.postWithURL(MLInterface.每日量表接收, params: params as [NSObject : AnyObject], success: { ( json) -> Void in
            let model = MLWebModel(keyValues: json)
            //转ID
            MLMrlbModels.setupReplacedKeyFromPropertyName({ () -> [NSObject : AnyObject]! in
                return ["hostID":"id"]
            })
            let datas : NSMutableArray = MLMrlbModels.objectArrayWithKeyValuesArray(model.data)
            //比较版本号是否一样,一样的话不需要更新数据
            if self.datas.count != 0 {//第一次登陆判断
                let model1 : MLMrlbModels = datas[0] as! MLMrlbModels
                let model2 : MLMrlbModels = self.datas[0] as! MLMrlbModels
                if model1.versionCode == model2.versionCode {
                    return
                }
            }
            self.datas = datas
            //设置cellFarme
            let cells : NSMutableArray = NSMutableArray()
            for var i = 0 ; i < self.datas.count ; i++ {
                let model : MLMrlbModels = self.datas[i] as! MLMrlbModels
                let cellM : MLMrlbCellModel = MLMrlbCellModel()
                cellM.text = model.title
                let cellF : MLMrlbCellFrame = MLMrlbCellFrame()
                cellF.cellModel = cellM
                cells.addObject(cellF)
            }
            self.cellFarmes = cells
            self.tableView.reloadData()
            self.picker.reloadAllComponents()
            //删除数据库
            MLMrlbModels.truncateTable({ (resBlock) -> Void in
                //添加数据到数据库
                MLMrlbModels.saveModels(datas as [AnyObject], resBlock: nil)
            })
            
            
            }) { ( erre ) -> Void in
        }
    }
    //MARK: - 初始化
    func chushihua(){
        //添加右上角历史量表
        let textSize : CGSize = MLGongju().计算文字宽高("历史量表", sizeMake: CGSizeMake(10000, 10000), font: Theme.中字体)
        let righBtn = UIButton(frame: CGRectMake(0, 0, textSize.width, textSize.height))
        righBtn.setTitle("历史量表", forState: UIControlState.Normal)
        righBtn.titleLabel?.font = Theme.中字体
        righBtn.addTarget(self, action: "dianjinishiliangbiao", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarItem = UIBarButtonItem(customView: righBtn)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        let tableView : UITableView = UITableView()
        self.tableView = tableView
        tableView.frame = CGRectMake(0, 0, Theme.pingmuF.width, Theme.pingmuF.height - 64 )
        tableView.delegate = self
        tableView.dataSource = self
        //底部添加"提交"按钮
        let footerView : UIView = UIView(frame: CGRectMake(0, 0, Theme.pingmuF.width - 60, 56))
        footerView.backgroundColor = UIColor.whiteColor()
        let btn : UIButton = UIButton()
        btn.frame = CGRectMake(30, 10, Theme.pingmuF.width - 60, 38)
        btn.setTitle("提交", forState: UIControlState.Normal)
        btn.backgroundColor = Theme.baseBackgroundColor
        //圆角
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: "dianjibtn", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(btn)
        self.tableView.tableFooterView = footerView
        self.view.addSubview(tableView)
        //创建选择器
        let packerView : UIView = UIView()
        self.pickerView = packerView
        packerView.frame = CGRectMake(0,Theme.pingmuF.height, Theme.pingmuF.width, 194 )
        packerView.backgroundColor = UIColor.whiteColor()
        //创建完成按钮
        let packerbtn : UIButton = UIButton()
        packerbtn.frame = CGRectMake(Theme.pingmuF.width - 80, 0, 70, 44)
        packerbtn.setTitle("完成", forState: UIControlState.Normal)
        packerbtn.setTitleColor(Theme.baseBackgroundColor, forState: UIControlState.Normal)
        packerbtn.addTarget(self, action: "点击完成", forControlEvents: UIControlEvents.TouchUpInside)
        packerView.addSubview(packerbtn)
        //添加提示text
        let text : UILabel = UILabel()
        text.frame = CGRectMake(10, 0, Theme.pingmuF.width - packerbtn.frame.width - 30, 44)
        text.textColor = UIColor(red: 84/255.0, green: 84/255.0, blue: 84/255.0, alpha: 1)
        text.numberOfLines = 2
        text.font = Theme.小字体
        self.textView = text
        packerView.addSubview(textView)
        //添加线
        let xian1 : UIView = UIView()
        xian1.frame = CGRectMake(0, 0, Theme.pingmuF.width, 0.5)
        xian1.backgroundColor = UIColor(red: 188/255.0, green: 188/255.0, blue: 189/255.0, alpha: 1)
        packerView.addSubview(xian1)
        let xian2 : UIView = UIView()
        xian2.frame = CGRectMake(0, 43.5, Theme.pingmuF.width, 0.5)
        xian2.backgroundColor = UIColor(red: 188/255.0, green: 188/255.0, blue: 189/255.0, alpha: 1)
        packerView.addSubview(xian2)
        let packer : UIPickerView = UIPickerView()
        packer.frame = CGRectMake(0, 44, Theme.pingmuF.width, 150)
        packer.delegate = self
//        packer.dataSource = self
        self.picker = packer
        packerView.addSubview(packer)
        self.view.addSubview(packerView)
        
    }
    //MARK: - 点击提交按钮
    func dianjibtn(){
        //提交数据
        for var i = 0 ; i<self.cellFarmes.count ; i++ {
            let modelFrame :MLMrlbCellFrame = self.cellFarmes[i] as! MLMrlbCellFrame
            if modelFrame.cellModel.name.isEmpty {
                //还有一项没有填写
                let alertView = UIAlertView()
                alertView.message = "未填写完毕"
                alertView.addButtonWithTitle("确定")
                alertView.show()
                 return
            }
        }
        //用户token
        let dict : NSMutableDictionary = ["patientId":"1"]
        let array : NSMutableArray = NSMutableArray()
        let textArray : NSMutableArray = NSMutableArray()
        for var i = 0 ; i < self.cellFarmes.count ; i++ {
            let modelFrame :MLMrlbCellFrame = self.cellFarmes[i] as! MLMrlbCellFrame
            dict[modelFrame.cellModel.textID] = modelFrame.cellModel.nameID
            //nameID保存到数组
            array.addObject(modelFrame.cellModel.nameID)
            //textID保存到数组
            textArray.addObject(modelFrame.cellModel.textID)
        }
        let params : NSDictionary = ["params":MLJson.json(dict as [NSObject : AnyObject])]
        MBProgressHUD.showMessage("正在提交", toView: self.view)
        IWHttpTool.postWithURL(MLInterface.每日量表提交, params: params as [NSObject : AnyObject], success: { (json) -> Void in
                 print("\(json)")
            let webReturn  = MLWebReturnModel(keyValues: json)
            if webReturn.state == "9000" {
                MBProgressHUD.hideHUDForView(self.view)
                MBProgressHUD.showSuccess(webReturn.msg as String, toView: self.view)
                //提交成功,保存到数据库,进来的时候判断数据库今天是否填写了量表,如果填写了量表则直接显示
                let isComplete : MLMrlbIsCompleteModel = MLMrlbIsCompleteModel()
                isComplete.completes = array as [AnyObject]
                isComplete.textIDs = textArray as [AnyObject]
                isComplete.date = NSDate().dateZhuangStr()
                isComplete.hostID = 1
                //删除所有数据
                MLMrlbIsCompleteModel.truncateTable({ (isTable ) -> Void in
                    //添加数据到数据库
                    MLMrlbIsCompleteModel.insert(isComplete, resBlock: nil)
                })
            }else{
                MBProgressHUD.hideHUDForView(self.view)
                MBProgressHUD.showError(webReturn.msg as String, toView: self.view)
            }
            }) { (error) -> Void in
                MBProgressHUD.hideHUDForView(self.view)
                MBProgressHUD.showError("请检查网络" as String, toView: self.view)
        }
    }
    //MARK: - tableView代理数据源方法
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellFarmes.count
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        //导入模型并更新tableView
        let modelFrame :MLMrlbCellFrame = self.cellFarmes[indexPath.row] as! MLMrlbCellFrame
        let modelData : MLMrlbModels = self.datas[indexPath.row] as! MLMrlbModels
        //点击每日量表弹出选择栏
        self.row = indexPath.row
        self.picker.reloadAllComponents()
        let model :MLMrlbModels = self.datas[indexPath.row] as! MLMrlbModels
        self.textView.text = model.title
        //默认选中
        let nameID : NSString = modelFrame.cellModel.nameID
        var ii : Int = 0;
        for var i = 0 ; i<modelData.optionKey.count ; i++ {
            if nameID == modelData.optionKey[i] as! NSObject{
                ii = i
            }
        }
        self.picker.selectRow(ii, inComponent: 0, animated: true)
        //选择哪一行,通过这一行在数组中获得选中的字
//        let row1 : NSInteger = self.picker.selectedRowInComponent(ii)
        //取出数组中选择的字
        let sele : String = model.option[ii] as! String
        let modelNew : MLMrlbCellModel = MLMrlbCellModel()
        modelNew.text = modelFrame.cellModel.text
        modelNew.name = sele
        modelNew.nameID = model.optionKey[ii] as! String
        modelNew.textID = String(stringInterpolationSegment: model.hostID)
        modelFrame.cellModel = modelNew
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        if self.pickerView.frame.origin.y > Theme.pingmuF.height - 80 {//在底下
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.pickerView.frame = CGRectMake(0, self.view.frame.height - 150 - 44, Theme.pingmuF.width, 194 )
            })
        }
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = MLMrlbCell()
        let modelFrame :MLMrlbCellFrame = self.cellFarmes[indexPath.row] as! MLMrlbCellFrame
        cell.modelFrame = modelFrame
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let modelFrame :MLMrlbCellFrame = self.cellFarmes[indexPath.row] as! MLMrlbCellFrame
        return modelFrame.cellH
    }
    //MARK: - 选择器代理数据源方法
    //多少行
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.datas.count == 0 {
            return 0
        }
        let model : MLMrlbModels = self.datas[self.row] as! MLMrlbModels
        return model.option.count
    }
    // 每行显示什么内容
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let model : MLMrlbModels = self.datas[self.row] as! MLMrlbModels
//        return model.option[row] as? String
//    }
    // 每行显示什么View
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        //选项
        let btn: UIButton = UIButton()
        btn.userInteractionEnabled = false
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = Theme.大字体
        btn.titleLabel?.numberOfLines = 0
        let model :MLMrlbModels = self.datas[self.row] as! MLMrlbModels
        let sele : String = model.option[row] as! String
        if sele == "是" {
            btn.setImage(UIImage(named: "正确"), forState: UIControlState.Normal)
            btn.setTitle("    是", forState: UIControlState.Normal)
        }else if sele == "否"{
            btn.setImage(UIImage(named: "错误"), forState: UIControlState.Normal)
            btn.setTitle("    否", forState: UIControlState.Normal)
        }else{
            btn.setImage(UIImage(), forState: UIControlState.Normal)
            btn.setTitle(sele, forState: UIControlState.Normal)
        }
        return btn
    }
    //选中了哪行
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //选择哪一行,通过这一行在数组中获得选中的字
        let model :MLMrlbModels = self.datas[self.row] as! MLMrlbModels
        let row1 : NSInteger = self.picker.selectedRowInComponent(0)
        let sele : String = model.option[row1] as! String
        //导入模型并更新tableView
        let indexPath : NSIndexPath = NSIndexPath(forRow: self.row, inSection: 0)
        let modelFrame :MLMrlbCellFrame = self.cellFarmes[indexPath.row] as! MLMrlbCellFrame
        let modelNew : MLMrlbCellModel = MLMrlbCellModel()
        modelNew.text = modelFrame.cellModel.text
        modelNew.name = sele
        modelNew.nameID = model.optionKey[row1] as! String
        modelNew.textID = String(stringInterpolationSegment: model.hostID)
        modelFrame.cellModel = modelNew
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    //MARK: - 点击选择栏完成
    func 点击完成(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.pickerView.frame = CGRectMake(0, self.view.frame.height, Theme.pingmuF.width, 194 )
        })
    }
    //MARK: - 点击历史量表
    func dianjinishiliangbiao(){
        let mrilb = MLLslbController()
        mrilb.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mrilb, animated: true)
        mrilb.hidesBottomBarWhenPushed = false
    }
}
