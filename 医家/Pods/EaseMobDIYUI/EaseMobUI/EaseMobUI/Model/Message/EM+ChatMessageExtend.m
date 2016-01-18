//
//  EM+ChatMessageExtend.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendBody.h"

@interface EM_ChatMessageExtend()

@end

@implementation EM_ChatMessageExtend


- (instancetype)init{
    self = [super init];
    if (self) {
        _showBody = YES;
        _showExtend = NO;
        _showTime = NO;
        _identifier = [EM_ChatMessageExtendBody identifierForExtend];
    }
    return self;
}

- (void)setExtendBody:(EM_ChatMessageExtendBody<Optional> *)extendBody{
    _extendBody = extendBody;
    if (_extendBody) {
        self.identifier = [[_extendBody class] identifierForExtend];
        self.showBody = [[_extendBody class] showBody];
        self.showExtend = [[_extendBody class] showExtend];
    }
}

@end