//
//  EM+ChatMessageVoiceBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageVoiceBody.h"

#import "EM+ChatMessageModel.h"
#import "EM_ChatMessage.h"

#import "EM+ChatUIConfig.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatMessageUIConfig.h"

@implementation EM_ChatMessageVoiceBody{
    UIImageView *animationView;
    UILabel *timeLabel;
    UIButton *identifyButton;
}

+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    
    if (CGSizeEqualToSize(message.bodySize , CGSizeZero)) {
        CGSize size;
        
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)message.messageBody;
        size = CGSizeMake(voiceBody.duration * 4 + 50, 24);
        size.height += config.bodyVoicePadding * 2;
        size.width += config.bodyVoicePadding * 2;
        
        message.bodySize = size;
    }
    return message.bodySize;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        animationView = [[UIImageView alloc]init];
        animationView.backgroundColor = [UIColor clearColor];
        animationView.animationDuration = 1;
        [self addSubview:animationView];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    [timeLabel sizeToFit];
    
    animationView.bounds = CGRectMake(0, 0, size.height - self.config.bodyVoicePadding * 2, size.height - self.config.bodyVoicePadding * 2);
    
    if (self.message.sender) {
        timeLabel.center = CGPointMake(self.config.bodyVoicePadding + timeLabel.frame.size.width / 2, size.height / 2);
        animationView.center = CGPointMake(size.width - self.config.bodyVoicePadding - animationView.frame.size.width / 2, size.height / 2);
    }else{
        timeLabel.center = CGPointMake(size.width - self.config.bodyVoicePadding - timeLabel.frame.size.width / 2, size.height / 2);
        animationView.center = CGPointMake(self.config.bodyVoicePadding + animationView.frame.size.width / 2, size.height / 2);
    }
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_VOICE forKey:kHandleActionName];
    return userInfo;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)message.messageBody;

    NSString *time;
    if (voiceBody.duration < 60) {
        time = [NSString stringWithFormat:@"%ld\"",voiceBody.duration];
    }else{
        time = [NSString stringWithFormat:@"%ld\'%ld\"",voiceBody.duration / 60,voiceBody.duration % 60];
    }
    timeLabel.text = time;
    
    if (self.message.sender) {
        timeLabel.textColor = [UIColor whiteColor];
        [animationView setAnimationImages:@[
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_right_1"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_right_2"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_right_3"]
                                            ]];
        animationView.image = [EM_ChatResourcesUtils cellImageWithName:@"voice_right_3"];
    }else{
        timeLabel.textColor = [UIColor blackColor];
        [animationView setAnimationImages:@[
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_left_1"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_left_2"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_left_3"]
                                            ]];
        animationView.image = [EM_ChatResourcesUtils cellImageWithName:@"voice_left_3"];
    }
    if (self.message.messageSign.checking && !animationView.isAnimating) {
        [animationView startAnimating];
    }else{
        [animationView stopAnimating];
    }
}
@end