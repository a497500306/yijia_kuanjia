//
//  MLCoreConstController.swift
//  医家
//
//  Created by 洛耳 on 16/1/8.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLCoreConstController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    var sw : UISwitch!
    var zwsw : UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化
        初始化()
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    func 初始化() {
        let tableView : UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //判断是否有密码
        //计算字符串长度
        let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
        if str == nil {//没有密码
            sw.on = false
        }else{
            sw.on = true
        }
    }
    //MARK: - tablview 代理数据源方法
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
        
    }
    
    //每行cell张什么样子
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        cell.textLabel?.font = Theme.中字体
        cell.detailTextLabel?.font = Theme.中字体
        //不可选中状态
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.section == 0 {//第0行,手势密码
            cell.textLabel?.text = "设置手势密码"
            let sw : UISwitch = UISwitch()
            sw.tag = 0 
            self.sw = sw
            sw.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 51 - 10, 6, 51, 31)
            sw.addTarget(self, action: "点击滑块:", forControlEvents: UIControlEvents.ValueChanged)
            //判断是否有密码
            //计算字符串长度
            let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
            if str == nil {//没有密码
                sw.on = false
            }else{
                sw.on = true
            }
            cell.contentView.addSubview(sw)
        }else if indexPath.section == 1 {//第1行,指纹密码
            cell.textLabel?.text = "设置指纹密码"
            let sw : UISwitch = UISwitch()
            sw.tag = 1
            self.zwsw = sw
            sw.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 51 - 10, 6, 51, 31)
            sw.addTarget(self, action: "点击滑块:", forControlEvents: UIControlEvents.ValueChanged)
            //判断是否有密码
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().zwjs == nil {//没有开启指纹解锁
                sw.on = false
            }else{
                sw.on = true
            }
            cell.contentView.addSubview(sw)
        }
        return cell
    }
    func 点击滑块(sw : UISwitch){
        if sw.tag == 0 {
            if sw.on == true {//设置密码
                let gestureVc :GestureViewController = GestureViewController()
                gestureVc.type = GestureViewControllerTypeSetting
                self.navigationController?.pushViewController(gestureVc, animated: true)
            }else{//删除密码
                //清除之前存储的密码
                PCCircleViewConst.saveGesture(nil, key: gestureFinalSaveKey)
                //清除之前存储的密码
                MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
                MLUserInfo.sharedMLUserInfo().zwjs = nil
                MLUserInfo.sharedMLUserInfo().saveUserInfoToSanbox()
                self.zwsw.on = false
            }
        }else if sw.tag == 1 {
            //判断是否支持指纹解锁
            if #available(iOS 8.0, *) {
                let authenticationContext = LAContext()
                var error: NSError?
                let isTouchIdAvailable = authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics,
                    error: &error)
                
                if isTouchIdAvailable
                {
                    NSLog("恭喜，Touch ID可以使用！")
                }else{//不能使用指纹解锁
                    let alertView = UIAlertView()
                    alertView.message = "您的iphone不支持指纹"
                    alertView.addButtonWithTitle("确定")
                    alertView.show()
                    sw.on = false
                    return
                }
            } else {//不能使用指纹解锁
                let alertView = UIAlertView()
                alertView.message = "您的iphone不支持指纹"
                alertView.addButtonWithTitle("确定")
                alertView.show()
                sw.on = false
                return
            }
            //判断是否打开了手势密码
            //计算字符串长度
            let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
            if str == nil {//没有密码,不能使用指纹解锁
                let alertView = UIAlertView()
                alertView.message = "请先设置手势解锁"
                alertView.addButtonWithTitle("确定")
                alertView.show()
                sw.on = false
                return
            }
            if sw.on == true {//设置密码
                MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
                MLUserInfo.sharedMLUserInfo().zwjs = "是"
                MLUserInfo.sharedMLUserInfo().saveUserInfoToSanbox()
            }else{//删除密码
                //清除之前存储的密码
                MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
                MLUserInfo.sharedMLUserInfo().zwjs = nil
                MLUserInfo.sharedMLUserInfo().saveUserInfoToSanbox()
            }
        }
    }
}