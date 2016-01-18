//
//  EM+ChatMessageModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <EaseMobSDKFull/EaseMob.h>
#import "EM+ChatMessageExtendBody.h"
#import "EM+ChatMessageExtend.h"
#import "EM_ChatMessage.h"

@class EM_ChatMessageUIConfig;

@interface EM_ChatMessageModel : NSObject

/**
 *  消息发送者的昵称
 */
@property (nonatomic, copy) NSString *displayName;

/**
 *  消息发送者的头像地址
 */
@property (nonatomic, strong) NSURL *avatar;

/**
 *  是否是自己发送
 */
@property (nonatomic, assign) BOOL sender;

/**
 *  环信的消息
 */
@property (nonatomic, strong) EMMessage *message;

/**
 *  环信消息体
 */
@property (nonatomic, strong) id<IEMMessageBody> messageBody;

/**
 *  消息扩展
 */
@property (nonatomic, strong) EM_ChatMessageExtend *messageExtend;

/**
 *  消息标记
 */
@property (nonatomic, strong) EM_ChatMessage *messageSign;

//缓存计算的ViewSize
@property (nonatomic, assign) CGSize bubbleSize;
@property (nonatomic, assign) CGSize bodySize;
@property (nonatomic, assign) CGSize extendSize;

/**
 *  Cell的reuseIdentifier
 */
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

+ (instancetype)fromEMMessage:(EMMessage *)message;

+ (instancetype)fromText:(NSString *)text conversation:(EMConversation *)conversation;

+ (instancetype)fromImage:(UIImage *)image conversation:(EMConversation *)conversation;

+ (instancetype)fromVoice:(NSString *)path name:(NSString *)name duration:(NSInteger)duration conversation:(EMConversation *)conversation;

+ (instancetype)fromVideo:(NSString *)path conversation:(EMConversation *)conversation;

+ (instancetype)fromLatitude:(double)latitude longitude:(double)longitude address:(NSString *)address conversation:(EMConversation *)conversation;

+ (instancetype)fromFile:(NSString *)path name:(NSString *)name conversation:(EMConversation *)conversation;

- (BOOL)updateExt;

- (Class)classForBodyView;

@end