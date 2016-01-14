//
//  MLCoreDataTool.h
//  医家
//
//  Created by 洛耳 on 15/7/15.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MLCoreDataTool : NSObject
/**
 *  创建CoreData
 *
 *  @param name 数据库名字
 */
+ (NSManagedObjectContext *)chuanjianCoreData:(NSString *)name;
/**
 *  查询数据,包括增改操作
 *
 *  @param name 数据库名称
 *  @param bname 表名称
 *  @param dataModel 表Model
 *  @param model 类名
 */
+(NSMutableArray *)chaxunshuju:(NSString *)name andBname:(NSString *)bname andDataModel:(id)dataModel andModel:(id)model;
/**
 *  删除所有数据
 *
 *  @param name  数据库名字
 *  @param bname 表名字
 */
+(void)shanchusuoyoushuju:(NSString *)name andBname:(NSString *)bname;
/**
 *  添加数据
 *
 *  @param name      数据库名字
 *  @param bname     表名字
 *  @param dataModels 数据库model数组
 *  @param models     model数组
 */
+(void)tianjiashuju:(NSString *)name andBname:(NSString *)bname andDataModel:(id)model andModel:(NSMutableArray *)models;
@end
