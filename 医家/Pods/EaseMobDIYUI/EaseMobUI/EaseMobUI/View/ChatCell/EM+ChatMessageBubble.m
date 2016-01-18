//
//  EM+ChatMessageBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBubble.h"
#import "EM+ChatMessageBodyView.h"
#import "EM+ChatMessageExtendView.h"

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendBody.h"

#import "EM+ChatMessageUIConfig.h"

@interface EM_ChatMessageBubble()

@end

@implementation EM_ChatMessageBubble

+ (CGSize )sizeForBubbleWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    if (CGSizeEqualToSize(message.bubbleSize, CGSizeZero)) {
        CGFloat contentMaxtWidth = maxWidth - config.bubblePadding * 2;
        BOOL show = message.messageExtend.showBody || message.messageExtend.showExtend;
        if (show) {
            if (message.messageExtend.showBody) {
                message.bodySize = [[message classForBodyView] sizeForContentWithMessage:message maxWidth:contentMaxtWidth config:config];
            }else{
                message.bodySize = CGSizeZero;
            }
            
            if (message.messageExtend.showExtend) {
                message.extendSize = [[[message.messageExtend.extendBody class] viewForClass] sizeForContentWithMessage:message maxWidth:contentMaxtWidth config:config];
            }else{
                message.extendSize = CGSizeZero;
            }
        }else{
            message.bodySize = [[message classForBodyView] sizeForContentWithMessage:message maxWidth:contentMaxtWidth config:config];
        }
        
        message.bubbleSize = CGSizeMake((message.bodySize.width > message.extendSize.width ? message.bodySize.width : message.extendSize.width) + config.bubblePadding * 2, message.bodySize.height + message.extendSize.height + config.bubblePadding * 2);
    }
    return message.bubbleSize;
}

- (instancetype)initWithBodyClass:(Class)bodyClass withExtendClass:(Class)extendClass{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.layer.masksToBounds = YES;
        _backgroundView = [[UIImageView alloc]init];
        [self addSubview:_backgroundView];
        
        _bodyView = [[bodyClass alloc]init];
        [self addSubview:_bodyView];
        _extendView = [[extendClass alloc]init];
        [self addSubview:_extendView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _backgroundView.frame = self.bounds;
    
    CGSize bodySize = self.message.bodySize;
    CGSize extendSize = self.message.extendSize;
    if (self.message.sender) {
        _bodyView.frame = CGRectMake(size.width - self.config.bubblePadding - bodySize.width, self.config.bubblePadding, bodySize.width, bodySize.height);
    }else{
        _bodyView.frame = CGRectMake(self.config.bubblePadding, self.config.bubblePadding, bodySize.width, bodySize.height);
    }
    
    if (self.message.messageExtend.showExtend) {
        _extendView.bounds = CGRectMake(0, 0, extendSize.width, extendSize.height);
        _extendView.center = CGPointMake(size.width / 2, _bodyView.frame.origin.y + _bodyView.frame.size.height + extendSize.height / 2);
    }
}

- (void)setConfig:(EM_ChatMessageUIConfig *)config{
    _config = config;
    _bodyView.config = _config;
    _extendView.config = _config;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    _message = message;
    _bodyView.message = _message;
    _extendView.message = _message;
    
    BOOL show = _message.messageExtend.showBody || _message.messageExtend.showExtend;
    if (show) {
        _bodyView.hidden = !_message.messageExtend.showBody;
        _extendView.hidden = !_message.messageExtend.showExtend;
    }else{
        _bodyView.hidden = NO;
        _extendView.hidden = YES;
    }
}

@end