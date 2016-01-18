//
//  EM+MessageUIConfig.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageUIConfig.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "UIColor+Hex.h"

@interface EM_ChatUIConfig()

@end

@implementation EM_ChatUIConfig

//属性
NSString * const kAttributeName = @"kAttributeName";
NSString * const kAttributeTitle = @"kAttribuTitle";
NSString * const kAttributeNormalImage = @"kAttribuNormalImage";
NSString * const kAttributeHighlightImage = @"kAttribuNormalImage";
NSString * const kAttributeBackgroundColor = @"kActionBackgroundColor";
NSString * const kAttributeBorderColor = @"kAttribuBorderColor";
NSString * const kAttributeBorderWidth = @"kAttribuBorderWidth";
NSString * const kAttributeCornerRadius = @"kAttribuCornerRadius";

NSString * const kAttributeFont = @"kAttributeFont";
NSString * const kAttributeText = @"kAttributeText";
NSString * const kAttributeNormalColor = @"kAttributeNormalColor";
NSString * const kAttributeHighlightColor = @"kAttributeHighlightColor";

//工具栏按钮
NSString * const kButtonNameRecord = @"kButtonNameRecord";
NSString * const kButtonNameKeyboard = @"kButtonNameKeyboard";
NSString * const kButtonNameEmoji = @"kButtonNameEmoji";
NSString * const kButtonNameAction = @"kButtonNameAction";

//动作
NSString * const kActionNameImage = @"kActionNameImage";
NSString * const kActionNameCamera = @"kActionNameCamera";
NSString * const kActionNameVoice = @"kActionNameVoice";
NSString * const kActionNameVideo = @"kActionNameVideo";
NSString * const kActionNameLocation = @"kActionNameLocation";
NSString * const kActionNameFile = @"kActionNameFile";

