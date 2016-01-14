//
//  MLTableViewController.swift
//  医家
//
//  Created by 洛耳 on 15/12/15.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLTableViewController: UITableViewController {
    var sideslipView = MLSideslipView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //覆盖全屏的View,用来做侧滑栏
        let p:MLSideslipView = MLSideslipView()
        self.sideslipView = p
        self.view.window?.addSubview(p)
        //添加View作为手势响应,放在Controller最下面,所以不影响其他手势执行
        let s:UIView = UIView(frame: self.view.bounds)
        self.tableView.addSubview(s)
        s.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragCenterView:"))
    }
    //MARK: - 侧滑
    // 用x来判断，用transform来控制
    func dragCenterView(pan:UIPanGestureRecognizer){
        let point = pan.translationInView(pan.view)
        if pan.state == UIGestureRecognizerState.Cancelled || pan.state == UIGestureRecognizerState.Ended{
            if self.sideslipView.frame.origin.x > 0 - UIScreen.mainScreen().bounds.width  / 3  {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.sideslipView.frame = CGRectMake( 0, 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
                    self.sideslipView.toolbar.alpha = 0.5
                    self.sideslipView.userInteractionEnabled = true
                    self.sideslipView.toolbar.userInteractionEnabled = true
                })
            }else{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.sideslipView.frame = CGRectMake( 0 - (UIScreen.mainScreen().bounds.width * 2 / 3), 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
                    self.sideslipView.toolbar.alpha = 0
                    self.sideslipView.userInteractionEnabled = false
                    self.sideslipView.toolbar.userInteractionEnabled = false
                })
            }
        }else{
            self.sideslipView.userInteractionEnabled = false
            self.sideslipView.toolbar.userInteractionEnabled = false
            self.sideslipView.frame.origin = CGPointMake(self.sideslipView.frame.origin.x + point.x, 0)
            let f = (((0 - (UIScreen.mainScreen().bounds.width * 2 / 3)) - self.sideslipView.frame.origin.x) / (0 - (UIScreen.mainScreen().bounds.width * 2 / 3)) * 0.5)
            self.sideslipView.toolbar.alpha = f
            pan.setTranslation(CGPoint.zero, inView: self.sideslipView)
            if (self.sideslipView.frame.origin.x >= 0) {
                self.sideslipView.frame = CGRectMake( 0, 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
            }
        }
    }
    //MARK: -
}
