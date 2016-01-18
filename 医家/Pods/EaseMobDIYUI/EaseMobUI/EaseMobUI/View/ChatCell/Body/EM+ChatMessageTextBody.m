//
//  EM+ChatMessageTextBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageTextBody.h"

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendCall.h"

#import "EM+ChatMessageUIConfig.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface EM_ChatMessageTextBody()<TTTAttributedLabelDelegate>

@end

@implementation EM_ChatMessageTextBody{
    TTTAttributedLabel *textLabel;
}

+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    if (CGSizeEqualToSize(message.bodySize , CGSizeZero)) {
        CGSize size;
        
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.messageBody;
        static float systemVersion;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        });
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:config.bubbleTextLineSpacing];
        
        size = [textBody.text boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:config.bubbleTextFont + 1],
                                                     NSParagraphStyleAttributeName:paragraphStyle
                                                     }
                                           context:nil].size;
        size.height += config.bodyTextPadding * 2;
        size.width += config.bodyTextPadding * 2;
        
        message.bodySize = size;
    }
    return message.bodySize;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        textLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        textLabel.delegate = self;
        textLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        textLabel.userInteractionEnabled = YES;
        textLabel.contentMode = UIViewContentModeCenter;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:textLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    textLabel.bounds = CGRectMake(0, 0, size.width - self.config.bodyTextPadding * 2, size.height - self.config.bodyTextPadding * 2);
    textLabel.center = CGPointMake(size.width / 2, size.height / 2);
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_TEXT forKey:kHandleActionName];
    return userInfo;
}

- (void)setConfig:(EM_ChatMessageUIConfig *)config{
    [super setConfig:config];
    textLabel.font = [UIFont systemFontOfSize:config.bubbleTextFont];
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.messageBody;
    if (self.message.sender) {
        textLabel.textColor = [UIColor whiteColor];
    }else{
        textLabel.textColor = [UIColor blackColor];
    }
    textLabel.text = textBody.text;
    self.needTap = [self.message.messageExtend.identifier isEqualToString:kIdentifierForCall];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentTap:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:HANDLE_ACTION_URL forKey:kHandleActionName];
        [userInfo setObject:url forKey:kHandleActionValue];
        [self.delegate contentTap:self action:HANDLE_ACTION_URL withUserInfo:userInfo];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentTap:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:HANDLE_ACTION_PHONE forKey:kHandleActionName];
        [userInfo setObject:phoneNumber forKey:kHandleActionValue];
        [self.delegate contentTap:self action:HANDLE_ACTION_PHONE withUserInfo:userInfo];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentLongPress:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:HANDLE_ACTION_URL forKey:kHandleActionName];
        [userInfo setObject:url forKey:kHandleActionValue];
        [self.delegate contentLongPress:self action:HANDLE_ACTION_URL withUserInfo:userInfo];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber atPoint:(CGPoint)point{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentLongPress:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:HANDLE_ACTION_PHONE forKey:kHandleActionName];
        [userInfo setObject:phoneNumber forKey:kHandleActionValue];
        [self.delegate contentLongPress:self action:HANDLE_ACTION_PHONE withUserInfo:userInfo];
    }
}

@end