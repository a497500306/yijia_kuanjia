//
//  MLGongju.swift
//  医家
//
//  Created by 洛耳 on 15/12/30.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLGongju: NSObject {
    /**
     返回字体大小
     
     - parameter str:      需要计算的文字
     - parameter sizeMake: 最大尺寸
     - parameter font:     文字大小方法
     
     - returns: 返回值
     */
    func 计算文字宽高(str : NSString , sizeMake : CGSize , font : UIFont)->(CGSize){
        //2.1计算文字
        let attrs = [NSFontAttributeName:
            font]
        let nameMaxSize = sizeMake
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let nameSize = str.boundingRectWithSize(nameMaxSize, options:option, attributes: attrs, context: nil).size
        return nameSize
    }
}
