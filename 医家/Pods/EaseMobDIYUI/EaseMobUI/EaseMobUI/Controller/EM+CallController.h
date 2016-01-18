//
//  EM+CallController.h
//  EaseMobUI  语音、视频通讯界面
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"
@class EMCallSession;


/**
 *  通话动作
 */
typedef NS_ENUM(NSInteger, EMChatCallAction){
    /**
     *  接入
     */
    EMChatCallActionIn = 0,
    /**
     *  拨出
     */
    EMChatCallActionOut
};

/**
 *  通话状态
 */
typedef NS_ENUM(NSInteger, EMChatCallState){
    /**
     *  等待接通或等待同意
     */
    EMChatCallStateWait = 0,
    /**
     *  通话中
     */
    EMChatCallStateIn,
    /**
     *  通话结束
     */
    EMChatCallStateEnd,
    /**
     *  通话暂停
     */
    EMChatCallStatePause
};

@interface EM_CallController : EM_ChatBaseController

@property (nonatomic, assign, readonly) NSInteger callType;
@property (nonatomic, assign, readonly) EMChatCallAction callAction;
@property (nonatomic, assign, readonly) EMChatCallState callState;
@property (nonatomic, strong, readonly) EMCallSession *callSession;

- (instancetype)initWithSession:(EMCallSession *)session type:(NSInteger)type action:(EMChatCallAction)action;

@end