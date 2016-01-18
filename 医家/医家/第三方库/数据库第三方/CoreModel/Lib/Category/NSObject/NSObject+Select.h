//
//  NSObject+Select.h
//  CoreModel
//
//  Created by muxi on 15/3/30.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  查询数据

#import <Foundation/Foundation.h>

@interface NSObject (Select)


/**
 *
 *  @param where              还不知道
 *  @param groupBy            组
 *  @param orderBy            顺序
 *  @param limit              还不知道
 *  @param selectResultsBlock 返回结果
 */
+(void)selectWhere:(NSString *)where groupBy:(NSString *)groupBy orderBy:(NSString *)orderBy limit:(NSString *)limit selectResultsBlock:(void(^)(NSArray *selectResults))selectResultsBlock;


+(void)find:(NSUInteger)hostID selectResultBlock:(void(^)(id selectResult))selectResultBlock;








@end
