//
//  EM+MessageInputTool.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseView.h"
@class EM_ChatUIConfig;

@protocol EM_ChatInputToolDelegate;

@interface EM_ChatInputTool : EM_ChatBaseView

@property (nonatomic,weak) UIResponder *overrideNextResponder;

/**
 *  录音按钮状态
 */
@property (nonatomic,assign) BOOL stateRecord;

/**
 *  表情按钮状态
 */
@property (nonatomic,assign) BOOL stateEmoji;

/**
 *  更多动作按钮状态
 */
@property (nonatomic,assign) BOOL stateAction;

/**
 *  录音状态下,更多工具是否在显示
 */
@property (nonatomic,assign) BOOL stateMore;

/**
 *  工具是否激活
 */
@property (nonatomic, assign) BOOL avtive;

/**
 *  文字输入框的大小,会随着文字的输入而改变
 */
@property (nonatomic,assign,readonly) CGSize contentSize;

/**
 *  编辑中得文字
 */
@property (nonatomic,copy) NSString *editor;

/**
 *  是否在编辑中
 */
@property (nonatomic, assign, readonly) BOOL inputEditing;

@property (nonatomic, weak) id<EM_ChatInputToolDelegate> delegate;

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;

/**
 *  向文字输入框中添加文字
 *
 *  @param message 要添加的文字
 */
- (void)addMessage:(NSString *)message;

/**
 *  删除输入框的一个字
 */
- (void)deleteMessage;

/**
 *  发送输入框的文字
 */
- (void)sendMessage;

/**
 *  隐藏键盘
 */
- (void)dismissKeyboard;

/**
 *  显示键盘
 */
- (void)showKeyboard;

@end

@protocol EM_ChatInputToolDelegate <NSObject>

@required

/**
 *  录音按钮状态变化
 *
 *  @param changed YES or NO,YES表示录音中
 */
- (void)didRecordStateChanged:(BOOL)changed;

/**
 *  表情按钮状态变化
 *
 *  @param changed YES or NO,YES表示显示Emoji表情工具栏
 */
- (void)didEmojiStateChanged:(BOOL)changed;

/**
 *  更多按钮状态变化
 *
 *  @param changed YES or NO
 */
- (void)didActionStateChanged:(BOOL)changed;

/**
 *  录音中,更多工具状态变化
 *
 *  @param changed YES or NO
 */
- (void)didMoreStateChanged:(BOOL)changed;

@optional

/**
 *  输入框文字变化
 *
 *  @param message        文字内容
 *  @param oldContentSize
 *  @param newContentSize
 */
- (void)didMessageChanged:(NSString *)message oldContentSize:(CGSize)oldContentSize newContentSize:(CGSize)newContentSize;

/**
 *  是否允许发送文字
 *
 *  @param message 文字内容
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)shouldMessageSend:(NSString *)message;

/**
 *  发送文字内容
 *
 *  @param message 文字内容
 */
- (void)didMessageSend:(NSString *)message;

@end