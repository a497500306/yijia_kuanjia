//
//  EM+ChatCellUIConfig.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/13.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EM_AVATAR_STYLE) {
    EM_AVATAR_STYLE_SQUARE = 0,//方形
    EM_AVATAR_STYLE_CIRCULAR//圆形
};

@interface EM_ChatMessageUIConfig : NSObject

//cell
/**
 *  头像风格,默认EM_AVATAR_STYLE_CIRCULAR
 */
@property (nonatomic, assign) EM_AVATAR_STYLE avatarStyle;

/**
 *  头像的大小
 */
@property (nonatomic, assign) float messageAvatarSize;

/**
 *  消息左右的padding
 */
@property (nonatomic, assign) float messagePadding;

/**
 *  消息顶部padding,即消息和消息之间的空隙
 */
@property (nonatomic, assign) float messageTopPadding;

/**
 *  消息时间显示高度
 */
@property (nonatomic, assign) float messageTimeLabelHeight;

/**
 *  昵称显示高度
 */
@property (nonatomic, assign) float messageNameLabelHeight;

/**
 *  菊花高度
 */
@property (nonatomic, assign) float messageIndicatorSize;

/**
 *  气泡尾巴宽度
 */
@property (nonatomic, assign) float messageTailWithd;

//bubble
/**
 *  气泡padding
 */
@property (nonatomic, assign) float bubblePadding;

/**
 *  气泡文字大小
 */
@property (nonatomic, assign) float bubbleTextFont;

/**
 *  文字行间距
 */
@property (nonatomic, assign) float bubbleTextLineSpacing;

/**
 *  气泡圆角大小
 */
@property (nonatomic, assign) float bubbleCornerRadius;

@property (nonatomic, assign) float bodyTextPadding;

@property (nonatomic, assign) float bodyImagePadding;

@property (nonatomic, assign) float bodyVideoPadding;

@property (nonatomic, assign) float bodyVoicePadding;

@property (nonatomic, assign) float bodyLocationPadding;

@property (nonatomic, assign) float bodyFilePadding;

+ (instancetype)defaultConfig;

@end