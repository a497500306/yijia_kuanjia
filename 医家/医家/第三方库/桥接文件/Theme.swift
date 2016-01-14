//
//  Theme.swift
//  医家
//
//  Created by 洛耳 on 16/1/8.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

struct Theme {
    static let baseBackgroundColor = UIColor(red: 3/255.0, green: 166/255.0, blue: 116/255.0, alpha: 1)
    static var 大字体 : UIFont! {
        get{
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().ztdx == nil {
                return UIFont.systemFontOfSize(18)
            }else{
                let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)! + 18
                return UIFont.systemFontOfSize(CGFloat(ii))
            }
        }
    }
    static var 中字体 : UIFont! {
        get{
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().ztdx == nil {
                return UIFont.systemFontOfSize(16)
            }else{
                let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)! + 16
                return UIFont.systemFontOfSize(CGFloat(ii))
            }
        }
    }
    static var 小字体 : UIFont! {
        get{
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().ztdx == nil {
                return UIFont.systemFontOfSize(14)
            }else{
                let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)! + 14
                return UIFont.systemFontOfSize(CGFloat(ii))
            }
        }
    }
    static var 大字体F : CGFloat!{
        get{
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().ztdx == nil {
                return 18
            }else{
                let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)! + 18
                return CGFloat(ii)
            }
        }
    }
    static var 中字体F : CGFloat!{
        get{
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().ztdx == nil {
                return 16
            }else{
                let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)! + 16
                return CGFloat(ii)
            }
        }
    }
    static var 小字体F : CGFloat!{
        get{
            MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
            if MLUserInfo.sharedMLUserInfo().ztdx == nil {
                return 14
            }else{
                let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)! + 14
                return CGFloat(ii)
            }
        }
    }
    static let win : UIWindow = UIApplication.sharedApplication().keyWindow!
    static let appD : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let pingmuF : CGRect = UIScreen.mainScreen().bounds
}