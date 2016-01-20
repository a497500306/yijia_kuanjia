//
//  MLLslbController.swift
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLLslbController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史量表"
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化
        chushihua()
        //网络加载
        dataHttp()
    }
    
    //MARK: - 初始化
    func chushihua(){
        self.tableView = UITableView(frame: CGRectMake(0, 0, Theme.pingmuF.width, Theme.pingmuF.height - 64 - 48), style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    //MARK: - 网络加载
    func dataHttp(){
        //网络请求
        let dict : NSMutableDictionary = ["patientId":"1" , "page" : "1"]
        let params : NSDictionary = ["params":MLJson.json(dict as [NSObject : AnyObject])]
        IWHttpTool.postWithURL(MLInterface.历史量表, params: params as [NSObject : AnyObject], success: { (json ) -> Void in
            print("123\(json)")
            }, failure: { (error) -> Void in
              print("321\(error)")
        })
    }
    //MARK: - 数据库
    func cloneData(){
    
    }
    //MARK: - tableView代理数据源方法
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : UITableViewCell = UITableViewCell()
        return cell
    }
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
