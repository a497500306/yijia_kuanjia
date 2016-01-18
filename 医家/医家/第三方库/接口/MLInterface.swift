//
//  MLInterface.swift
//  医家
//
//  Created by 洛耳 on 16/1/18.
//  Copyright © 2016年 workorz. All rights reserved.
//

import UIKit

class MLInterface: NSObject {
    static var 轮播图接口 : String = "http://192.168.1.100:8080/yj/app/headnews/query"
    static var 每日量表接收 : String = "http://192.168.1.100:8080/yj/app/dailydosage/template"
    static var 每日量表提交 : String = "http://192.168.1.100:8080/yj/app/dailydosage/saveDailyDosageContent?"
}
