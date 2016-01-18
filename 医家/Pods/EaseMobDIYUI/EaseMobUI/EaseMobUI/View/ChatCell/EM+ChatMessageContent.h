//
//  EM+ChatMessageContent.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EM_ChatMessageModel;
@class EM_ChatMessageUIConfig;

/**
 *  userInfo key
 */
extern NSString * const kHandleActionName;
extern NSString * const kHandleActionMessage;
extern NSString * const kHandleActionValue;
extern NSString * const kHandleActionView;
extern NSString * const kHandleActionFrom;

/**
 *  from
 */
extern NSString * const HANDLE_FROM_CONTENT;
extern NSString * const HANDLE_FROM_BODY;
extern NSString * const HANDLE_FROM_EXTEND;

/**
 *  action
 */
extern NSString * const HANDLE_ACTION_URL;
extern NSString * const HANDLE_ACTION_PHONE;
extern NSString * const HANDLE_ACTION_TEXT;
extern NSString * const HANDLE_ACTION_IMAGE;
extern NSString * const HANDLE_ACTION_VOICE;
extern NSString * const HANDLE_ACTION_VIDEO;
extern NSString * const HANDLE_ACTION_LOCATION;
extern NSString * const HANDLE_ACTION_FILE;
extern NSString * const HANDEL_ACTION_BODY;
extern NSString * const HANDLE_ACTION_EXTEND;
extern NSString * const HANDLE_ACTION_UNKNOWN;

/**
 *  menu action
 */
extern NSString * const MENU_ACTION_DELETE;//删除
extern NSString * const MENU_ACTION_COPY;//复制
extern NSString * const MENU_ACTION_FACE;//添加到表情
extern NSString * const MENU_ACTION_DOWNLOAD;//下载
extern NSString * const MENU_ACTION_COLLECT;//收藏
extern NSString * const MENU_ACTION_FORWARD;//转发

@protocol EM_ChatMessageContentDelegate;

@interface EM_ChatMessageContent : UIView

@property (nonatomic, weak) id<EM_ChatMessageContentDelegate> delegate;
@property (nonatomic,strong) EM_ChatMessageModel *message;

/**
 *  是否需要点击,默认YES
 */
@property (nonatomic, assign) BOOL needTap;

/**
 *  是否需要长按,默认YES
 */
@property (nonatomic, assign) BOOL needLongPress;

@property (nonatomic, strong) EM_ChatMessageUIConfig *config;


+ (CGSize )sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config;

//overwrite

/**
 *  返回菜单项,请使用super
 *
 *  @return 菜单项
 */
- (NSMutableArray *)menuItems;

/**
 *  返回点击、长按传入的数据,请使用super
 *
 *  @return 数据
 */
- (NSMutableDictionary *)userInfo;

@end

@protocol EM_ChatMessageContentDelegate <NSObject>

@required

@optional

/**
 *  点击监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentTap:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  长按监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentLongPress:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  菜单选项监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentMenu:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

@end