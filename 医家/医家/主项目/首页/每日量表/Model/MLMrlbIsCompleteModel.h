//
//  MLMrlbIsCompleteModel.h
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"
@interface MLMrlbIsCompleteModel : CoreModel
/**
 *  选项数组
 */
@property (nonatomic , strong)NSArray * completes;
/**
 *  标题ID数组
 */
@property (nonatomic , strong)NSArray * textIDs;
/**
 *  时间
 */
@property (nonatomic , strong)NSString * date;
@end
