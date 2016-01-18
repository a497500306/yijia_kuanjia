//
//  EM+ChatDBUtils.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EM_ChatConversation;
@class EM_ChatEmoji;
@class EM_ChatMessage;
@class EM_ChatExtend;

@interface EM_ChatDBUtils : NSObject

+ (instancetype)shared;

/**
 *  添加新的编辑状态
 *
 *  @return
 */
- (EM_ChatConversation *)insertNewConversation;

/**
 *  删除编辑状态
 *
 *  @param conversation
 */
- (void)deleteConversationWithChatter:(EM_ChatConversation *)conversation;

/**
 *  查询编辑状态
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatConversation *)queryConversationWithChatter:(NSString *)chatter;


/**
 *  添加新的最近表情
 *
 *  @return
 */
- (EM_ChatEmoji *)insertNewEmoji;

/**
 *  删除最近表情
 *
 *  @param emoji
 */
- (void)deleteEmoji:(EM_ChatEmoji *)emoji;

/**
 *  查询最近表情
 *
 *  @param emoji
 *
 *  @return
 */
- (EM_ChatEmoji *)queryEmoji:(NSString *)emoji;

/**
 *  查询最近表情
 *
 *  @return
 */
- (NSArray *)queryEmoji;

/**
 *  添加消息信息
 *
 *  @return
 */
- (EM_ChatMessage *)insertNewMessage;

/**
 *  删除消息信息
 *
 *  @param message
 */
- (void)deleteMessage:(EM_ChatMessage *)message;

/**
 *  查询消息信息
 *
 *  @param messageId 消息ID
 *
 *  @return
 */
- (EM_ChatMessage *)queryMessageWithId:(NSString *)messageId  chatter:(NSString *)chatter;

/**
 *  查询消息信息
 *
 *  @return
 */
- (NSArray *)queryMessage;


/**
 *  注册新的扩展
 *
 *  @return
 */
- (EM_ChatExtend *)insertNewExtend;

/**
 *  删除扩展
 *
 *  @param extend
 */
- (void)deleteExtend:(EM_ChatExtend *)extend;

/**
 *  查询扩展
 *
 *  @param identifier 扩展标示
 *
 *  @return
 */
- (EM_ChatExtend *)queryExtendWithIdentifier:(NSString *)identifier;

/**
 *  查询扩展
 *
 *  @return
 */
- (NSArray *)queryExtend;


- (void)processPendingChangesChat;

/**
 *  保存
 *
 *  @return
 */
- (void)saveChat;

@end