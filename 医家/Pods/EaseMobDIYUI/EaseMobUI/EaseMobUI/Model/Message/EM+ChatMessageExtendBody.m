//
//  EM+ChatMessageExtendBody.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/9/10.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtendBody.h"
#import "EM+ChatMessageExtendView.h"

@implementation EM_ChatMessageExtendBody

+ (NSString *)identifierForExtend{
    return kIdentifierForExtend;
}

+ (Class)viewForClass{
    return [EM_ChatMessageExtendView class];
}

+ (BOOL)showBody{
    return YES;
}

+ (BOOL)showExtend{
    return NO;
}

@end