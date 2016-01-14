//
//  MLNewsController.swift
//  医家
//
//  Created by 洛耳 on 15/12/11.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLNewsController: MLViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.title = "消息"
        //设置左上角的放回按钮
        let righBtn = UIButton(frame: CGRectMake(0, 0, 24, 24))
        righBtn.setBackgroundImage(UIImage(named: "我的"), forState: UIControlState.Normal)
        righBtn.setBackgroundImage(UIImage(named: "我的" ), forState: UIControlState.Highlighted)
        righBtn.addTarget(self, action: "dianjiNavZuoshangjiao", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarItem = UIBarButtonItem(customView: righBtn)
        self.navigationItem.leftBarButtonItem = rightBarItem
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController!.title = "消息"
    }
    //MARK: - 点击左上角个人按钮
    func dianjiNavZuoshangjiao(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            super.sideslipView.frame = CGRectMake( 0, 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
            super.sideslipView.toolbar.alpha = 0.9
            super.sideslipView.userInteractionEnabled = true
            super.sideslipView.toolbar.userInteractionEnabled = true
        })
    }
}
