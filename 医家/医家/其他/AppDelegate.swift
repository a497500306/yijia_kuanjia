//
//  AppDelegate.swift
//  医家
//
//  Created by 洛耳 on 15/12/10.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// 判断是否修改了字体
    var isHomeXgzt: Bool! = false
    var isForumXgzt: Bool! = false
    var isNewsXgzt: Bool! = false
    var isTestXgzt: Bool! = false
    var isXgzt: Bool! = false
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //设置状态栏颜色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        // Override point for customization after application launch.
        //高德地图APPKey
//        MAMapServices.sharedServices().apiKey = "64c89bfdec78b2ae4b174d3cbe5c6c4a"
        
        //IOS8,如果想要追踪,要主动请求隐私权限
        let locManager = CLLocationManager()
        locManager.startUpdatingLocation()
        let mgr = CLLocationManager()
        if #available(iOS 8.0, *) {
            mgr.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        //百度地图APPKey
        let mapManager = BMKMapManager()
        let ret =  mapManager.start("wLlRKjYu9AOGQnwtfUglkdug", generalDelegate: nil)
        if (!ret) {
            
        }
        //友盟统计
        MobClick.startWithAppkey("568dbbd5e0f55a94a000084b", reportPolicy: BATCH, channelId: nil)
        //判断是否有密码
        //计算字符串长度
        let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
        if str == nil {//没有密码
            
        }else{//跳转
            let gestureVc :GestureViewController  = GestureViewController()
            gestureVc.isNAV = true
            gestureVc.type = GestureViewControllerTypeLogin
            gestureVc.hidesBottomBarWhenPushed = true
            let homeVc : MLNavigationContrller = self.window!.rootViewController! as! MLNavigationContrller
            homeVc.pushViewController(gestureVc, animated: false)
            //登陆时判断是否打开指纹解锁
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if (MLUserInfo.sharedMLUserInfo().zwjs != nil) {//打开了指纹解锁
                let verify : FingerPrintVerify = FingerPrintVerify()
                verify.isNAV = true
                verify.verifyFingerprint()
            }
        }
     return true
    }

    func applicationWillResignActive(application: UIApplication) {//将进入后台
        
    }

    func applicationDidEnterBackground(application: UIApplication) {//进入后台
        //判断是否有密码
        //计算字符串长度
        let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
        if str == nil {//没有密码
            
        }else{//跳转
            //跳转
            let gestureVc :GestureViewController  = GestureViewController()
            gestureVc.type = GestureViewControllerTypeLogin
            gestureVc.hidesBottomBarWhenPushed = true
            let homeVc : MLNavigationContrller = self.window!.rootViewController! as! MLNavigationContrller
            //取出NAV顶部控制器
            let viewC :UIViewController = homeVc.topViewController!
            //判断类型
            if viewC.isKindOfClass(GestureViewController) {
                NSLog("123%@",viewC)
            }else{
                viewC.presentViewController(gestureVc, animated: false, completion: nil)
            }
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {//即将进入前台
        //登陆时判断是否打开指纹解锁
        MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
        if (MLUserInfo.sharedMLUserInfo().zwjs != nil) {//打开了指纹解锁
            let verify : FingerPrintVerify = FingerPrintVerify()
            verify.verifyFingerprint()
        }
    }
    func applicationDidBecomeActive(application: UIApplication) {//进入前台
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("\(completionHandler)")
    }
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        if shortcutItem.type == "扫一扫" {
            print("点击了扫一扫")
            
        }else if shortcutItem.type == "通知中心" {
            print("通知中心")
            //判断是否有密码
            //计算字符串长度
            let Vc :MLTzzxController  = MLTzzxController()
            Vc.hidesBottomBarWhenPushed = true
            let homeVc : MLNavigationContrller = self.window!.rootViewController! as! MLNavigationContrller
            //取出NAV顶部控制器
            let viewC :UIViewController = homeVc.topViewController!
            //判断类型
            if viewC.isKindOfClass(MLTzzxController) {
            }else{
                homeVc.pushViewController(Vc, animated: false)
            }
            //取出密码
            let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
            if str != nil {//有手势密码
                let gestureVc :GestureViewController  = GestureViewController()
                gestureVc.type = GestureViewControllerTypeLogin
                gestureVc.hidesBottomBarWhenPushed = true
                homeVc.presentViewController(gestureVc, animated: false, completion: nil)
            }
        }else if shortcutItem.type == "每日量表" {
            print("每日量表")
            //判断是否有密码
            //计算字符串长度
            let Vc :MLMrlbController  = MLMrlbController()
            Vc.hidesBottomBarWhenPushed = true
            let homeVc : MLNavigationContrller = self.window!.rootViewController! as! MLNavigationContrller
            //取出NAV顶部控制器
            let viewC :UIViewController = homeVc.topViewController!
            //判断类型
            if viewC.isKindOfClass(MLMrlbController) {
            }else{
                homeVc.pushViewController(Vc, animated: false)
            }
            //取出密码
            let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
            if str != nil {//有手势密码
                let gestureVc :GestureViewController  = GestureViewController()
                gestureVc.type = GestureViewControllerTypeLogin
                gestureVc.hidesBottomBarWhenPushed = true
                homeVc.presentViewController(gestureVc, animated: false, completion: nil)
            }
        }else if shortcutItem.type == "我的医生" {
            print("我的医生")
            //判断是否有密码
            //计算字符串长度
            let Vc :MLWdysController  = MLWdysController()
            Vc.hidesBottomBarWhenPushed = true
            let homeVc : MLNavigationContrller = self.window!.rootViewController! as! MLNavigationContrller
            //取出NAV顶部控制器
            let viewC :UIViewController = homeVc.topViewController!
            //判断类型
            if viewC.isKindOfClass(MLWdysController) {
            }else{
                homeVc.pushViewController(Vc, animated: false)
            }
            //取出密码
            let str  = PCCircleViewConst.getGestureWithKey(gestureFinalSaveKey)
            if str != nil {//有手势密码
                let gestureVc :GestureViewController  = GestureViewController()
                gestureVc.type = GestureViewControllerTypeLogin
                gestureVc.hidesBottomBarWhenPushed = true
                homeVc.presentViewController(gestureVc, animated: false, completion: nil)
            }
        }
    }
    
}

