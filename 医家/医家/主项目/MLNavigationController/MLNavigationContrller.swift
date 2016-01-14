//
//  MLNavigationContrller.swift
//  医家
//
//  Created by 洛耳 on 15/12/7.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLNavigationContrller: UINavigationController , UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //清楚黑线,主要代码在MLNavigationBar中
        let navigationBar:MLNavigationBar! = self.navigationBar as! MLNavigationBar
        navigationBar.hideBottomHairline()
        
        //设置主题颜色
        self.navigationBar.barTintColor = UIColor(red: 3/255.0, green: 166/255.0, blue: 116/255.0, alpha: 1.0)
        
        //UINavigationBar不透明
        self.navigationBar.translucent = false;
        
        //设置标题文字颜色
        //字体颜色
        let attributes = NSMutableDictionary()
        attributes.setValue(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        self.navigationBar.titleTextAttributes = attributes as NSDictionary as? [String : AnyObject]
        
        //设置按钮文字颜色
        self.navigationBar.tintColor = UIColor.whiteColor();
        
        //        //消除下滑线
        //        // 给导航条的背景图片传递一个空图片的UIImage对象
        //        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //        // 隐藏底部阴影条，传递一个空图片的UIImage对象
        //        self.navigationBar.shadowImage = UIImage()

    }
}
