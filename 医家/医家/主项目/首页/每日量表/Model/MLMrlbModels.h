//
//  MLMrlbModels.h
//  医家
//
//  Created by 洛耳 on 16/1/15.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"
@interface MLMrlbModels : CoreModel
/**
 *  标题文字
 */
@property (nonatomic , copy) NSString * title;
/**
 *  版本号
 */
@property (nonatomic , copy) NSString * versionCode;
/**
 *  选项数组
 */
@property (nonatomic , strong)NSArray * option;
/**
 *  选项数组key
 */
@property (nonatomic , strong)NSArray * optionKey;
@end