+ (instancetype)defaultConfig{
    EM_ChatUIConfig *config = [[EM_ChatUIConfig alloc]init];
    
    config.hiddenOfRecord = NO;
    config.hiddenOfEmoji = NO;
    
    //录音按钮
    [config setToolName:kButtonNameRecord attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_TOOL_ICO_FONT]];
    [config setToolName:kButtonNameRecord attributeName:kAttributeText attribute:kEMChatIconToolVoice];
    [config setToolName:kButtonNameRecord attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //键盘
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_TOOL_ICO_FONT]];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeText attribute:kEMChatIconToolKeyboard];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //Emoji
    [config setToolName:kButtonNameEmoji attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_TOOL_ICO_FONT]];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeText attribute:kEMChatIconToolFace];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //动作
    [config setToolName:kButtonNameAction attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_TOOL_ICO_FONT]];
    [config setToolName:kButtonNameAction attributeName:kAttributeText attribute:kEMChatIconToolAction];
    [config setToolName:kButtonNameAction attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //图片
    [config setActionName:kActionNameImage attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_ACTION_ICO_FONT + 1]];
    [config setActionName:kActionNameImage attributeName:kAttributeText attribute:kEMChatIconActionImage];
    [config setActionName:kActionNameImage attributeName:kAttributeBorderColor attribute:[UIColor colorWithHEX:LINE_COLOR alpha:1]];
    [config setActionName:kActionNameImage attributeName:kAttributeBorderWidth attribute:@(0.5)];
    [config setActionName:kActionNameImage attributeName:kAttributeCornerRadius attribute:@(6)];
    [config setActionName:kActionNameImage attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.image"]];
    [config setActionName:kActionNameImage attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];

    //相机
    [config setActionName:kActionNameCamera attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_ACTION_ICO_FONT]];
    [config setActionName:kActionNameCamera attributeName:kAttributeText attribute:kEMChatIconActionCamera];
    [config setActionName:kActionNameCamera attributeName:kAttributeBorderColor attribute:[UIColor colorWithHEX:LINE_COLOR alpha:1]];
    [config setActionName:kActionNameCamera attributeName:kAttributeBorderWidth attribute:@(0.5)];
    [config setActionName:kActionNameCamera attributeName:kAttributeCornerRadius attribute:@(6)];
    [config setActionName:kActionNameCamera attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.camera"]];
    [config setActionName:kActionNameCamera attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //语音
    [config setActionName:kActionNameVoice attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_ACTION_ICO_FONT]];
    [config setActionName:kActionNameVoice attributeName:kAttributeText attribute:kEMChatIconActionAudio];
    [config setActionName:kActionNameVoice attributeName:kAttributeBorderColor attribute:[UIColor colorWithHEX:LINE_COLOR alpha:1]];
    [config setActionName:kActionNameVoice attributeName:kAttributeBorderWidth attribute:@(0.5)];
    [config setActionName:kActionNameVoice attributeName:kAttributeCornerRadius attribute:@(6)];
    [config setActionName:kActionNameVoice attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.voice"]];
    [config setActionName:kActionNameVoice attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //视频
    [config setActionName:kActionNameVideo attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_ACTION_ICO_FONT]];
    [config setActionName:kActionNameVideo attributeName:kAttributeText attribute:kEMChatIconActionVideo];
    [config setActionName:kActionNameVideo attributeName:kAttributeBorderColor attribute:[UIColor colorWithHEX:LINE_COLOR alpha:1]];
    [config setActionName:kActionNameVideo attributeName:kAttributeBorderWidth attribute:@(0.5)];
    [config setActionName:kActionNameVideo attributeName:kAttributeCornerRadius attribute:@(6)];
    [config setActionName:kActionNameVideo attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.video"]];
    [config setActionName:kActionNameVideo attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //位置
    [config setActionName:kActionNameLocation attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_ACTION_ICO_FONT + 1]];
    [config setActionName:kActionNameLocation attributeName:kAttributeText attribute:kEMChatIconActionLocation];
    [config setActionName:kActionNameLocation attributeName:kAttributeBorderColor attribute:[UIColor colorWithHEX:LINE_COLOR alpha:1]];
    [config setActionName:kActionNameLocation attributeName:kAttributeBorderWidth attribute:@(0.5)];
    [config setActionName:kActionNameLocation attributeName:kAttributeCornerRadius attribute:@(6)];
    [config setActionName:kActionNameLocation attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.location"]];
    [config setActionName:kActionNameLocation attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    //文件
    [config setActionName:kActionNameFile attributeName:kAttributeFont attribute:[EM_ChatResourcesUtils iconFontWithSize:RES_ACTION_ICO_FONT]];
    [config setActionName:kActionNameFile attributeName:kAttributeText attribute:kEMChatIconActionFile];
    [config setActionName:kActionNameFile attributeName:kAttributeBorderColor attribute:[UIColor colorWithHEX:LINE_COLOR alpha:1]];
    [config setActionName:kActionNameFile attributeName:kAttributeBorderWidth attribute:@(0.5)];
    [config setActionName:kActionNameFile attributeName:kAttributeCornerRadius attribute:@(6)];
    [config setActionName:kActionNameFile attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.file"]];
    [config setActionName:kActionNameFile attributeName:kAttributeHighlightColor attribute:[UIColor blackColor]];
    
    config.messageConfig = [EM_ChatMessageUIConfig defaultConfig];
    
    return config;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _keyArray = [[NSMutableArray alloc]init];
        _actionDictionary = [[NSMutableDictionary alloc]init];
        _toolDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute{
    if (toolName && toolName.length > 0 && attributeName && attributeName.length > 0 && attribute) {
        NSMutableDictionary *buttonDic = _toolDictionary[toolName];
        if (!buttonDic) {
            buttonDic = [[NSMutableDictionary alloc]init];
            [buttonDic setObject:toolName forKey:kAttributeName];
            [_toolDictionary setObject:buttonDic forKey:toolName];
        }
        if (![attributeName isEqualToString:kAttributeName]) {
            [buttonDic setObject:attribute forKey:attributeName];
        }
    }
}

- (void)removeToolWithName:(NSString *)name{
    if (name && name.length > 0) {
        [_toolDictionary removeObjectForKey:name];
    }
}

- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName{
    if (attributeName && attributeName.length > 0 && toolName && toolName.length > 0) {
        NSMutableDictionary *action = _toolDictionary[toolName];
        [action removeObjectForKey:attributeName];
        if (action.count == 0) {
            [_toolDictionary removeObjectForKey:toolName];
        }
    }
}

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute{
    if (actionName && actionName.length > 0 && attributeName && attributeName.length > 0 && attribute) {
        NSMutableDictionary *actionAttributeDic = _actionDictionary[actionName];
        if (!actionAttributeDic) {
            actionAttributeDic = [[NSMutableDictionary alloc]init];
            [actionAttributeDic setObject:kAttributeName forKey:actionName];
            [_actionDictionary setObject:actionAttributeDic forKey:actionName];
            
            [_keyArray addObject:actionName];
        }
        if (![attributeName isEqualToString:kAttributeName]) {
            [actionAttributeDic setObject:attribute forKey:attributeName];
        }
    }
}

- (void)removeActionWithName:(NSString *)name{
    if (name && name.length > 0) {
        [_actionDictionary removeObjectForKey:name];
        [_keyArray removeObject:name];
    }
}

- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName{
    if (attributeName && attributeName.length > 0 && actionName && actionName.length > 0) {
        NSMutableDictionary *action = _actionDictionary[actionName];
        [action removeObjectForKey:attributeName];
        if (action.count == 0) {
            [_actionDictionary removeObjectForKey:actionName];
            [_keyArray removeObject:actionName];
        }
    }
}

@end