//
//  EaseMobUIClient.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EaseMobUIClient.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatDBUtils.h"
#import "EM+ChatResourcesUtils.h"

#import "EM+Common.h"
#import "EM+ChatUIConfig.h"

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendCall.h"
#import "EM+ChatMessageExtendFile.h"
#import "EM_ChatExtend.h"
#import "GPUImageVideoCamera.h"

#import "EM+CallController.h"
#import "UIViewController+HUD.h"
#import "EMCDDeviceManager.h"

#import <UIKit/UIKit.h>
#import <EaseMobSDKFull/EaseMob.h>
#import <AVFoundation/AVFoundation.h>


static EaseMobUIClient *sharedClient;
/**
 *  EMChatManagerLoginDelegate
 *  EMChatManagerEncryptionDelegate
 *  EMChatManagerBuddyDelegate
 *  EMChatManagerUtilDelegate
 *  EMChatManagerGroupDelegate
 *  EMChatManagerPushNotificationDelegate
 *  EMChatManagerChatroomDelegate
 */

/**
 *  EMCallManagerCallDelegate
 */

/**
 *  EMDeviceManagerNetworkDelegate
 */
@interface EaseMobUIClient()<EMChatManagerDelegate,EMCallManagerDelegate,EMDeviceManagerDelegate>

@property (nonatomic, assign) BOOL callShow;

@property (nonatomic, strong) NSMutableDictionary *extendRegisterClass;

@end

@implementation EaseMobUIClient

NSString * const kEMNotificationCallActionIn = @"kEMNotificationCallActionIn";
NSString * const kEMNotificationCallActionOut = @"kEMNotificationCallActionOut";
NSString * const kEMNotificationCallShow = @"kEMNotificationCallShow";
NSString * const kEMNotificationCallDismiss = @"kEMNotificationCallDismiss";

NSString * const kEMNotificationEditorChanged = @"kEMNotificationEditorChanged";

NSString * const kEMCallChatter = @"kEMCallChatter";
NSString * const kEMCallType = @"kEMCallType";

NSString * const kEMCallTypeVoice = @"kEMCallActionVoice";
NSString * const kEMCallTypeVideo = @"kEMCallActionVideo";

+ (instancetype)sharedInstance{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            [EM_ChatFileUtils initialize];
            [EM_ChatDBUtils shared];
            sharedClient = [[self alloc] init];
        });
    }
    
    return sharedClient;
}

+ (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    return bCanRecord;
}

+ (BOOL)canVideo{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined) {
            return [GPUImageVideoCamera isFrontFacingCameraPresent];
        }else {
            return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized;
        }
    }
    return YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.extendRegisterClass = [[NSMutableDictionary alloc]init];
        [self registerNotifications];
        [self registerExtendClass:[EM_ChatMessageExtendCall class]];
        [self registerExtendClass:[EM_ChatMessageExtendFile class]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallIn:) name:kEMNotificationCallActionIn object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallOut:) name:kEMNotificationCallActionOut object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallShow:) name:kEMNotificationCallShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallDismiss:) name:kEMNotificationCallDismiss object:nil];
    }
    return self;
}

- (void)dealloc{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)registerExtendClass:(Class)cls{
    if (![cls isSubclassOfClass:[EM_ChatMessageExtendBody class]]) {
        return NO;
    }
    NSString *extendIdentifier = [cls identifierForExtend];
    NSString *extendClass = NSStringFromClass(cls);
    NSString *extendView = NSStringFromClass([cls viewForClass]);
    EM_ChatExtend *extend = [[EM_ChatDBUtils shared] queryExtendWithIdentifier:extendIdentifier];
    if (!extend) {
        extend = [[EM_ChatDBUtils shared] insertNewExtend];
    }
    extend.extendIdentifier = extendIdentifier;
    extend.extendClass = extendClass;
    extend.extendView = extendView;
    [self.extendRegisterClass setObject:extend forKey:extendIdentifier];
    
    [[EM_ChatDBUtils shared] saveChat];
    return YES;
}

