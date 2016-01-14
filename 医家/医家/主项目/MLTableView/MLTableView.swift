//
//  MLTableView.swift
//  医家
//
//  Created by 洛耳 on 16/1/13.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLTableView: UITableView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //解决按钮不响应滑动问题
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        super.touchesShouldCancelInContentView(view)
        return true
    }
    

}
