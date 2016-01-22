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
    static var 每日量表判断 : String = "http://192.168.1.100:8080/yj/app/dailydosage/getThisDailyDosageContent?"
    static var 历史量表 : String = "http://192.168.1.100:8080/yj/app/dailydosage/queryDailyDosageContent?"
    static var TXLB : String = "http://192.168.1.100:8080/yj/app/dailydosage/queryCountDailyDosageContent?"
    static var 历史量表某日 : String = "http://192.168.1.100:8080/yj/app/dailydosage/getByDailyDosageContent?"
    static var 新闻 : String = "http://192.168.1.100:8080/yj/app/patientnews/query?"
 /// 注册
    static var zc : String = "http://192.168.1.100:8080/yj/app/patient/patientIdCard?"
 /// 修改密码
    static var xgmm : String = "http://192.168.1.100:8080/yj/app/patient/userUpdatePassword"
    static var sfxz : String = "http://192.168.1.100:8080/yj/app/patient/registerType"
    static var dl : String = "http://192.168.1.100:8080/yj/app/patient/login"
    
}
