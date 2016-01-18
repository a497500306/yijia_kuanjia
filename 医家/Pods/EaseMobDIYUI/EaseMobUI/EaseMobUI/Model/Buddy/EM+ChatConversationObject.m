//
//  EM+ChatConversationObject.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatConversationObject.h"

@implementation EM_ChatConversationObject

- (BOOL)isEqual:(id)object{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual) {
        EM_ChatConversationObject *con = object;
        isEqual = [con.uid isEqualToString:self.uid];
    }
    return isEqual;
}

@end