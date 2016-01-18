//
//  EM+ChatMessageContent.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageContent.h"
#import "EM+ChatMessageUIConfig.h"

@implementation EM_ChatMessageContent{
    UITapGestureRecognizer *tap;
    UILongPressGestureRecognizer *longPress;
}

NSString * const kHandleActionName      = @"kHandleActionName";
NSString * const kHandleActionMessage   = @"kHandleActionMessage";
NSString * const kHandleActionValue     = @"kHandleActionValue";
NSString * const kHandleActionView      = @"kHandleActionView";
NSString * const kHandleActionFrom      = @"kHandleActionFrom";

NSString * const HANDLE_FROM_CONTENT = @"HANDLE_FROM_CONTENT";
NSString * const HANDLE_FROM_BODY = @"HANDLE_FROM_BODY";
NSString * const HANDLE_FROM_EXTEND = @"HANDLE_FROM_EXTEND";

NSString * const HANDLE_ACTION_URL      = @"HANDLE_ACTION_URL";
NSString * const HANDLE_ACTION_PHONE    = @"HANDLE_ACTION_PHONE";
NSString * const HANDLE_ACTION_TEXT     = @"HANDLE_ACTION_TEXT";
NSString * const HANDLE_ACTION_IMAGE    = @"HANDLE_ACTION_IMAGE";
NSString * const HANDLE_ACTION_VOICE    = @"HANDLE_ACTION_VOICE";
NSString * const HANDLE_ACTION_VIDEO    = @"HANDLE_ACTION_VIDEO";
NSString * const HANDLE_ACTION_LOCATION = @"HANDLE_ACTION_LOCATION";
NSString * const HANDLE_ACTION_FILE     = @"HANDLE_ACTION_FILE";
NSString * const HANDEL_ACTION_BODY     = @"HANDEL_ACTION_BODY";
NSString * const HANDLE_ACTION_EXTEND   = @"HANDLE_ACTION_EXTEND";
NSString * const HANDLE_ACTION_UNKNOWN  = @"HANDLE_ACTION_UNKNOWN";

NSString * const MENU_ACTION_DELETE     = @"MENU_ACTION_DELETE";
NSString * const MENU_ACTION_COPY       = @"MENU_ACTION_COPY";
NSString * const MENU_ACTION_FACE       = @"MENU_ACTION_FACE";
NSString * const MENU_ACTION_DOWNLOAD   = @"MENU_ACTION_DOWNLOAD";
NSString * const MENU_ACTION_COLLECT    = @"MENU_ACTION_COLLECT";
NSString * const MENU_ACTION_FORWARD    = @"MENU_ACTION_FORWARD";

+ (CGSize )sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    return CGSizeZero;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.needTap = YES;
        self.needLongPress = YES;
    }
    return self;
}

- (void)setNeedTap:(BOOL)needTap{
    _needTap = needTap;
    if (tap) {
        [self removeGestureRecognizer:tap];
    }
    if (_needTap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap:)];
        [self addGestureRecognizer:tap];
        if (longPress) {
            [tap requireGestureRecognizerToFail:longPress];
        }
    }
}

- (void)setNeedLongPress:(BOOL)needLongPress{
    _needLongPress = needLongPress;
    if (longPress) {
        [self removeGestureRecognizer:longPress];
    }
    if (_needLongPress) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentLongPress:)];
        [self addGestureRecognizer:longPress];
        if (tap) {
            [tap requireGestureRecognizerToFail:longPress];
        }
    }
}

- (void)setConfig:(EM_ChatMessageUIConfig *)config{
    _config = config;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == tap) {
        return self.needTap;
    }else if(gestureRecognizer == longPress){
        return self.needLongPress;
    }else{
        return YES;
    }
}

- (void)contentTap:(UITapGestureRecognizer *)recognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentTap:action:withUserInfo:)]) {
        [self.delegate contentTap:self action:HANDEL_ACTION_BODY withUserInfo:[self userInfo]];
    }
}

- (void)contentLongPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentLongPress:action:withUserInfo:)]) {
        [self.delegate contentLongPress:self action:HANDEL_ACTION_BODY withUserInfo:[self userInfo]];
    }
}

- (NSMutableArray *)menuItems{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    return items;
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    if (self.message) {
        [userInfo setObject:self.message forKey:kHandleActionMessage];
    }
    [userInfo setObject:HANDLE_FROM_CONTENT forKey:kHandleActionFrom];
    [userInfo setObject:HANDLE_ACTION_UNKNOWN forKey:kHandleActionName];
    [userInfo setObject:self forKey:kHandleActionView];
    return userInfo;
}

@end