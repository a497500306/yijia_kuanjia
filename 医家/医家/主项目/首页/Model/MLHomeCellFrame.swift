//
//  MLHomeCellFrame.swift
//  医家
//
//  Created by 洛耳 on 15/12/29.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit
let 间距 : CGFloat = 5
class MLHomeCellFrame: NSObject {
    /// 图片Frame
    var cellImageViewFrame : CGRect! = CGRect()
    /// 标题文字Frame
    var cellNameFrame : CGRect! = CGRect()
    /// 内容文字Frame
    var cellNeirongFrame : CGRect! = CGRect()
    /// 时间Frame
    var cellDateFamer : CGRect! = CGRect()
    /// 评论数Frame
    var cellPinglunsFrame : CGRect! = CGRect()
    /// 标示图片,标示广告,调频,视频,文章,等Famer
    var cellBSImageFrame : CGRect! = CGRect()
    /// cell的高度
    var cellH : CGFloat! = CGFloat()
    /// cell Model存放数据
    var cellModel : MLHomeCellModel! = MLHomeCellModel(){
        //在这里设置famer
        didSet{
            //判断是否有图片
            if cellModel.cellImageViewStr != nil{//有图片
                //1.图片frame
                self.cellImageViewFrame = CGRectMake(间距 + 2, 间距 + 2, 80, 70)
            } else {//没有图片
                //1.没有图片时不显示图片
                self.cellImageViewFrame = CGRectMake(0, 0, 0, 0)
            }
            //2.标题文字frame
            //2.1计算文字
            let attrs = [NSFontAttributeName:
                Theme.大字体]
            let nameMaxSize = CGSizeMake(100000, 100000)
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let nameSize = self.cellModel.cellNameStr.boundingRectWithSize(nameMaxSize, options:option, attributes: attrs, context: nil).size
            //2.2设置frame
            self.cellNameFrame = CGRectMake(self.cellImageViewFrame.width + self.cellImageViewFrame.origin.x + 间距, 间距, UIScreen.mainScreen().bounds.width - self.cellImageViewFrame.width - self.cellImageViewFrame.origin.y - 间距 - 间距, nameSize.height)
            
            //4.内容文字framer
            //4.1计算内容文字
            let attrs1 = [NSFontAttributeName:
                Theme.中字体]
            let neirongMaxSize = CGSizeMake(10000, 100000)
            let neirongSize = "在这一期，我们将教授大家心理治疗技术（认知行为疗法）中的".boundingRectWithSize(neirongMaxSize, options:option, attributes: attrs1, context: nil).size
            self.cellNeirongFrame = CGRectMake(self.cellNameFrame.origin.x, self.cellNameFrame.origin.y + self.cellNameFrame.height + 间距, self.cellNameFrame.width, neirongSize.height * 2)
            
            //5.时间frame
            //5.1计算时间宽高
            let dateSize = MLGongju().计算文字宽高(self.cellModel.cellNameStr, sizeMake: CGSizeMake(10000, 10000), font: Theme.中字体)
            self.cellDateFamer = CGRectMake(self.cellNameFrame.origin.x, self.cellNeirongFrame.origin.y + self.cellNeirongFrame.height + 间距, dateSize.width, dateSize.height)
            
            //6.标识frame
            let 标识宽 = CGFloat (32)
            let 标识高 = CGFloat (dateSize.height)
            self.cellBSImageFrame = CGRectMake(UIScreen.mainScreen().bounds.width - 间距 - 标识宽, self.cellDateFamer.origin.y, 标识宽, 标识高)
            
            //7.评论数frame
            //7.1计算评论数宽高
            let pinglunSize = MLGongju().计算文字宽高(self.cellModel.cellPinglunsStr, sizeMake: CGSizeMake(10000, 10000), font: Theme.中字体)
            self.cellPinglunsFrame = CGRectMake(self.cellBSImageFrame.origin.x - 间距 - pinglunSize.width, self.cellDateFamer.origin.y, pinglunSize.width, pinglunSize.height)
            //8.cell的高度
            self.cellH = self.cellDateFamer.origin.y + self.cellDateFamer.height + 间距
        }
    }
}
