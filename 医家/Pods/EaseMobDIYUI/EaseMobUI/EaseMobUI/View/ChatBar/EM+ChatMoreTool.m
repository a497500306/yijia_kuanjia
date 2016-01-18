//
//  EM+MessageMoreTool.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMoreTool.h"

#import "EM+ChatRecordView.h"
#import "EM+ChatEmojiView.h"
#import "EM+ChatActionView.h"

#import "EM+ChatUIConfig.h"

@interface EM_ChatMoreTool()<EM_ChatActionViewDelegate,EM_ChatEmojiViewDelegate,EM_ChatRecordViewDelegate>

@property (nonatomic,strong) EM_ChatUIConfig *config;

@end

@implementation EM_ChatMoreTool

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config{
    self = [super init];
    if (self) {
        
        _config = config;
        
        if (!_config.hiddenOfRecord) {
            _recordView = [[EM_ChatRecordView alloc]init];
            ((EM_ChatRecordView *)_recordView).delegate = self;
            [self addSubview:_recordView];
        }
        
        if (!_config.hiddenOfEmoji) {
            _emojiView = [[EM_ChatEmojiView alloc]init];
            ((EM_ChatEmojiView *)_emojiView).delegate = self;
            [self addSubview:_emojiView];
        }
        
        if (_config.actionDictionary.count > 0) {
            _actionView = [[EM_ChatActionView alloc]initWithConfig:_config];
            ((EM_ChatActionView *)_actionView).delegate = self;
            [self addSubview:_actionView];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        if (subview != _currentTool) {
            subview.frame = CGRectMake(0, size.height, size.width, size.height);
        }else{
            subview.frame = CGRectMake(0, 0, size.width, size.height);
        }
    }
}

- (void)showTool:(UIView *)tool animation:(BOOL)animation{
    _currentTool = tool;
    
    if (animation) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            for (int i = 0; i < self.subviews.count; i++) {
                UIView *subview = self.subviews[i];
                if (subview != _currentTool) {
                    subview.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.frame.size.height);
                }else{
                    subview.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
                }
            }
        } completion:nil];
    }else{
        for (int i = 0; i < self.subviews.count; i++) {
            UIView *subview = self.subviews[i];
            if (subview != _currentTool) {
                subview.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.frame.size.height);
            }else{
                subview.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            }
        }
    }
}

- (void)dismissTool:(BOOL)animation{
    if (animation) {
        if (_currentTool) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _currentTool.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.frame.size.height);
            } completion:nil];
        }
    }else{
        if (_currentTool) {
            _currentTool.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.frame.size.height);
        }
    }
}

#pragma mark - EM_ChatActionViewDelegate
- (void)didActionClicked:(NSString *)actionName{
    if (_delegate) {
        [_delegate didActionClicked:actionName];
    }
}

#pragma mark - EM_ChatEmojiViewDelegate
- (void)didEmojiClicked:(NSString *)emoji{
    if (_delegate) {
        [_delegate didEmojiClicked:emoji];
    }
}
- (void)didEmojiDeleteClicked{
    if (_delegate) {
        [_delegate didEmojiDeleteClicked];
    }
}
- (void)didEmojiSendClicked{
    if (_delegate) {
        [_delegate didEmojiSendClicked];
    }
}

#pragma mark - EM_ChatRecordViewDelegate

- (BOOL)shouldRecord{
    if (_delegate) {
        return [_delegate shouldRecord];
    }
    return YES;
}

- (void)didRecordStart{
    if (_delegate) {
        [_delegate didRecordStart];
    }
}

- (void)didRecording:(NSInteger)duration{
    if (_delegate) {
        [_delegate didRecording:duration];
    }
}

- (void)didRecordEnd:(NSString *)recordName path:recordPath duration:(NSInteger)duration{
    if (_delegate) {
        [_delegate didRecordEnd:recordName path:recordPath duration:duration];
    }
}

- (void)didRecordCancel{
    if (_delegate) {
        [_delegate didRecordCancel];
    }
}

- (void)didRecordError:error{
    if (_delegate) {
        [_delegate didRecordError:error];
    }
}

- (void)didRecordPlay{
    if (_delegate) {
        [_delegate didRecordPlay];
    }
}

- (void)didRecordPlaying:(NSInteger)duration{
    if (_delegate) {
        [_delegate didRecordPlaying:duration];
    }
}

- (void)didRecordPlayStop{
    if (_delegate) {
        [_delegate didRecordPlayStop];
    }
}

@end