- (Class)classForExtendWithIdentifier:(NSString *)identifier{
    if (identifier) {
        EM_ChatExtend *extend = self.extendRegisterClass[identifier];
        if (extend && extend.extendClass) {
            NSString *extendClass = extend.extendClass;
            return NSClassFromString(extendClass);
        }
    }
    return nil;
}

#pragma mark - notification
- (void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

- (void)chatCallIn:(NSNotification *)notification{
    EMCallSession *callSession = notification.object;
    if (!callSession) {
        return;
    }
    EM_CallController *callController = [[EM_CallController alloc]initWithSession:callSession type:callSession.type action:EMChatCallActionIn];
    callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[[[UIApplication sharedApplication].windows lastObject] rootViewController] presentViewController:callController animated:YES completion:nil];
}

- (void)chatCallOut:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *chatter = userInfo[kEMCallChatter];
    EMCallSessionType type = [userInfo[kEMCallType] integerValue];
    
    EMError *error = nil;
    EMCallSession *callSession;
    if (type == eCallSessionTypeAudio) {
        if (![EaseMobUIClient canRecord]) {
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.vioce"]];
            return;
        }
        callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:180 error:&error];
    }else{
        if (![EaseMobUIClient canVideo]) {
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.video"]];
            return;
        }
        callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:180 error:&error];
    }
    
    if (callSession && !error) {
        EM_CallController *callController = [[EM_CallController alloc]initWithSession:callSession type:type action:EMChatCallActionOut];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [[[[UIApplication sharedApplication].windows lastObject] rootViewController] presentViewController:callController animated:YES completion:nil];
    }else{
        if (type == eCallSessionTypeAudio) {
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.vioce"]];
        }else{
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.video"]];
        }
    }
}

- (void)chatCallShow:(NSNotification *)notification{
    self.callShow = YES;
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

- (void)chatCallDismiss:(NSNotification *)notification{
    self.callShow = NO;
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (void)registerForRemoteNotificationsWithApplication:(UIApplication *)application{
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

#pragma mark - application
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

//application
- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:application];
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}


#pragma mark - EMChatManagerDelegate
#pragma mark -
#pragma mark - EMChatManagerChatDelegate
- (void)didReceiveMessage:(EMMessage *)message{
    EM_ChatMessageModel *model = [EM_ChatMessageModel fromEMMessage:message];
    if (model.messageExtend.extendAttributes) {
        if (self.notificationDelegate && [self.notificationDelegate respondsToSelector:@selector(didReceiveMessageWithExtend:)]) {
            [self.notificationDelegate didReceiveMessageWithExtend:model.messageExtend.extendAttributes];
        }
    }
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[EMCDDeviceManager sharedInstance] playNewMessageSound];//声音
#if !TARGET_IPHONE_SIMULATOR
        [[EMCDDeviceManager sharedInstance] playVibration];//震动
#endif
    }else{
        
        NSString *alertBody;
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
            if ([model.messageExtend.identifier isEqualToString:kIdentifierForExtend]) {
                switch (model.messageBody.messageBodyType) {
                    case eMessageBodyType_Text:{
                        EMTextMessageBody *body = (EMTextMessageBody *)model.messageBody;
                        alertBody = body.text;
                    }
                        break;
                    case eMessageBodyType_Image:{
                        alertBody = [EM_ChatResourcesUtils stringWithName:@"notification.image_display"];
                    }
                        break;
                    case eMessageBodyType_Location:{
                        alertBody = [EM_ChatResourcesUtils stringWithName:@"notification.location_display"];
                    }
                        break;
                    case eMessageBodyType_Voice:{
                        alertBody = [EM_ChatResourcesUtils stringWithName:@"notification.voice_display"];
                    }
                        break;
                    default:{
                        alertBody = [EM_ChatResourcesUtils stringWithName:@"notification.other_display"];
                    }
                        break;
                }
            }else{
                if (self.notificationDelegate && [self.notificationDelegate respondsToSelector:@selector(alertBodyWithMessage:)]) {
                    alertBody = [self.notificationDelegate alertBodyWithMessage:model];
                }else{
                    alertBody = [EM_ChatResourcesUtils stringWithName:@"notification.other_display"];
                }
            }
            
            NSString *displayTitle;
            if (model.message.messageType == eMessageTypeGroupChat) {
                if (self.oppositeDelegate && [self.oppositeDelegate respondsToSelector:@selector(groupInfoWithChatter:)]) {
                    EM_ChatGroup *group = [self.oppositeDelegate groupInfoWithChatter:model.message.conversationChatter];
                    if (group && [self.oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:inGroup:)]) {
                        EM_ChatBuddy *buddy = [self.oppositeDelegate buddyInfoWithChatter:model.message.from inGroup:group];
                        displayTitle = [NSString stringWithFormat:@"%@(%@)",group.displayName,buddy.displayName];
                    }
                }
            }else if (model.message.messageType == eMessageTypeChatRoom){
                if (self.oppositeDelegate && [self.oppositeDelegate respondsToSelector:@selector(roomInfoWithChatter:)]) {
                    EM_ChatRoom *room = [self.oppositeDelegate roomInfoWithChatter:model.message.conversationChatter];
                    if (room && [self.oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:inRoom:)]) {
                        EM_ChatBuddy *buddy = [self.oppositeDelegate buddyInfoWithChatter:model.message.from inRoom:room];
                        displayTitle = [NSString stringWithFormat:@"%@(%@)",room.displayName,buddy.displayName];
                    }
                }
            }else{
                if (self.oppositeDelegate && [self.oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:)]) {
                    EM_ChatBuddy *buddy = [self.oppositeDelegate buddyInfoWithChatter:model.message.from];
                    displayTitle = buddy.displayName;
                }
            }
            
            if (!displayTitle || displayTitle.length == 0) {
                displayTitle = model.message.from;
            }
            alertBody = [NSString stringWithFormat:@"%@:%@",displayTitle,alertBody];
        }else{
            alertBody = [EM_ChatResourcesUtils stringWithName:@"notification.have_new_message"];
        }
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.alertBody = alertBody;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
#if !TARGET_IPHONE_SIMULATOR
        [[EMCDDeviceManager sharedInstance] playVibration];//震动
