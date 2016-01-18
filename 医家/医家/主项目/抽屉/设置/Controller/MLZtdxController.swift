//
//  MLZtdxController.swift
//  医家
//
//  Created by 洛耳 on 16/1/13.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLZtdxController: UIViewController , UIAlertViewDelegate {
    var xiao : UILabel!
    var zhong : UILabel!
    var da : UILabel!
    var ff : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "字体大小"
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化
        初始化()
    }
    
    //MARK: - 初始化
    func 初始化() {
        let slider : UISlider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 4
        slider.minimumTrackTintColor = Theme.baseBackgroundColor
        slider.frame = CGRectMake(20, 240, UIScreen.mainScreen().bounds.width - 40, 30)
        slider.addTarget(self, action: "updateValue:", forControlEvents: UIControlEvents.ValueChanged)
        //判断slider的初始位置
        MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
        if MLUserInfo.sharedMLUserInfo().ztdx == nil {
            slider.value = 0
            self.ff = 0
        }else{
            NSLog("%@", MLUserInfo.sharedMLUserInfo().ztdx)
            let ii = Int(MLUserInfo.sharedMLUserInfo().ztdx)!
            slider.value = Float(ii)
            self.ff = ii
        }
        self.view.addSubview(slider)
        
        //添加三种字体
        let xiao : UILabel = UILabel()
        xiao.frame = CGRectMake(0, 0, self.view.frame.width, 80)
        xiao.font = Theme.小字体
        xiao.text = "预览字体大小"
        xiao.numberOfLines = 0
        xiao.textColor = Theme.baseBackgroundColor
        xiao.textAlignment = NSTextAlignment.Center
        self.xiao = xiao
        self.view.addSubview(xiao)
        
        let zhong : UILabel = UILabel()
        zhong.frame = CGRectMake(0, 80, self.view.frame.width, 80)
        zhong.font = Theme.中字体
        zhong.numberOfLines = 0
        zhong.text = "拖动下面的滑块,可设置字体大小"
        zhong.textColor = Theme.baseBackgroundColor
        zhong.textAlignment = NSTextAlignment.Center
        self.zhong = zhong
        self.view.addSubview(zhong)
        
        let da : UILabel = UILabel()
        da.frame = CGRectMake(0, 160, self.view.frame.width, 80)
        da.font = Theme.大字体
        da.numberOfLines = 0
        da.text = "医患一家亲--医家"
        da.textColor = Theme.baseBackgroundColor
        da.textAlignment = NSTextAlignment.Center
        self.da = da
        self.view.addSubview(da)
        
//        let btn : UIButton = UIButton()
//        btn.frame = CGRectMake(20, slider.frame.height + slider.frame.origin.y + 25, Theme.pingmuF.width - 40, 38)
//        btn.setTitle("确定", forState: UIControlState.Normal)
//        btn.setBackgroundImage(UIImage(color: Theme.baseBackgroundColor), forState: UIControlState.Normal)
//        //圆角
//        btn.layer.cornerRadius = 5
//        btn.layer.masksToBounds = true
//        btn.addTarget(self, action: "dianjibtn", forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(btn)
//        

    }
    //MARK: - 滑块事件
    func updateValue(value : UISlider) {
        let f = value.value
        let ff = lroundf(f)
        self.xiao.font = UIFont.systemFontOfSize(Theme.小字体F + CGFloat(ff))
        self.zhong.font = UIFont.systemFontOfSize(Theme.中字体F + CGFloat(ff))
        self.da.font = UIFont.systemFontOfSize(Theme.大字体F + CGFloat(ff))
        value.value = Float(ff)
        self.ff = ff
        MLUserInfo.sharedMLUserInfo().loadUserInfoFromSanbox()
        MLUserInfo.sharedMLUserInfo().ztdx = NSString(format: "%d", self.ff) as String
        MLUserInfo.sharedMLUserInfo().saveUserInfoToSanbox()
        Theme.appD.isXgzt = true
        Theme.appD.isHomeXgzt = true
        Theme.appD.isNewsXgzt = true
        Theme.appD.isTestXgzt = true
        Theme.appD.isForumXgzt = true
    }
//    //MARK: - 点击按钮
//    func dianjibtn(){
//        let alertView = UIAlertView()
//        alertView.message = "确定修改后,将退出APP,需要重新打开,程序猿正在努力改进中,望各位大人包含..."
//        alertView.addButtonWithTitle("确定")
//        alertView.addButtonWithTitle("取消")
//        alertView.delegate = self
//        alertView.show()
//        
//    }
//    //MARK: - alertView代理方法
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        if buttonIndex == 0 {
//            UIView.animateWithDuration(1, animations: { () -> Void in
//                Theme.win.alpha = 0
//                Theme.win.frame = CGRectMake(0, Theme.win.bounds.size.width, 0, 0)
//                }, completion: { (an) -> Void in
//                    exit(0)
//            })
//            NSLog("点击确定")
//        }else{
//            NSLog("点击取消")
//        }
//    }
}
