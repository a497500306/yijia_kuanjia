//
//  MLTsszController.swift
//  医家
//
//  Created by 洛耳 on 16/1/13.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLTsszController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    var tableDatas = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.title = "推送设置"
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化
        初始化()
    }
    //MARK: - 初始化
    func 初始化(){
        self.tableDatas = ["新消息通知","夜间防骚扰模式"]
        let tableView : MLTableView = MLTableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    //MARK: - tablView代理和数据源方法
    //多少组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    //多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //点击每行做什么
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选择
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {//推送设置
                NSLog("点击推送设置")
            }else if indexPath.row == 1 {//字体大小
                NSLog("点击字体大小")
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
        //不可选中状态
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.font = Theme.中字体
        cell.detailTextLabel?.font = Theme.中字体
        if indexPath.section == 0 {//新消息通知
            cell.textLabel?.text = "新消息通知"
            if #available(iOS 8.0, *) {
                //判断是否打开通知
                let setting : UIUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()!
                if UIUserNotificationType.None == setting.types {//未打开通知
                    cell.detailTextLabel?.text = "未开启"
                }else{//打开了通知
                    cell.detailTextLabel?.text = "已开启"
                }
            } else {
                let type : UIRemoteNotificationType = UIApplication.sharedApplication().enabledRemoteNotificationTypes()
                if UIRemoteNotificationType.None == type {//未打开通知
                    cell.detailTextLabel?.text = "未开启"
                }else{//打开了通知
                    cell.detailTextLabel?.text = "已开启"
                }
            }
        }else if indexPath.section == 1 {//夜间防骚扰
            cell.textLabel?.text = "夜间防骚扰"
        }
        return cell
    }
    //第sectuon组显示怎样的头部标题
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
             return "请在iPhone的\"设置\"-\"通知\"中进行修改。"
        }else if section == 1 {
            return "开启\"夜间防骚扰模式\"，医家将自动屏蔽23:00-08:00间的任何提醒。"
        }
        return ""
    }
}
