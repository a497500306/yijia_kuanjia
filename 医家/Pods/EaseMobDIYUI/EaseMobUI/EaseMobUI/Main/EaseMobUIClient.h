//
//  EaseMobUIClient.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatUser.h"
#import "EM+ChatBuddy.h"
#import "EM+ChatGroup.h"
#import "EM+ChatRoom.h"
@class UIApplication;
@class UILocalNotification;
@class EM_ChatMessageModel;

@protocol EM_ChatUserDelegate;
@protocol EM_ChatOppositeDelegate;
@protocol EM_ChatNotificationDelegate;

extern NSString * const kEMNotificationCallActionIn;
extern NSString * const kEMNotificationCallActionOut;
extern NSString * const kEMNotificationCallShow;
extern NSString * const kEMNotificationCallDismiss;

extern NSString * const kEMNotificationEditorChanged;

extern NSString * const kEMCallChatter;
extern NSString * const kEMCallType;

extern NSString * const kEMCallTypeVoice;
extern NSString * const kEMCallTypeVideo;

@interface EaseMobUIClient : NSObject

/**
 *  登录用户信息代理
 */
@property (nonatomic, weak) id<EM_ChatUserDelegate> userDelegate;

/**
 *  聊天数据代理
 */
@property (nonatomic, weak) id<EM_ChatOppositeDelegate> oppositeDelegate;

/**
 *  通知代理
 */
@property (nonatomic, weak) id<EM_ChatNotificationDelegate> notificationDelegate;



+ (instancetype)sharedInstance;

+ (BOOL)canRecord;

+ (BOOL)canVideo;

- (BOOL)registerExtendClass:(Class)cls;

- (Class)classForExtendWithIdentifier:(NSString *)identifier;

- (void)registerForRemoteNotificationsWithApplication:(UIApplication *)application;

/**
 *  应用启动完毕
 *
 *  @param application
 *  @param launchOptions 
 */
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application;

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application;

- (void)applicationWillResignActive:(UIApplication *)application;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

@end

@protocol EM_ChatUserDelegate <NSObject>

@optional

/**
 * 返回当前登录的用户信息
 *
 */
- (EM_ChatUser *)userForEMChat;

@end

@protocol EM_ChatOppositeDelegate <NSObject>

@optional
/**
 *  根据chatter返回好友信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回群信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatGroup *)groupInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回群中好友信息
 *
 *  @param chatter
 *  @param group
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inGroup:(EM_ChatGroup *)group;

/**
 *  根据chatter返回讨论组信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatRoom *)roomInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回讨论组成员信息
 *
 *  @param chatter
 *  @param room
 *
 *  @return 
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inRoom:(EM_ChatRoom *)room;

@end

@protocol EM_ChatNotificationDelegate <NSObject>

/**
 *  本地消息通知显示内容
 *  只有在消息有用户自己的自定义扩展的时候才会调用
 *
 *  @param message
 *
 *  @return 默认“发来一个新消息”，默认自动在前面加上消息发送者的显示名称
 */
- (NSString *)alertBodyWithMessage:(EM_ChatMessageModel *)message;

/**
 *  收到带隐藏扩展的消息，及不会显示在界面上的扩展
 *
 *  @param extend
 */
- (void)didReceiveMessageWithExtend:(NSDictionary *)extend;

@end