//
//  MLMrlbCellFrame.swift
//  医家
//
//  Created by 洛耳 on 16/1/15.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLMrlbCellFrame: NSObject {
    /// 标题Frame
    var textFrame : CGRect! = CGRect()
    /// 选项内容Frame
    var nameFrame : CGRect! = CGRect()
    /// btnFrame
    var btnFrame : CGRect! = CGRect()
    /// cell的高度
    var cellH : CGFloat! = CGFloat()
    /// cell Model存放数据
    var cellModel : MLMrlbCellModel! = MLMrlbCellModel(){
        //在这里设置famer
        didSet{
            //计算内容Farme
            //计算文字宽高
            let textSize : CGSize =  MLGongju().计算文字宽高(self.cellModel.text, sizeMake: CGSizeMake(Theme.pingmuF.width - 70, 10000), font: Theme.中字体)
            self.textFrame = CGRectMake(10, 10, textSize.width, textSize.height)
            
            //计算选项Farme
            if cellModel.name.isEmpty {
                self.nameFrame = CGRectMake(10, textFrame.origin.y + textFrame.height + 5, 0, 0)
            }else {
                self.nameFrame = CGRectMake(10, textFrame.origin.y + textFrame.height + 5, Theme.pingmuF.width - 70, 30)
            }
            //高度
            self.cellH = self.nameFrame.origin.y + self.nameFrame.height + 10
            //计算按钮的摆放位置
            self.btnFrame = CGRectMake(Theme.pingmuF.width - 10 - 50, ( self.nameFrame.origin.y + self.nameFrame.height + 10 - 40)/2 , 50, 40)
            
        }
    }
}
