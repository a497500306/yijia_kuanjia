//
//  MLTbckModel.h
//  医家
//
//  Created by 洛耳 on 16/1/21.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"

@interface MLTbckModel : CoreModel
/**
 *  时间
 */
@property (nonatomic , copy) NSString * createDate;
/**
 *  患者ID
 */
@property (nonatomic , copy) NSString * patientId;
/**
 *  选项值
 */
@property (nonatomic , copy) NSString * patientStatus;
@end
