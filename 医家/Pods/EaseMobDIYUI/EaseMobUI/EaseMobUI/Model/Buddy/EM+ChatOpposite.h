//
//  EM_ChatOpposite.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatConversationObject.h"

typedef NS_ENUM(NSInteger, EMChatOppositeType) {
    EMChatOppositeTypeChat,
    EMChatOppositeTypeGroup,
    EMChatOppositeTypeRoom
};

@interface EM_ChatOpposite : EM_ChatConversationObject

@property (nonatomic, assign, readonly) EMChatOppositeType oppositeType;

@end