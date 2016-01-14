//
//  MLCoreDataTool.m
//  医家
//
//  Created by 洛耳 on 15/7/15.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLCoreDataTool.h"

@implementation MLCoreDataTool
+(NSManagedObjectContext *)chuanjianCoreData:(NSString *)name{
    // 上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    // 上下文关连数据库
    
    // model模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化存储调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 告诉Coredata数据库的名字和路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",doc);
    NSString *sqlitePath = [doc stringByAppendingPathComponent:name];
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    context.persistentStoreCoordinator = store;
    return context;
}
@end
