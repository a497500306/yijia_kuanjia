//
//  EM+ChatController.h
//  EaseMobUI 聊天界面
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"
@class EM_ChatOpposite;
@class EM_ChatUser;

@protocol EM_ChatControllerDelegate;

@interface EM_ChatController : EM_ChatBaseController

/**
 *  会话对象
 */
@property (nonatomic, strong, readonly) EMConversation *conversation;

@property (nonatomic, strong, readonly) EM_ChatOpposite *opposite;
@property (nonatomic, strong, readonly) EM_ChatUser *user;
@property (nonatomic,weak) id<EM_ChatControllerDelegate> delegate;

- (instancetype)initWithOpposite:(EM_ChatOpposite *)opposite;

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType;

- (instancetype)initWithConversation:(EMConversation *)conversation;

- (void)sendMessage:(EM_ChatMessageModel *)message;

- (void)dismissKeyboard;

- (void)dismissMoreTool;

@end

@protocol EM_ChatControllerDelegate <NSObject>

@required

@optional

/**
 *  配置
 *
 *  @return
 */
- (EM_ChatUIConfig *)configForChat;

/**
 *  为要发送的消息添加扩展
 *
 *  @param body 消息内容
 *
 *  @return
 */
- (void)extendForMessage:(EM_ChatMessageModel *)message;

/**
 *  是否允许发送消息
 *
 *  @param body 消息内容
 *  @param type 消息类型
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)shouldSendMessage:(id)body messageType:(MessageBodyType)type;

/**
 *  自定义动作监听
 *
 *  @param name 自定义动作
 */
- (void)didActionSelectedWithName:(NSString *)name;

/**
 *  头像点击事件
 *
 *  @param chatter 
 *  @param isOwn 是否是自己的头像
 */
- (void)didAvatarTapWithChatter:(NSString *)chatter isOwn:(BOOL)isOwn;

/**
 *  扩展View被点击
 *
 *  @param userInfo  数据
 *  @param indexPath
 */
- (void)didExtendTapWithUserInfo:(NSDictionary *)userInfo;

/**
 *  扩展View菜单被选择
 *
 *  @param userInfo  数据
 *  @param indexPath 
 */
- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo;

@end