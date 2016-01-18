//
//  EM+ChatMessageExtend.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtendView.h"

@implementation EM_ChatMessageExtendView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_FROM_EXTEND forKey:kHandleActionFrom];
    [userInfo setObject:HANDLE_ACTION_EXTEND forKey:kHandleActionName];
    return userInfo;
}

@end