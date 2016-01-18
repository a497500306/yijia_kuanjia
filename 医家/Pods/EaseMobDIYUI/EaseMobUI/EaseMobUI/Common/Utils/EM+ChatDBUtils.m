//
//  EM+ChatDBUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatDBUtils.h"
#import "EM+ChatFileUtils.h"

#import "EM_ChatConversation.h"
#import "EM_ChatEmoji.h"
#import "EM_ChatMessage.h"
#import "EM_ChatExtend.h"

#import <CoreData/CoreData.h>

@interface EM_ChatDBUtils()

@property (nonatomic, strong) NSManagedObjectModel *chatManagedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *chatManagedObjectContext;

@property (nonatomic, strong) NSManagedObjectModel *fileManagedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *fileManagedObjectContext;

@property (nonatomic, strong) NSMutableDictionary *entitys;
@property (nonatomic, strong) NSMutableDictionary *requests;

@end

@implementation EM_ChatDBUtils

+ (instancetype)shared{
    static EM_ChatDBUtils *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EM_ChatDBUtils alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 nil];
        
        self.chatManagedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"EM_ChatModel" withExtension:@"momd"]];
        
        NSError *error = nil;
        NSPersistentStoreCoordinator *chatPsc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.chatManagedObjectModel];
        NSPersistentStore *store = [chatPsc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:kChatDBChatPath] options:options error:&error];
        if (!store) {
            [NSException raise:@"添加聊天数据库错误" format:@"%@", [error localizedDescription]];
        }
        self.chatManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.chatManagedObjectContext.persistentStoreCoordinator = chatPsc;
        
        self.entitys = [[NSMutableDictionary alloc]init];
        self.requests = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSFetchRequest *)requestForEntityForName:(NSString *)entityName{
    NSEntityDescription *entity = self.entitys[entityName];
    if (!entity) {
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.chatManagedObjectContext];
        [self.entitys setObject:entity forKey:entityName];
    }
    
    NSFetchRequest *request = self.requests[entityName];
    if (!request) {
        request = [[NSFetchRequest alloc] init];
        [self.requests setObject:request forKey:entityName];
    }
    request.entity = entity;
    
    return request;
}

- (EM_ChatConversation *)insertNewConversation{
    EM_ChatConversation *conversation = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([EM_ChatConversation class]) inManagedObjectContext:self.chatManagedObjectContext];
    return conversation;
}

- (void)deleteConversationWithChatter:(EM_ChatConversation *)conversation{
    if (!conversation) {
        return;
    }
    [self.chatManagedObjectContext deleteObject:conversation];
}

- (EM_ChatConversation *)queryConversationWithChatter:(NSString *)chatter{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'",FIELD_NAME_CHATTER,chatter]];
    NSString *entityName = NSStringFromClass([EM_ChatConversation class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs[0];
}

- (EM_ChatEmoji *)insertNewEmoji{
    EM_ChatEmoji *emoji = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([EM_ChatEmoji class]) inManagedObjectContext:self.chatManagedObjectContext];
    return emoji;
}

- (void)deleteEmoji:(EM_ChatEmoji *)emoji{
    if (!emoji) {
        return;
    }
    [self.chatManagedObjectContext deleteObject:emoji];
}

- (EM_ChatEmoji *)queryEmoji:(NSString *)emoji{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'",FIELD_NAME_EMOJI,emoji]];
    NSString *entityName = NSStringFromClass([EM_ChatEmoji class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs[0];
}

- (NSArray *)queryEmoji{
    NSString *entityName = NSStringFromClass([EM_ChatEmoji class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs;
}

- (EM_ChatMessage *)insertNewMessage{
    EM_ChatMessage *message = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([EM_ChatMessage class]) inManagedObjectContext:self.chatManagedObjectContext];
    return message;
}

- (void)deleteMessage:(EM_ChatMessage *)message{
    if (!message) {
        return;
    }
    [self.chatManagedObjectContext deleteObject:message];
}

- (EM_ChatMessage *)queryMessageWithId:(NSString *)messageId chatter:(NSString *)chatter{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'",FIELD_NAME_MESSAGE,messageId]];
    NSString *entityName = NSStringFromClass([EM_ChatMessage class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs[0];
}

- (NSArray *)queryMessage{
    NSString *entityName = NSStringFromClass([EM_ChatMessage class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs;
}


- (EM_ChatExtend *)insertNewExtend{
    EM_ChatExtend *extend = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([EM_ChatExtend class]) inManagedObjectContext:self.chatManagedObjectContext];
    return extend;
}

- (void)deleteExtend:(EM_ChatExtend *)extend{
    if (!extend) {
        return;
    }
    [self.chatManagedObjectContext deleteObject:extend];
}

- (EM_ChatExtend *)queryExtendWithIdentifier:(NSString *)identifier{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'",FIELD_NAME_IDENTIFIER,identifier]];
    NSString *entityName = NSStringFromClass([EM_ChatExtend class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs[0];
}

- (NSArray *)queryExtend{
    NSString *entityName = NSStringFromClass([EM_ChatExtend class]);
    NSFetchRequest *request = [self requestForEntityForName:entityName];
    
    NSError *error = nil;
    NSArray *objs = [self.chatManagedObjectContext executeFetchRequest:request error:&error];
    if (error || objs.count == 0) {
        return nil;
    }
    return objs;
}

- (void)processPendingChangesChat{
    [self.chatManagedObjectContext processPendingChanges];
}

- (void)saveChat{
    __block NSError *error = nil;
    __block BOOL save = NO;
    if (self.chatManagedObjectContext.hasChanges) {
        [self.chatManagedObjectContext performBlock:^{
            save = [self.chatManagedObjectContext save:&error];
        }];
    }

    if (error || !save) {
        NSLog(@"保存出错 - %@",error);
    }
}

@end