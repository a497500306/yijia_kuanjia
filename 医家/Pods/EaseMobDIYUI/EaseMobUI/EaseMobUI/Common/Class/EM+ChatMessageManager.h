//
//  EM+ChatMessageRead.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/22.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EM_ChatMessageModel;

@protocol EM_ChatMessageManagerDelegate;

@interface EM_ChatMessageManager : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, weak) id<EM_ChatMessageManagerDelegate> delegate;

+ (instancetype)defaultManager;

//查看图片
- (void)showBrowserWithImagesMessage:(NSArray *)imageArray index:(NSInteger)index;
//播放视频
- (void)showBrowserWithVideoMessage:(id)videoMessage;

//播放语音
- (void)playVoice:(NSArray *)voiceArray index:(NSInteger)index;
- (void)stopVoice;

@end

@protocol EM_ChatMessageManagerDelegate <NSObject>

- (void)didStartPlayWithMessage:(EM_ChatMessageModel *)next previous:(EM_ChatMessageModel *)previous;
- (void)didEndPlayWithMessage:(EM_ChatMessageModel *)message;

@end