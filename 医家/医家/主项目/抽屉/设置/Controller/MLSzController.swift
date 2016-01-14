//
//  MLSzController.swift
//  医家
//
//  Created by 洛耳 on 16/1/13.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLSzController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    var tableDatas = NSMutableArray()
    var tableView = MLTableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化
        初始化()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //修改字体大小
        if Theme.appD.isXgzt == true {
            Theme.appD.isXgzt = false
            self.tableView.reloadData()
        }
    }
    //MARK: - 初始化
    func 初始化(){
        self.tableDatas = ["推送设置","字体大小","去评分","意见反馈","清除缓存","退出登陆"]
        let tableView : MLTableView = MLTableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
    }
    //MARK: - tablView代理和数据源方法
    //多少组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 3
        }else {
            return 1
        }
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {//推送设置
                NSLog("点击推送设置")
                let tssz : MLTsszController = MLTsszController()
                tssz.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(tssz, animated: true)
     
            }else if indexPath.row == 1 {//字体大小
                NSLog("点击字体大小")
                let tssz : MLZtdxController = MLZtdxController()
                tssz.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(tssz, animated: true)
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {//去评分
                NSLog("点击去评分")
            }else if indexPath.row == 1 {//您的建议
                NSLog("点击您的建议")
            }else if indexPath.row == 2 {//您的建议
                NSLog("点击清除缓存")
            }
        }else {//退出登陆
            NSLog("点击退出登陆")
        }
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.textLabel?.font = Theme.中字体
        cell.detailTextLabel?.font = Theme.中字体
        //不可选中状态
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.section == 0 {
            if indexPath.row == 0 {//推送设置
                cell.textLabel!.text = self.tableDatas[0] as? String
            }else if indexPath.row == 1 {//字体大小
                cell.textLabel!.text = self.tableDatas[1] as? String
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {//去评分
                cell.textLabel!.text = self.tableDatas[2] as? String
            }else if indexPath.row == 1 {//您的建议
                cell.textLabel!.text = self.tableDatas[3] as? String
            }else if indexPath.row == 2 {//您的建议
                cell.textLabel!.text = self.tableDatas[4] as? String
            }
        }else {//退出登陆
            let cell = UITableViewCell()
//            cell.textLabel?.font = Theme.中字体
//            cell.detailTextLabel?.font = Theme.中字体
            //不可选中状态
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel!.text = self.tableDatas[5] as? String
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.textColor = UIColor.redColor()
            return cell
        }
        return cell
    }
}
