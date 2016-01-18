//
//  EM+ChatMessageBaseCell.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/16.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageContent.h"

@class EM_ChatMessageBubble;
@class EM_ChatMessageModel;
@class EM_ChatMessageUIConfig;

@protocol EM_ChatMessageCellDelegate;

@interface EM_ChatMessageCell : UITableViewCell

@property (nonatomic, weak) id<EM_ChatMessageCellDelegate> delegate;

@property (nonatomic, strong) EM_ChatMessageModel *message;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) EM_ChatMessageUIConfig *config;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, strong) NSURL *avatarURL;

@property (nonatomic,strong,readonly) EM_ChatMessageBubble *bubbleView;

+ (CGFloat)cellBubbleMaxWidth:(CGFloat)cellMaxWidth config:(EM_ChatMessageUIConfig *)config;

+ (CGFloat)heightForCellWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)max indexPath:(NSIndexPath *)indexPath config:(EM_ChatMessageUIConfig *)config;

- (instancetype)initWithBodyClass:(Class)bodyClass extendClass:(Class)extendClass reuseIdentifier:(NSString *)reuseIdentifier;

@end

@protocol EM_ChatMessageCellDelegate <NSObject>

@required

@optional

/**
 *  头像点击
 *
 *  @param cell      当前cell
 *  @param chatter
 *  @param indexPath
 */
- (void)chatMessageCell:(EM_ChatMessageCell *)cell didTapAvatarWithChatter:(NSString *)chatter indexPath:(NSIndexPath *)indexPath;

/**
 *  重发消息
 *
 *  @param cell      当前cell
 *  @param message
 *  @param indexPath
 */
- (void)chatMessageCell:(EM_ChatMessageCell *)cell resendMessageWithMessage:(EM_ChatMessageModel *)message indexPath:(NSIndexPath *)indexPath;

/**
 *  点击监听
 *
 *  @param cell      当前cell
 *  @param userInfo  数据
 *  @param indexPath
 */
- (void)chatMessageCell:(EM_ChatMessageCell *)cell didTapWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath;

/**
 *  长按监听
 *
 *  @param cell      当前cell
 *  @param userInfo  数据
 *  @param indexPath
 */
- (void)chatMessageCell:(EM_ChatMessageCell *)cell didLongPressWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath;


/**
 *  菜单监听
 *
 *  @param cell      当前cell
 *  @param userInfo  数据
 *  @param indexPath 
 */
- (void)chatMessageCell:(EM_ChatMessageCell *)cell didMenuSelectedWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath;

@end