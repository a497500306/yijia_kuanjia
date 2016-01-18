//
//  EM+MessageToolBar.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/2.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//
#import "EM+ChatBaseView.h"

@class EM_ChatInputTool;
@class EM_ChatMoreTool;
@class EM_ChatTableView;
@class EM_ChatUIConfig;

@protocol EM_MessageToolBarDelegate;

@interface EM_ChatToolBar : EM_ChatBaseView

@property (nonatomic,assign) id <EM_MessageToolBarDelegate> delegate;

/**
 *  键盘是否在显示
 */
@property (nonatomic, assign, readonly) BOOL keyboardVisible;

/**
 *  是否在编辑状态中
 */
@property (nonatomic, assign, readonly) BOOL inputEditing;

/**
 *  键盘的大小
 */
@property (nonatomic, assign, readonly) CGRect keyboardRect;

/**
 *  更多工具是否在显示
 */
@property (nonatomic, assign, readonly) BOOL moreToolVisble;

/**
 *  工具栏的高度
 */
@property (nonatomic, assign, readonly) CGFloat moreToolHeight;

/**
 *  文字输入工具
 */
@property (nonatomic, strong, readonly) EM_ChatInputTool *inputToolView;

/**
 *  更多工具
 */
@property (nonatomic, strong, readonly) EM_ChatMoreTool *moreToolView;

/**
 *  显示消息的table
 */
@property (nonatomic, strong) EM_ChatTableView *chatTableView;

/**
 *  是否接收键盘变化通知
 */
@property (nonatomic, assign) BOOL shouldReceiveKeyboardNotification;

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;

/**
 *  上拉显示键盘
 */
- (void)pullUpShow;

- (void)dismissKeyboard;

- (void)dismissMoreTool;

@end

@protocol EM_MessageToolBarDelegate <NSObject>

@required

@optional

//InputTool
/**
 *  是否允许发送文字消息
 *
 *  @param toolBar
 *  @param message 消息内容
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)messageToolBar:(EM_ChatToolBar *)toolBar shouldSendMessage:(NSString *)message;

/**
 *  发送文字消息
 *
 *  @param toolBar
 *  @param message 消息内容
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didSendMessagee:(NSString *)message;

//MoroTool

/**
 *  动作被选中
 *
 *  @param toolBar
 *  @param action  动作
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didSelectedActionWithName:(NSString *)action;

/**
 *  是否允许录音
 *
 *  @param toolBar
 *  @param view
 *
 *  @return YES or NO,在设备允许的情况下默认YES
 */
- (BOOL)messageToolBar:(EM_ChatToolBar *)toolBar shouldRecord:(UIView *)view;

/**
 *  开始录音
 *
 *  @param toolBar
 *  @param view
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didStartRecord:(UIView *)view;

/**
 *  取消录音
 *
 *  @param toolBar
 *  @param view
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didCancelRecord:(UIView *)view;

/**
 *  录音结束
 *
 *  @param toolBar
 *  @param name       录音文件名称
 *  @param recordPath 录音文件路径
 *  @param duration   录音时长
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didEndRecord:(NSString *)name record:(NSString *)recordPath duration:(NSInteger)duration;

/**
 *  录音错误
 *
 *  @param toolBar
 *  @param error   错误信息,如果error未nil,且方法调用说明录音时间太短
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didRecordError:(NSError *)error;

//Tool
/**
 *  键盘或更多工具显示
 *
 *  @param toolBar
 *  @param isShow YES显示 NO隐藏
 */
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didShowToolOrKeyboard:(BOOL)isShow;

@end