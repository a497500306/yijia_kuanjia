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
@end