#endif
    }
}

#pragma mark - EMChatManagerLoginDelegate
#pragma mark - EMChatManagerEncryptionDelegate
#pragma mark - EMChatManagerBuddyDelegate
#pragma mark - EMChatManagerUtilDelegate
#pragma mark - EMChatManagerGroupDelegate
#pragma mark - EMChatManagerPushNotificationDelegate
#pragma mark - EMChatManagerChatroomDelegate

#pragma mark - EMCallManagerCallDelegate
#pragma mark -
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error{
    if (callSession.status == eCallSessionStatusConnected) {
        if (self.callShow) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Busy];
        }else{
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                if (callSession.type == eCallSessionTypeVideo) {
                    if (![EaseMobUIClient canVideo]) {
                        [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Null];
                        return;
                    }
                }else if(callSession.type == eCallSessionTypeAudio){
                    if (![EaseMobUIClient canRecord]) {
                        [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Null];
                        return;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallActionIn object:callSession userInfo:nil];
            }else{
                
                NSString *displayName = callSession.sessionChatter;
                if (self.oppositeDelegate && [self.oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:)]) {
                    EM_ChatBuddy *buddy = [self.oppositeDelegate buddyInfoWithChatter:callSession.sessionChatter];
                    displayName = buddy.displayName;
                }
                
                NSString *alertBody;
                
                if (callSession.type == eCallSessionTypeAudio) {
                    alertBody = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"notification.call_audio"],displayName];
                }else if (callSession.type == eCallSessionTypeVideo){
                    alertBody = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"notification.call_video"],displayName];
                }else{
                    alertBody = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"notification.call"],displayName];
                }
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = alertBody;
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [[EMCDDeviceManager sharedInstance] playVibration];//震动
            }
        }
    }
}

#pragma mark - EMDeviceManagerDelegate

#pragma mark - IEMChatProgressDelegate


@end