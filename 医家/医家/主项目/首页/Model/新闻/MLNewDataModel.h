//
//  MLNewDataModel.h
//  医家
//
//  Created by 洛耳 on 16/1/22.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreModel.h"
@interface MLNewDataModel : CoreModel
/**
 *  评论数
 */
@property (nonatomic , copy) NSString * commentNumber;
/**
 *  内容
 */
@property (nonatomic , copy) NSString * content;
/**
 *  时间
 */
@property (nonatomic , copy) NSString * createDate;
/**
 *  URL地址
 */
@property (nonatomic , copy) NSString * hrefUrl;
/**
 *  标题
 */
@property (nonatomic , copy) NSString * title;
/**
 *  标签图片地址
 */
@property (nonatomic , copy) NSString * type;
/**
 *  图片地址
 */
@property (nonatomic , copy) NSString * imgUrl;

@end
