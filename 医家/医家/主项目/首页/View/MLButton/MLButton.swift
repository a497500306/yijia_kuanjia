//
//  MLButton.swift
//  医家
//
//  Created by 洛耳 on 15/12/21.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        //取出btn的宽高
        //计算显示位置
        let y = (self.frame.height - (self.imageView?.frame.height)! - (self.titleLabel?.frame.height)! - 10)/2
        var center : CGPoint = (self.imageView?.center)!
        center.x = self.frame.size.width / 2
        center.y = (self.imageView?.frame.size.height)! / 2 + y
        self.imageView?.center = center
        
        var newFrame = self.titleLabel?.frame
        newFrame?.origin.x = 0
        newFrame?.origin.y = (self.imageView?.frame.size.height)! + (self.imageView?.frame.origin.y)! + 10
        newFrame?.size.width = self.frame.size.width
        
        self.titleLabel?.frame = newFrame!
        self.titleLabel?.textAlignment = NSTextAlignment.Center
        
    }
}
