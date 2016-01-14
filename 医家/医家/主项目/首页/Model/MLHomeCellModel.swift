//
//  MLHomeCellModel.swift
//  医家
//
//  Created by 洛耳 on 15/12/29.
//  Copyright © 2015年 workorz. All rights reserved.
//

import UIKit

class MLHomeCellModel: NSObject {
    /// 图片Str
    var cellImageViewStr : String! = nil
    /// 标题文字Str
    var cellNameStr : NSString!
    /// 内容文字Str
    var cellNeirongStr : NSString!
    /// 时间Str
    var cellDateStr : NSString!
    /// 评论数Str
    var cellPinglunsStr : NSString!
    /// 标示图片,标示广告,调频,视频,文章,等Str
    var cellBSImageStr : String!
    /// 跳转URL
    var url : String!
}
