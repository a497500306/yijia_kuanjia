//
//  MLTabBarController.swift
//  医家
//
//  Created by 洛耳 on 15/12/21.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let item =  self.tabBar.items![0]
        let image = UIImage(named: "首页_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let seleImage = UIImage(named: "首页_pre")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item.selectedImage = seleImage
        item.image = image
        item.title = "首页"
        let attributes = NSMutableDictionary()
        attributes.setValue(UIColor(red: 3/255.0, green: 166/255.0, blue: 116/255.0, alpha: 1), forKey: NSForegroundColorAttributeName)
        item.setTitleTextAttributes(attributes as NSDictionary as? [String : AnyObject], forState: UIControlState.Selected)
        
        
        
        let item1 =  self.tabBar.items![1]
        let image1 = UIImage(named: "论坛_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let seleImage1 = UIImage(named: "论坛_pre")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item1.selectedImage = seleImage1
        item1.image = image1
        item1.title = "论坛"
        item1.setTitleTextAttributes(attributes as NSDictionary as? [String : AnyObject], forState: UIControlState.Selected)
        
        
        let item2 =  self.tabBar.items![2]
        let image2 = UIImage(named: "测试_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let seleImage2 = UIImage(named: "测试_pre")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item2.selectedImage = seleImage2
        item2.title = "测试"
        item2.image = image2
        item2.setTitleTextAttributes(attributes as NSDictionary as? [String : AnyObject], forState: UIControlState.Selected)
        
        
        let item3 =  self.tabBar.items![3]
        let image3 = UIImage(named: "消息_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let seleImage3 = UIImage(named: "消息_pre")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item3.selectedImage = seleImage3
        item3.image = image3
        item3.title = "消息"
        item3.setTitleTextAttributes(attributes as NSDictionary as? [String : AnyObject], forState: UIControlState.Selected)
    }
}
