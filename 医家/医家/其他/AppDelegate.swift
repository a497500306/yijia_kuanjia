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
    //是否清除数据,用户注册到选择身份界面退出时
    var isUp:NSString! = "是"
    //地理位子
    var locManager : CLLocationManager!
    var mgr : CLLocationManager!
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //设置状态栏颜色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        // Override point for customization after application launch.
        //高德地图APPKey
//        MAMapServices.sharedServices().apiKey = "64c89bfdec78b2ae4b174d3cbe5c6c4a"
        
        //IOS8,如果想要追踪,要主动请求隐私权限
        self.locManager = CLLocationManager()
        locManager.startUpdatingLocation()
        self.mgr = CLLocationManager()
        if #available(iOS 8.0, *) {
            self.mgr.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        //百度地图APPKey
        let mapManager = BMKMapManager()
        let ret =  mapManager.start("wLlRKjYu9AOGQnwtfUglkdug", generalDelegate: nil)
        if (!ret) {
            
        }
        //MOBSDK
        //启动应用
        ShareSDK.registerApp("ef49d7d88590")
        //启动短信
        SMSSDK.registerApp("eb9a469cc5fd", withSecret: "9f58d435401b8cdeb1f9abb29da382c0")
        //极光推送
        if #available(iOS 8.0, *) {
            //可以添加自定义categories
            JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue, categories: nil)
        } else {
            // Fallback on earlier versions
            //categories 必须为nil
            JPUSHService.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge.rawValue | UIRemoteNotificationType.Badge.rawValue | UIRemoteNotificationType.Alert.rawValue, categories: nil)
        }
        JPUSHService.setupWithOption(launchOptions, appKey: "86535e95726d0de2ea1d204d", channel: "Publish channel", apsForProduction: true)
        //环信注册
        //这里需要推送证书
//        EaseMob.sharedInstance().registerSDKWithAppKey("13055031#yijia", apnsCertName: nil)
//        EaseMobUIClient.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        EaseMobUIClient.sharedInstance().registerForRemoteNotificationsWithApplication(application)//你也可以自己注册APNS
//        EaseMobUIClient.sharedInstance().userDelegate = self //EM_ChatUserDelegate
//        EaseMobUIClient.sharedInstance().oppositeDelegate = self //EM_ChatOppositeDelegate
//        EaseMobUIClient.sharedInstance().notificationDelegate = self//EM_ChatNotificationDelegate
        //判断是否设置自动登陆
//        let isAutoLogin : Bool = EaseMob.sharedInstance().chatManager.isAutoLoginEnabled!
//        if !isAutoLogin {
//            EaseMob.sharedInstance().chatManager.asyncLoginWithUsername("ml", password: "123", completion: { (loginInfo, error ) -> Void in
//                if error == nil {
//                    print("登陆成功")
//                    //开启自动登.想知道什么意思,进去看注释
//                    MLJson.fuckSetIsAutoLoginEnabled()
//                }else{
//                    print("登陆错误\(error.errorCode)")
//                }
//            }, onQueue: nil)
//        }
        
        //友盟统计
        MobClick.startWithAppkey("568dbbd5e0f55a94a000084b", reportPolicy: BATCH, channelId: nil)
        //显示登陆
        MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
        if MLUserInfo.sharedMLUserInfo().token == nil{
            let storayobard = UIStoryboard(name: "logIn", bundle: nil)
            self.window?.rootViewController = storayobard.instantiateInitialViewController()
        }else{
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
        }
     return true
    }

    func applicationWillResignActive(application: UIApplication) {//将进入后台
//        EaseMobUIClient.sharedInstance().applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(application: UIApplication) {//进入后台
//        EaseMobUIClient.sharedInstance().applicationDidEnterBackground(application)
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
//        EaseMobUIClient.sharedInstance().applicationWillEnterForeground(application)
        //登陆时判断是否打开指纹解锁
        MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
        if (MLUserInfo.sharedMLUserInfo().zwjs != nil) {//打开了指纹解锁
            let verify : FingerPrintVerify = FingerPrintVerify()
            verify.verifyFingerprint()
        }
    }
    func applicationDidBecomeActive(application: UIApplication) {//进入前台
//        EaseMobUIClient.sharedInstance().applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(application: UIApplication) {
//        EaseMobUIClient.sharedInstance().applicationWillTerminate(application)
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
    func applicationProtectedDataWillBecomeUnavailable(application: UIApplication) {
//        EaseMobUIClient.sharedInstance().applicationProtectedDataWillBecomeUnavailable(application)
    }
    func applicationProtectedDataDidBecomeAvailable(application: UIApplication) {
//        EaseMobUIClient.sharedInstance().applicationProtectedDataDidBecomeAvailable(application)
    }
    func applicationDidReceiveMemoryWarning(application: UIApplication) {//APP退出
//        EaseMobUIClient.sharedInstance().applicationDidReceiveMemoryWarning(application)
        if self.isUp == "否" {//注册到选择身份退出时
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            MLUserInfo.sharedMLUserInfo().user = nil
            MLUserInfo.sharedMLUserInfo().token = nil
            MLUserInfo.sharedMLUserInfo().zwjs = nil
            MLUserInfo.sharedMLUserInfo().saveUserInfoToSanbox()
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        EaseMobUIClient.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
        // Required获取极光token
        JPUSHService.registerDeviceToken(deviceToken)
        print("\(deviceToken)")
    }
    
    // 当 DeviceToken 获取失败时，系统会回调此方法
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        EaseMobUIClient.sharedInstance().application(application, didFailToRegisterForRemoteNotificationsWithError: error)
        
        print("推送获取失败\(error)")
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //        EaseMobUIClient.sharedInstance().application(application, didReceiveRemoteNotification: userInfo)
        // 处理收到的 APNs 消息
        JPUSHService.handleRemoteNotification(userInfo)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData);
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
//        EaseMobUIClient.sharedInstance().application(application, didReceiveLocalNotification: notification)
    }
    //环信登陆
//    func userForEMChat() -> EM_ChatUser! {
//        let user = EM_ChatUser()
//        user.uid = "ml"
//        user.displayName = "毛哥哥是神"
//        user.intro = "神就是不用吃饭可以带你飞的人"
//        user.avatar = nil
//        return user
//    }
    //ios8推送
    @available(iOS 8.0, *)
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if #available(iOS 8.0, *) {
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
        }
    }
    
}

