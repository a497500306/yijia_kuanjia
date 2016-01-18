//
//  EM+ChatConversationObject.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface EM_ChatConversationObject : JSONModel

/**
 *  唯一标示
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  头像地址 
 *  + (NSURL *)fileURLWithPath:(NSString *)path isDirectory:(BOOL) isDir;
 *  + (NSURL *)fileURLWithPath:(NSString *)path;
 *  + (instancetype)URLWithString:(NSString *)URLString;
 */
@property (nonatomic, strong) NSURL *avatar;

/**
 *  显示的名称
 */
@property (nonatomic, copy) NSString *displayName;

/**
 *  简单的描述文字
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  是否是聊天对方 NO 标示是自己 YES 标示聊天对方
 */
@property (nonatomic, assign, readonly) BOOL opposite;

@end