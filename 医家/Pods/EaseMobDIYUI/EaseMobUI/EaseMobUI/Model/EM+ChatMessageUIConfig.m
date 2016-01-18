//
//  EM+ChatCellUIConfig.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/13.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageUIConfig.h"

@implementation EM_ChatMessageUIConfig

+ (instancetype)defaultConfig{
    EM_ChatMessageUIConfig *config = [[EM_ChatMessageUIConfig alloc]init];
    config.avatarStyle = EM_AVATAR_STYLE_CIRCULAR;
    config.messageAvatarSize = 44;
    config.messagePadding = 15;
    config.messageTopPadding = 15;
    config.messageTimeLabelHeight = 20;
    config.messageNameLabelHeight = 20;
    config.messageIndicatorSize = 10;
    config.messageTailWithd = 15;
    
    config.bubblePadding = 0;
    config.bubbleTextFont = 14;
    config.bubbleTextLineSpacing = 2;
    config.bubbleCornerRadius = 4;
    
    config.bodyTextPadding = 8;
    config.bodyImagePadding = 0;
    config.bodyVideoPadding = 0;
    config.bodyVoicePadding = 6;
    config.bodyLocationPadding = 0;
    config.bodyFilePadding = 4;
    return config;
}

@end