//
//  EM+MessageMoreTool.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseView.h"
@class EM_ChatUIConfig;

@protocol EM_ChatMoreToolDelegate;

@interface EM_ChatMoreTool : EM_ChatBaseView

/**
 *  录音
 */
@property (nonatomic,strong,readonly) UIView *recordView;

/**
 *  Emoji
 */
@property (nonatomic,strong,readonly) UIView *emojiView;

/**
 *  更多工具
 */
@property (nonatomic,strong,readonly) UIView *actionView;

/**
 *  当前显示工具
 */
@property (nonatomic,strong,readonly) UIView *currentTool;

@property (nonatomic, weak) id<EM_ChatMoreToolDelegate> delegate;

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;

/**
 *  显示指定工具
 *
 *  @param tool
 *  @param animation 是否开启动画
 */
- (void)showTool:(UIView *)tool animation:(BOOL)animation;

/**
 *  隐藏更多公爵
 *
 *  @param animation 是否开启动画
 */
- (void)dismissTool:(BOOL)animation;

@end

@protocol EM_ChatMoreToolDelegate <NSObject>

@required

//Action
/**
 *  更多按钮点击
 *
 *  @param actionName 动作
 */
- (void)didActionClicked:(NSString *)actionName;

//Emoji
/**
 *  表情点击
 *
 *  @param emoji
 */
- (void)didEmojiClicked:(NSString *)emoji;

/**
 *  删除表情
 */
- (void)didEmojiDeleteClicked;

/**
 *  发送表情
 */
- (void)didEmojiSendClicked;

//Record
/**
 *  是否允许录音
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)shouldRecord;

/**
 *  开始录音
 */
- (void)didRecordStart;

/**
 *  录音中
 *
 *  @param duration 录音时长
 */
- (void)didRecording:(NSInteger)duration;

/**
 *  录音完成
 *
 *  @param recordName 文件名称
 *  @parm  path       文件路径
 *  @param duration   文件
 */
- (void)didRecordEnd:(NSString *)recordName path:(NSString *)recordPath duration:(NSInteger)duration;

/**
 *  录音取消
 */
- (void)didRecordCancel;

/**
 *  录音错误
 *
 *  @param error nil表示录音时间太短
 */
- (void)didRecordError:(NSError *)error;

/**
 *  播放录音
 */
- (void)didRecordPlay;

/**
 *  播放录音中
 *
 *  @param duration
 */
- (void)didRecordPlaying:(NSInteger)duration;

/**
 *  停止播放录音
 */
- (void)didRecordPlayStop;

@optional


@end