//
//  EM+ChatMessageExtend.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>

#define kIdentifier             (@"identifier")

@class EM_ChatMessageModel;
@class EM_ChatMessageExtendBody;

@interface EM_ChatMessageExtend : JSONModel

/**
 *  扩展标示
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  是否显示消息内容,默认YES
 */
@property (nonatomic, assign) BOOL showBody;

/**
 *  是否显示扩展内容,默认NO
 */
@property (nonatomic, assign) BOOL showExtend;

/**
 *  是否显示时间,默认NO
 */
@property (nonatomic, assign) BOOL showTime;

/**
 *  自定义扩展属性,不用来显示
 */
@property (nonatomic, strong) NSDictionary<Optional> *extendAttributes;

/**
 *  自定义扩展,用来显示
 */
@property (nonatomic, strong) EM_ChatMessageExtendBody<Optional> *extendBody;

@end