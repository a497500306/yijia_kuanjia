//
//  MLCoreDataTool.m
//  医家
//
//  Created by 洛耳 on 15/7/15.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLCoreDataTool.h"
#import "MJExtension.h"
#import "sdafadsf.h"
#import "LBData+CoreDataProperties.h"
#import "LBData.h"

@implementation MLCoreDataTool
#pragma mark - 取出数据库
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

#pragma mark - 查询数据
+ (NSMutableArray *)chaxunshuju:(NSString *)name andBname:(NSString *)bname andDataModel:(id)dataModel andModel:(id)model{
    //查询数据
    NSManagedObjectContext * context = [MLCoreDataTool chuanjianCoreData:name];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:bname];
    NSArray *emps = [context executeFetchRequest:request error:nil];
    //将模型数组转字典数组
    NSMutableArray *dictArray = [[dataModel class] keyValuesArrayWithObjectArray:emps];
    //将字典数组转成我们需要的模型数组
    NSMutableArray *modelArray = [[model class] objectArrayWithKeyValuesArray:dictArray];
    return modelArray;
}
#pragma mark - 删除所有数据
+(void)shanchusuoyoushuju:(NSString *)name andBname:(NSString *)bname{
    //查询数据
    NSManagedObjectContext * context = [MLCoreDataTool chuanjianCoreData:name];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:bname];
    NSArray *emps = [context executeFetchRequest:request error:nil];
    if (emps.count > 0) {
        //删除数据
        for (id fe in emps) {
            [context deleteObject:fe];
        }
        // 3.保存
        [context save:nil];
    }
}
#pragma mark - 添加数据
+(void)tianjiashuju:(NSString *)name andBname:(NSString *)bname andDataModel:(id )model andModel:(NSMutableArray *)models{
    NSManagedObjectContext * context = [MLCoreDataTool chuanjianCoreData:name];
    //模型数组转字典数组
    NSMutableArray *array = [[model class] keyValuesArrayWithObjectArray:models];
    id fe = [NSEntityDescription insertNewObjectForEntityForName:bname inManagedObjectContext:context];
    //字典数组转模型数组
    for (NSDictionary *dict in array) {
        LBData * ff = [[fe class] objectWithKeyValues:dict context:context];
        NSLog(@"123%@",ff.hrefUrl);
        //保存数据
        // 直接保存数据库
        NSError *error = nil;
        [context save:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
}
@end
