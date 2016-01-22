//
//  MLLsmrController.swift
//  医家
//
//  Created by 洛耳 on 16/1/21.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLLsmrController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    /// cellFarme组
    var cellFarmes : NSMutableArray! = NSMutableArray()
    var model : MLLslbModel! = MLLslbModel()
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化
        chushihua()
        MBProgressHUD.showMessage(nil, toView: self.view)
        let dict : NSMutableDictionary = ["patientId":"1" , "id" : model.hostID]
        let params : NSDictionary = ["params":MLJson.json(dict as [NSObject : AnyObject])]
        IWHttpTool.postWithURL(MLInterface.历史量表某日, params: params as [NSObject : AnyObject], success: { (json) -> Void in
            MBProgressHUD.hideHUDForView(self.view)
            let model = MLWebLsmrModel(keyValues: json)
            if model.state != "9000" {
                MBProgressHUD.showError(model.msg as String, toView: self.view)
                return
            }
            let dataModel : MLLsmrNameModel = MLLsmrNameModel(keyValues: model.data)
            let xxDatas : NSMutableArray = MLLsmrXXModel.objectArrayWithKeyValuesArray(model.titleData)
            //截取选项ID数组
            //切个字符串
            let nameIDArray : NSArray = dataModel.title.componentsSeparatedByString(",")
            //截取选项数组
            let  nameArray: NSArray = dataModel.value.componentsSeparatedByString(",")
            //截取选项数组
            let keyArray : NSArray = dataModel.key.componentsSeparatedByString(",")
            //截取选项
            for var i = 0 ; i < xxDatas.count ; i++ {
                let textModel : MLLsmrXXModel = xxDatas[i] as! MLLsmrXXModel
                let cellM : MLMrlbCellModel = MLMrlbCellModel()
                let cellF : MLMrlbCellFrame = MLMrlbCellFrame()
                cellM.text = textModel.title
                cellM.textID = textModel.id
                for var ii = 0 ; ii < xxDatas.count ; ii++ {
                    let keyStr : String = keyArray[ii] as! String
                    if keyStr == textModel.id {
                        cellM.name = nameArray[ii] as! String
                        cellM.nameID = nameIDArray[ii] as! String
                    }
                }
                cellF.cellModel = cellM
                self.cellFarmes.addObject(cellF)
            }
            self.tableView.reloadData()
            }) { (error) -> Void in
                MBProgressHUD.hideHUDForView(self.view)
                MBProgressHUD.showMessage("请检查网络", toView: self.view)
        }
    }
    //MARK: - 初始化
    func chushihua(){
        let tableView : UITableView = UITableView()
        let view : UIView = UIView()
        tableView.tableFooterView = view
        self.tableView = tableView
        tableView.frame = CGRectMake(0, 0, Theme.pingmuF.width, Theme.pingmuF.height - 64 )
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
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
}
