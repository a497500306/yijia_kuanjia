//
//  EM+MessageUIConfig.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EM_ChatMessageUIConfig;

//聊天界面中大部分文字的默认大小
#define RES_FONT_DEFAUT (14)

//文字输入工具栏图标字体的默认大小
#define RES_TOOL_ICO_FONT (30)

//动作图标的默认大小
#define RES_ACTION_ICO_FONT (30)

//属性
/**
 *  属性名称
 */
extern NSString * const kAttributeName;

/**
 *  标题
 */
extern NSString * const kAttributeTitle;

/**
 *  一般图片
 */
extern NSString * const kAttributeNormalImage;

/**
 *  高亮图片
 */
extern NSString * const kAttributeHighlightImage;

/**
 *  背景色,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBackgroundColor;

/**
 *  边框颜色,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBorderColor;

/**
 *  边框宽度,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBorderWidth;

/**
 *  圆角,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeCornerRadius;

/**
 *  图标字体,设置此属性后,kAttributeNormalImage和kAttributeHighlightImage会失效
 */
extern NSString * const kAttributeFont;

/**
 *  图标
 */
extern NSString * const kAttributeText;

/**
 *  图标一般颜色
 */
extern NSString * const kAttributeNormalColor;

/**
 *  图标高亮颜色
 */
extern NSString * const kAttributeHighlightColor;

//工具栏按钮Name
extern NSString * const kButtonNameRecord;
extern NSString * const kButtonNameKeyboard;
extern NSString * const kButtonNameEmoji;
extern NSString * const kButtonNameAction;

//动作Name
extern NSString * const kActionNameImage;
extern NSString * const kActionNameCamera;
extern NSString * const kActionNameVoice;
extern NSString * const kActionNameVideo;
extern NSString * const kActionNameLocation;
extern NSString * const kActionNameFile;

@interface EM_ChatUIConfig : NSObject

@property (nonatomic, assign) BOOL hiddenOfRecord;
@property (nonatomic, assign) BOOL hiddenOfEmoji;
@property (nonatomic, strong) EM_ChatMessageUIConfig *messageConfig;

@property (nonatomic, strong, readonly) NSMutableDictionary *actionDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary *toolDictionary;
@property (nonatomic, strong, readonly) NSMutableArray *keyArray;


+ (instancetype)defaultConfig;

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeToolWithName:(NSString *)name;
- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName;

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeActionWithName:(NSString *)name;
- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName;

@end