//
//  EM+ChatMessageExtendBody.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/9/10.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "JSONModel.h"

#define kIdentifierForExtend                    (@"kIdentifierForExtend")

@interface EM_ChatMessageExtendBody : JSONModel

/**
 *  扩展标示，iOS和Android两个平台必须一致
 *
 *  @return
 */
+ (NSString *)identifierForExtend;

/**
 *  扩展对应的显示View
 *
 *  @return
 */
+ (Class)viewForClass;

/**
 *  是否显示消息体
 *
 *  @return
 */
+ (BOOL)showBody;

/**
 *  是否显示扩展体
 *
 *  @return 
 */
+ (BOOL)showExtend;

@end