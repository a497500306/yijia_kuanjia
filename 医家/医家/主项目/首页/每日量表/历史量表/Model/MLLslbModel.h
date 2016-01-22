//
//  MLLslbModel.h
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"
@interface MLLslbModel : CoreModel
/**
 *  时间
 */
@property (nonatomic , copy) NSString * createDate;
/**
 *  患者ID
 */
@property (nonatomic , copy) NSString * patientId;
/**
 *  RGB颜色
 */
@property (nonatomic , strong)NSString * colour;
/**
 *  显示内容
 */
@property (nonatomic , copy) NSString * patientStatus;

@end
