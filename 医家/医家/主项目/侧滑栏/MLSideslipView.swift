//
//  MLSideslipView.swift
//  医家
//
//  Created by 洛耳 on 15/12/10.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLSideslipView: UIView {
    /// 模糊效果
    var toolbar = UIToolbar()
    /// 侧滑栏View
    var contentView : UIView!
    //重写init方法
     init() {
        super.init(frame: CGRectMake( 0 - (UIScreen.mainScreen().bounds.width * 2 / 3), 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height))
        //创建Table
        模糊效果()
        创建contentView()
    }
    
     override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: - 模糊效果
    func 模糊效果 (){
        let toolbar = UIToolbar.init(frame: CGRectMake(UIScreen.mainScreen().bounds.width * 2 / 3, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))
        toolbar.alpha = 0
        toolbar.barStyle = UIBarStyle.Black
        self.toolbar = toolbar
        self.addSubview(toolbar)
        //监听手势
        //监听滑动手势
        self.userInteractionEnabled = false
        let shoushi1 : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "dragCenterView:")
        self.addGestureRecognizer(shoushi1)
        //监听单击手势
        let shoushi : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showHome")
        self.toolbar.addGestureRecognizer(shoushi)
    }
    //MARK:tableview
    func 创建contentView (){
        //初始化数据
        self.contentView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 2 / 3  , UIScreen.mainScreen().bounds.height))
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.addSubview(contentView)
    }
    //MARK:侧滑
    // 用x来判断，用transform来控制
    func dragCenterView(pan:UIPanGestureRecognizer){
        let point = pan.translationInView(pan.view)
        if pan.state == UIGestureRecognizerState.Cancelled || pan.state == UIGestureRecognizerState.Ended{
            if self.frame.origin.x > 0 - UIScreen.mainScreen().bounds.width  / 3  {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.frame = CGRectMake( 0, 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
                    self.toolbar.alpha = 0.9
                    self.toolbar.userInteractionEnabled = true
                })
            }else{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.frame = CGRectMake( 0 - (UIScreen.mainScreen().bounds.width * 2 / 3), 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
                    self.toolbar.userInteractionEnabled = false
                    self.userInteractionEnabled = false
                    self.toolbar.alpha = 0
                })
            }
        }else{
            self.frame.origin = CGPointMake(self.frame.origin.x + point.x, 0)
            let f = (((0 - (UIScreen.mainScreen().bounds.width * 2 / 3)) - self.frame.origin.x) / (0 - (UIScreen.mainScreen().bounds.width * 2 / 3)) * 0.9)
            self.toolbar.alpha = f
            pan.setTranslation(CGPoint.zero, inView: self)
            if (self.frame.origin.x >= 0) {
                self.frame = CGRectMake( 0, 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
            }
        }
    }
    //MARK: - 单击收起手势
    func showHome(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.frame = CGRectMake( 0 - (UIScreen.mainScreen().bounds.width * 2 / 3), 0, UIScreen.mainScreen().bounds.width + (UIScreen.mainScreen().bounds.width * 2 / 3), UIScreen.mainScreen().bounds.height)
            self.toolbar.alpha = 0
            self.userInteractionEnabled = false
            self.toolbar.userInteractionEnabled = false
        })
    }
}
