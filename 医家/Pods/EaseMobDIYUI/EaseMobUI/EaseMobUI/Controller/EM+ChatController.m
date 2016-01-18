//
//  EM+ChatController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatController.h"
#import "EM+LocationController.h"
#import "EM+ExplorerController.h"
#import "UIViewController+HUD.h"

#import "EM+ChatTableView.h"
#import "EM+ChatMessageCell.h"
#import "EM+ChatToolBar.h"
#import "EM+ChatInputTool.h"

#import "EM+ChatBuddy.h"
#import "EM+ChatGroup.h"
#import "EM+ChatRoom.h"
#import "EM+ChatMessageExtendCall.h"
#import "EM+ChatMessageExtendFile.h"
#import "EM_ChatConversation.h"

#import "EM+ChatMessageManager.h"
#import "EaseMobUIClient.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatDBUtils.h"

#import "UIColor+Hex.h"
#import "DDLog.h"

//
#import "EMCDDeviceManager+ProximitySensor.h"

#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ALERT_ACTION) {
    ALERT_ACTION_TAP_UNKOWN = 0,
    ALERT_ACTION_TAP_URL,
    ALERT_ACTION_TAP_PHONE,
    ALERT_ACTION_TAP_TEXT,
    ALERT_ACTION_TAP_IMAGE,
    ALERT_ACTION_TAP_VOICE,
    ALERT_ACTION_TAP_VIDEO,
    ALERT_ACTION_TAP_LOCATION,
    ALERT_ACTION_TAP_FILE,
    ALERT_ACTION_PRESS_UNKOWN,
    ALERT_ACTION_PRESS_URL,
    ALERT_ACTION_PRESS_PHONE,
    ALERT_ACTION_PRESS_TEXT,
    ALERT_ACTION_PRESS_IMAGE,
    ALERT_ACTION_PRESS_VOICE,
    ALERT_ACTION_PRESS_VIDEO,
    ALERT_ACTION_PRESS_LOCATION,
    ALERT_ACTION_PRESS_FILE,
};

@interface EM_ChatController()<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
EM_MessageToolBarDelegate,
EM_ChatMessageCellDelegate,
EM_LocationControllerDelegate,
EM_ExplorerControllerDelegate,
EM_ChatMessageManagerDelegate,
EMChatManagerDelegate,
IEMChatProgressDelegate,
EMDeviceManagerDelegate,
EMCDDeviceManagerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *voiceArray;
@property (nonatomic, strong) EM_ChatUIConfig *config;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIMenuController *menuController;

@property (nonatomic,strong) EM_ChatTableView *chatTableView;
@property (nonatomic,strong) EM_ChatToolBar *chatToolBarView;

@end

@implementation EM_ChatController{
    dispatch_queue_t _messageQueue;
}

- (instancetype)initWithOpposite:(EM_ChatOpposite *)opposite{
    self = [super init];
    if (self) {
        _opposite = opposite;
        
        EMConversationType conversationType;
        if (_opposite.oppositeType == EMChatOppositeTypeGroup) {
            conversationType = eConversationTypeGroupChat;
        }else if (_opposite.oppositeType == EMChatOppositeTypeRoom){
            conversationType = eConversationTypeChatRoom;
        }else{
            conversationType = eConversationTypeChat;
        }
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_opposite.uid conversationType:conversationType];
        [self initializeWithConversation:conversation];
    }
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType{
    self = [super init];
    if (self) {
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:conversationType];
        [self initializeWithConversation:conversation];
    }
    return self;
}

- (instancetype)initWithConversation:(EMConversation *)conversation{
    self = [super init];
    if (self) {
        [self initializeWithConversation:conversation];
    }
    return self;
}

- (void)initializeWithConversation:(EMConversation *)conversation{
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    _conversation = conversation;
    [_conversation markAllMessagesAsRead:YES];
    
    if (!_opposite) {
        id<EM_ChatOppositeDelegate> oppositeDelegate = [EaseMobUIClient sharedInstance].oppositeDelegate;
        if (oppositeDelegate && [oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:)]) {
            if (_conversation.conversationType == eConversationTypeGroupChat) {
                _opposite = [oppositeDelegate groupInfoWithChatter:_conversation.chatter];
            }else if(_conversation.conversationType == eConversationTypeChatRoom){
                _opposite = [oppositeDelegate roomInfoWithChatter:_conversation.chatter];
            }else{
                _opposite = [oppositeDelegate buddyInfoWithChatter:_conversation.chatter];
            }
        }else{
            if (_conversation.conversationType == eConversationTypeGroupChat) {
                _opposite = [[EM_ChatGroup alloc]init];
            }else if(_conversation.conversationType == eConversationTypeChatRoom){
                _opposite = [[EM_ChatRoom alloc]init];
            }else{
                _opposite = [[EM_ChatBuddy alloc]init];
            }
            _opposite.uid = _conversation.chatter;
            _opposite.displayName = _conversation.chatter;
        }
    }
    self.title = _opposite.displayName;
    
    if (!_user) {
        id<EM_ChatUserDelegate> userDelegate = [EaseMobUIClient sharedInstance].userDelegate;
        if (userDelegate && [userDelegate respondsToSelector:@selector(userForEMChat)]) {
            _user = [userDelegate userForEMChat];
        }else{
            NSString *loginChatter = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
            _user = [[EM_ChatUser alloc]init];
            _user.uid = loginChatter;
            _user.displayName = loginChatter;
        }
    }
    
    _dataSource = [[NSMutableArray alloc]init];
    _imageArray = @[[[NSMutableArray alloc]init],[[NSMutableArray alloc]init]];
    _voiceArray = @[[[NSMutableArray alloc]init],[[NSMutableArray alloc]init]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(configForChat)]) {
        self.config = [self.delegate configForChat];
    }
    if (!self.config) {
        self.config = [EM_ChatUIConfig defaultConfig];
    }
    
    if (self.conversation.conversationType != eConversationTypeChat) {
        [self.config removeActionWithName:kActionNameVoice];
        [self.config removeActionWithName:kActionNameVideo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndCall:) name:kEMNotificationCallDismiss object:nil];
    
    _chatTableView = [[EM_ChatTableView alloc]initWithFrame:self.view.frame];
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    _chatTableView.contentInset = UIEdgeInsetsMake(self.offestY > 0 ? self.offestY : 0, 0, 0, 0);
    _chatTableView.backgroundColor = [UIColor colorWithHexRGB:0xf0f0f0];
    [self.view addSubview:_chatTableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage:animated:)];
    [header setImages:nil forState:MJRefreshStateIdle];
    [header setImages:nil forState:MJRefreshStatePulling];
    [header setImages:nil forState:MJRefreshStateRefreshing];
    [header setImages:nil forState:MJRefreshStateWillRefresh];
    [header setImages:nil forState:MJRefreshStateNoMoreData];
    _chatTableView.header = header;
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(showKeyboardOrTool)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    _chatTableView.footer = footer;
    
    _chatToolBarView = [[EM_ChatToolBar alloc]initWithConfig:self.config];
    _chatToolBarView.frame = CGRectMake(0, self.view.frame.size.height - HEIGHT_INPUT_OF_DEFAULT, self.view.frame.size.width, HEIGHT_INPUT_OF_DEFAULT + HEIGHT_MORE_TOOL_OF_DEFAULT);
    _chatToolBarView.chatTableView = _chatTableView;
    _chatToolBarView.delegate = self;
    [self.view addSubview:_chatToolBarView];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [EMCDDeviceManager sharedInstance].delegate = self;
    [EM_ChatMessageManager defaultManager].delegate = self;
    
    _messageQueue = dispatch_queue_create("EaseMob", NULL);
    
    [self loadMoreMessage:YES animated:NO];
    
    [self queryEditor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _chatToolBarView.shouldReceiveKeyboardNotification = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _chatToolBarView.shouldReceiveKeyboardNotification = NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [self saveEditor];
}

- (void)dealloc{
    [self saveEditor];
    //NSString *editorText = _chatToolBarView.inputToolView.editor;
    //如果当前会话没有消息，则删除该会话
    //self.conversation.ext
    //这个属性说不定可以用来存储编辑状态
    //但是conversation没有保存ext的方法
    //    if ((!editorText || editorText.length == 0) && ![self.conversation latestMessage]) {
    //        //移除会话
    //    }
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (void)saveEditor{
    NSString *editorText = _chatToolBarView.inputToolView.editor;
    
    EM_ChatConversation *editor = [[EM_ChatDBUtils shared]queryConversationWithChatter:self.conversation.chatter];
    if (editorText && editorText.length > 0) {
        if (!editor) {
            editor = [[EM_ChatDBUtils shared] insertNewConversation];
            editor.chatter = self.conversation.chatter;
            editor.type = @(self.conversation.conversationType);
            editor.modify = [NSDate date];
        }
        editor.editor = editorText;
    }else{
        [[EM_ChatDBUtils shared] deleteConversationWithChatter:editor];
    }
    [[EM_ChatDBUtils shared] saveChat];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationEditorChanged object:nil];
}

- (void)queryEditor{
    EM_ChatConversation *editor = [[EM_ChatDBUtils shared]queryConversationWithChatter:self.conversation.chatter];
    if (editor) {
        _chatToolBarView.inputToolView.editor = editor.editor;
    }
}

- (void)didEndCall:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *chattar = userInfo[kEMCallChatter];
    if ([chattar isEqualToString:self.conversation.chatter]) {
        [_dataSource removeAllObjects];
        [self loadMoreMessage:YES animated:YES];
    }
}

#pragma mark - sendMessage
- (void)sendMessage:(EM_ChatMessageModel *)message{
    if (_dataSource.count > 0) {
        EM_ChatMessageModel *perMessage = [_dataSource lastObject];
        message.messageExtend.showTime = (message.message.timestamp - perMessage.message.timestamp) / 1000 >= 300;
    }else{
        message.messageExtend.showTime = YES;
    }
    if (!message.messageExtend.extendAttributes && self.delegate && [self.delegate respondsToSelector:@selector(extendForMessage:)]) {
        [self.delegate extendForMessage:message];
    }
    message.message.ext = [message.messageExtend toDictionary];
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message.message progress:self];
}

- (EM_ChatMessageModel*)formatMessage:(EMMessage *)message insert:(BOOL)insert{
    EM_ChatMessageModel *messageModel = [EM_ChatMessageModel fromEMMessage:message];
    NSString *loginChatter = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    messageModel.sender = [message.from isEqualToString:loginChatter];
    messageModel.messageSign = [[EM_ChatDBUtils shared] queryMessageWithId:message.messageId chatter:message.conversationChatter];
    if (!messageModel.messageSign) {
        messageModel.messageSign = [[EM_ChatDBUtils shared] insertNewMessage];
    }
    if (messageModel.sender) {
        messageModel.displayName = _user.displayName;
        messageModel.avatar = _user.avatar;
    }else{
        EM_ChatBuddy *buddy;
        id<EM_ChatOppositeDelegate> oppositeDelegate = [EaseMobUIClient sharedInstance].oppositeDelegate;
        if (self.opposite.oppositeType == EMChatOppositeTypeGroup) {
            if (oppositeDelegate && [oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:inGroup:)]) {
                buddy = [oppositeDelegate buddyInfoWithChatter:messageModel.message.from inGroup:(EM_ChatGroup *)_opposite];
            }
        }else if(self.opposite.oppositeType == EMChatOppositeTypeRoom){
            buddy = [oppositeDelegate buddyInfoWithChatter:messageModel.message.from inRoom:(EM_ChatRoom *)_opposite];
        }else{
            buddy = (EM_ChatBuddy *)_opposite;
        }
        messageModel.displayName = buddy.displayName;
        messageModel.avatar = buddy.avatar;
    }
    
    NSInteger index = 0;
    if (!messageModel.sender) {
        index = 1;
    }
    if (messageModel.messageBody.messageBodyType == eMessageBodyType_Voice) {
        NSMutableArray *senderVoiceArray =  self.voiceArray[index];
        if (![senderVoiceArray containsObject:messageModel]) {
            if (insert) {
                [senderVoiceArray insertObject:messageModel atIndex:0];
            }else{
                [senderVoiceArray addObject:messageModel];
            }
        }
    }else if (messageModel.messageBody.messageBodyType == eMessageBodyType_Image){
        NSMutableArray *senderImageArray =  self.imageArray[index];
        if (![senderImageArray containsObject:messageModel]) {
            if (insert) {
                [senderImageArray insertObject:messageModel atIndex:0];
            }else{
                [senderImageArray addObject:messageModel];
            }
        }
    }
    
    return messageModel;
}

- (void)addMessage:(EMMessage *)message{
    EM_ChatMessageModel *messageModel = [self formatMessage:message insert:NO];
    if (_dataSource.count > 0) {
        EM_ChatMessageModel *preMessage = _dataSource[_dataSource.count - 1];
        messageModel.messageExtend.showTime = preMessage.message.timestamp - messageModel.message.timestamp >= 1000 * 60 * 5;
    }
    
    [_dataSource addObject:messageModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_dataSource.count - 1) inSection:0];
    [_chatTableView beginUpdates];
    [_chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_chatTableView endUpdates];
    [_chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)reloadMessage:(EMMessage *)message{
    EM_ChatMessageModel *messageModel = [self formatMessage:message insert:NO];
    NSInteger index = [_dataSource indexOfObject:messageModel];
    if (index < 0 || index >= _dataSource.count){
        return;
    }
    
    [_dataSource replaceObjectAtIndex:index withObject:messageModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MAIN(^{
        [_chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if(index == _dataSource.count - 1){
            [_chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

- (void)reloadMessage:(EMMessage *)message progress:(CGFloat)progress{
    EM_ChatMessageModel *messageModel = [self formatMessage:message insert:NO];
    NSInteger index = [_dataSource indexOfObject:messageModel];
    if (index < 0 || index >= _dataSource.count){
        return;
    }
    
    [_dataSource replaceObjectAtIndex:index withObject:messageModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MAIN(^{
        [_chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if(index == _dataSource.count - 1){
            [_chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

#pragma mark - loadData
- (void)loadMoreMessage:(BOOL)scrollBottom animated:(BOOL)animated{
    long long timestamp = ([NSDate date].timeIntervalSince1970 + 1) * 1000;
    if (_dataSource.count > 0) {
        EM_ChatMessageModel *message = [_dataSource firstObject];
        timestamp = message.message.timestamp;
    }
    
    dispatch_async(_messageQueue,^{
        NSArray *messages = [_conversation loadNumbersOfMessages:20 before:timestamp];
        if (messages.count > 0) {
            for (NSInteger i = messages.count - 1; i >= 0; i--) {
                EM_ChatMessageModel *messageModel = [self formatMessage:messages[i] insert:YES];
                [_dataSource insertObject:messageModel atIndex:0];
            }
            
            MAIN(^{
                [_chatTableView reloadData];
                if (scrollBottom) {
                    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
                }
            });
        }
        
        MAIN(^{[_chatTableView.header endRefreshing];});
    });
}

- (void)showKeyboardOrTool{
    [_chatTableView.footer endRefreshing];
    if (!_chatToolBarView.keyboardVisible && !_chatToolBarView.moreToolVisble) {
        [_chatToolBarView pullUpShow];
    }
}

- (void)dismissKeyboard{
    [_chatToolBarView dismissKeyboard];
}

- (void)dismissMoreTool{
    [_chatToolBarView dismissMoreTool];
}

#pragma mark - EM_MessageToolBarDelegate
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didShowToolOrKeyboard:(BOOL)isShow{
    if (isShow && _dataSource.count > 0) {
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//InputTool
- (BOOL)messageToolBar:(EM_ChatToolBar *)toolBar shouldSendMessage:(NSString *)message{
    BOOL shouldSend = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldSendMessage:messageType:)]) {
        shouldSend = [self.delegate shouldSendMessage:message messageType:eMessageBodyType_Text];
    }
    return shouldSend;
}
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didSendMessagee:(NSString *)message{
    [self sendMessage:[EM_ChatMessageModel fromText:message conversation:self.conversation]];
}

//MoroTool
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didSelectedActionWithName:(NSString *)action{
    if ([action isEqualToString:kActionNameImage]) {
        
        BOOL photoAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        if (photoAvailable) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        }else{
            [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.device.not_support_photo_library"]];
        }
        
    }else if ([action isEqualToString:kActionNameCamera]){
        
        BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (cameraAvailable) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
            self.imagePicker.videoMaximumDuration = 180;
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        }else{
            [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.device.not_support_camera"]];
        }
    }else if ([action isEqualToString:kActionNameVoice]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallActionOut object:nil userInfo:@{kEMCallChatter:self.conversation.chatter,kEMCallType:@(eCallSessionTypeAudio)}];
    }else if ([action isEqualToString:kActionNameVideo]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallActionOut object:nil userInfo:@{kEMCallChatter:self.conversation.chatter,kEMCallType:@(eCallSessionTypeVideo)}];
    }else if ([action isEqualToString:kActionNameLocation]){
        
        EM_LocationController *locationController = [[EM_LocationController alloc]init];
        locationController.delegate = self;
        [self.navigationController pushViewController:locationController animated:YES];
    }else if ([action isEqualToString:kActionNameFile]){
        EM_ExplorerController *explorerController = [[EM_ExplorerController alloc]init];
        explorerController.delegate = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:explorerController] animated:YES completion:nil];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(didActionSelectedWithName:)]){
            [_delegate didActionSelectedWithName:action];
        }
    }
}
- (BOOL)messageToolBar:(EM_ChatToolBar *)toolBar shouldRecord:(UIView *)view{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)messageToolBar:(EM_ChatToolBar *)toolBar didStartRecord:(UIView *)view{
    
}

- (void)messageToolBar:(EM_ChatToolBar *)toolBar didCancelRecord:(UIView *)view{
    
}

- (void)messageToolBar:(EM_ChatToolBar *)toolBar didEndRecord:(NSString *)name record:(NSString *)recordPath duration:(NSInteger)duration{
    [self sendMessage:[EM_ChatMessageModel fromVoice:recordPath name:name duration:duration conversation:self.conversation]];
}

- (void)messageToolBar:(EM_ChatToolBar *)toolBar didRecordError:(NSError *)error{
    if (!error) {
        [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.record.too_short"]];
    }else{
        [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.record.failure"]];
    }
}

#pragma mark - EM_ChatMessageCellDelegate
- (void)chatMessageCell:(EM_ChatMessageCell *)cell didTapAvatarWithChatter:(NSString *)chatter indexPath:(NSIndexPath *)indexPath{
    NSString *loginChatter = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    BOOL isOwn = [chatter isEqualToString:loginChatter];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didAvatarTapWithChatter:isOwn:)]) {
        [_delegate didAvatarTapWithChatter:chatter isOwn:isOwn];
    }
}

- (void)chatMessageCell:(EM_ChatMessageCell *)cell resendMessageWithMessage:(EM_ChatMessageModel *)message indexPath:(NSIndexPath *)indexPath{
    [[EaseMob sharedInstance].chatManager resendMessage:message.message progress:self error:nil];
}

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didTapWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath{
    EM_ChatMessageModel *messageModel = userInfo[kHandleActionMessage];
    
    NSString *handleAction = userInfo[kHandleActionName];
    NSString *handleFrom = userInfo[kHandleActionFrom];
    
    if ([handleFrom isEqualToString:HANDLE_FROM_BODY]) {
        
        if ([handleAction isEqualToString:HANDLE_ACTION_URL]) {
            NSURL *url = userInfo[kHandleActionValue];
            [[UIApplication sharedApplication] openURL:url];
        }else if ([handleAction isEqualToString:HANDLE_ACTION_PHONE]){
            NSString *phone = userInfo[kHandleActionValue];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"hint.may_phone"],phone] delegate:self cancelButtonTitle:[EM_ChatResourcesUtils stringWithName:@"common.cancel"] destructiveButtonTitle:nil otherButtonTitles:[EM_ChatResourcesUtils stringWithName:@"common.call"],[EM_ChatResourcesUtils stringWithName:@"common.copy"],nil];
            sheet.tag = ALERT_ACTION_TAP_PHONE;
            [sheet showInView:self.view];
        }else if ([handleAction isEqualToString:HANDLE_ACTION_TEXT]){
            if ([messageModel.messageExtend.identifier isEqualToString:kIdentifierForCall]) {
                EM_ChatMessageExtendCall *callMessage = (EM_ChatMessageExtendCall *)messageModel.messageExtend.extendBody;
                [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallActionOut object:nil userInfo:@{kEMCallChatter:self.conversation.chatter,kEMCallType:@(callMessage.callType)}];
            }
        }else if ([handleAction isEqualToString:HANDLE_ACTION_IMAGE]){
            NSArray *imageArray;
            if (messageModel.sender) {
                imageArray = self.imageArray[0];
            }else{
                imageArray = self.imageArray[1];
            }
            
            if (![imageArray containsObject:messageModel]) {
                return;
            }
            [[EM_ChatMessageManager defaultManager] showBrowserWithImagesMessage:imageArray index:[imageArray indexOfObject:messageModel]];
        }else if ([handleAction isEqualToString:HANDLE_ACTION_VOICE]){
            if (messageModel.messageSign.checking) {
                [[EM_ChatMessageManager defaultManager] stopVoice];
                [_chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                NSArray *voiceArray;
                if (messageModel.sender) {
                    voiceArray = self.voiceArray[0];
                }else{
                    voiceArray = self.voiceArray[1];
                }
                
                if (![voiceArray containsObject:messageModel]) {
                    return;
                }
                if([EM_ChatMessageManager defaultManager].isPlaying){
                    [[EM_ChatMessageManager defaultManager] stopVoice];
                    [self.chatTableView reloadData];
                }
                
                [[EM_ChatMessageManager defaultManager] playVoice:voiceArray index:[voiceArray indexOfObject:messageModel]];
            }
        }else if ([handleAction isEqualToString:HANDLE_ACTION_VIDEO]){
            [[EM_ChatMessageManager defaultManager] showBrowserWithVideoMessage:messageModel];
        }else if ([handleAction isEqualToString:HANDLE_ACTION_LOCATION]){
            EMLocationMessageBody *locationBody = (EMLocationMessageBody *)messageModel.messageBody;
            EM_LocationController *locationController = [[EM_LocationController alloc]initWithLatitude:locationBody.latitude longitude:locationBody.longitude];
            [self.navigationController pushViewController:locationController animated:YES];
        }else if ([handleAction isEqualToString:HANDLE_ACTION_FILE]){
            
        }else if([handleAction isEqualToString:HANDEL_ACTION_BODY]){
            
        }else{
            
        }
        
        if (!messageModel.sender
            && !messageModel.messageSign.details
            && ![handleAction isEqualToString:HANDLE_ACTION_URL]
            && ![handleAction isEqualToString:HANDLE_ACTION_PHONE]
            && ![handleAction isEqualToString:HANDLE_ACTION_TEXT]){
            messageModel.messageSign.details = YES;
        }
    }else if ([handleFrom isEqualToString:HANDLE_FROM_EXTEND]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(didExtendTapWithUserInfo:)]) {
            [self.delegate didExtendTapWithUserInfo:userInfo];
        }
    }else{
        
    }
}

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didLongPressWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath{
    
    NSString *handleAction = userInfo[kHandleActionName];
    NSString *handleFrom = userInfo[kHandleActionFrom];
    
    if ([handleFrom isEqualToString:HANDLE_FROM_BODY]) {
        
        if ([handleAction isEqualToString:HANDLE_ACTION_URL]) {
            NSURL *url = userInfo[kHandleActionValue];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"hint.may_link"],url] delegate:self cancelButtonTitle:[EM_ChatResourcesUtils stringWithName:@"common.cancel"] destructiveButtonTitle:nil otherButtonTitles:[EM_ChatResourcesUtils stringWithName:@"common.open"],[EM_ChatResourcesUtils stringWithName:@"common.copy"],nil];
            sheet.tag = ALERT_ACTION_PRESS_URL;
            [sheet showInView:self.view];
        }else if ([handleAction isEqualToString:HANDLE_ACTION_PHONE]){
            NSString *phone = userInfo[kHandleActionValue];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"hint.may_phone"],phone] delegate:self cancelButtonTitle:[EM_ChatResourcesUtils stringWithName:@"common.cancel"] destructiveButtonTitle:nil otherButtonTitles:[EM_ChatResourcesUtils stringWithName:@"common.call"],[EM_ChatResourcesUtils stringWithName:@"common.copy"],nil];
            sheet.tag = ALERT_ACTION_PRESS_PHONE;
            [sheet showInView:self.view];
        }else{
            [self showMenuViewControllerWithUserInfo:userInfo];
        }
    }else if([handleFrom isEqualToString:HANDLE_FROM_EXTEND]){
        [self showMenuViewControllerWithUserInfo:userInfo];
    }else{
        
    }
}

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didMenuSelectedWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath{
    
    EM_ChatMessageModel *message = userInfo[kHandleActionMessage];
    NSString *action = userInfo[kHandleActionName];
    NSString *handleFrom = userInfo[kHandleActionFrom];
    
    if ([handleFrom isEqualToString:HANDLE_FROM_BODY]) {
        if ([action isEqualToString:MENU_ACTION_DELETE]) {
            BOOL delete = [self.conversation removeMessage:message.message];
            if (delete) {
                [_dataSource removeObject:message];
                
                [self.chatTableView beginUpdates];
                [self.chatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.chatTableView endUpdates];
                
            }else{
                [self showHint:[EM_ChatResourcesUtils stringWithName:@"common.hint.delete.failure"]];
            }
        }else if ([action isEqualToString:MENU_ACTION_COPY]){
            EMTextMessageBody *textBody = (EMTextMessageBody *)message.messageBody;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = textBody.text;
        }else if ([action isEqualToString:MENU_ACTION_FACE]){
            [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.function_null"]];
        }else if ([action isEqualToString:MENU_ACTION_DOWNLOAD]){
            [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.function_null"]];
        }else if ([action isEqualToString:MENU_ACTION_COLLECT]){
            message.messageSign.collected = !message.messageSign.collected;
        }else if ([action isEqualToString:MENU_ACTION_FORWARD]){
            [self showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.function_null"]];
        }
    }else if([handleFrom isEqualToString:HANDLE_FROM_EXTEND]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(didExtendMenuSelectedWithUserInfo:)]) {
            [self.delegate didExtendMenuSelectedWithUserInfo:userInfo];
        }
    }else{
        
    }
}

#pragma mark - ShowMenu
- (void)showMenuViewControllerWithUserInfo:(NSDictionary *)userInfo{
    
    if (!_menuController) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    EM_ChatMessageContent *contentView = userInfo[kHandleActionView];
    
    NSArray *menuItems = [contentView menuItems];
    if (menuItems.count == 0) {
        return;
    }
    
    [_menuController setMenuItems:menuItems];
    
    if (_chatToolBarView.inputEditing) {
        _chatToolBarView.inputToolView.overrideNextResponder = contentView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    }else{
        [contentView becomeFirstResponder];
    }
    
    [_menuController setTargetRect:contentView.frame inView:contentView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)menuDidHide:(NSNotification*)notification {
    _chatToolBarView.inputToolView.overrideNextResponder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

#pragma mark - EM_ChatMessageManagerDelegate
- (void)didStartPlayWithMessage:(EM_ChatMessageModel *)next previous:(EM_ChatMessageModel *)previous{
    
    NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:next] inSection:0];
    NSArray *indexs;
    
    if (previous) {
        NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:previous] inSection:0];
        indexs = @[nextIndex,previousIndex];
    }else{
        indexs = @[nextIndex];
    }
    MAIN(^{
        [self.chatTableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)didEndPlayWithMessage:(EM_ChatMessageModel *)message{
    NSIndexPath *index = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:message] inSection:0];
    MAIN(^{
        [self.chatTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case ALERT_ACTION_TAP_PHONE:
        case ALERT_ACTION_PRESS_PHONE:{
            NSString *title = actionSheet.title;
            NSRange startRange = [title rangeOfString:@"["];
            NSRange endRange = [title rangeOfString:@"]"];
            NSString *phone = [title substringWithRange:NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1)];
            if (buttonIndex == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
            }else if (buttonIndex == 1){
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = phone;
            }
        }
            break;
        case ALERT_ACTION_PRESS_URL:{
            NSString *title = actionSheet.title;
            NSRange startRange = [title rangeOfString:@"["];
            NSRange endRange = [title rangeOfString:@"]"];
            NSString *url = [title substringWithRange:NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1)];
            if (buttonIndex == 0) {
                [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:url]];
            }else if (buttonIndex == 1){
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = url;
            }
        }
        default:
            break;
    }
}

#pragma mark - EM_LocationControllerDelegate
-(void)sendLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address{
    [self sendMessage:[EM_ChatMessageModel fromLatitude:latitude longitude:longitude address:address conversation:self.conversation ]];
}

#pragma mark - EM_ExplorerControllerDelegate
- (void)didFileSelected:(NSArray *)files{
    for (NSString *path in files) {
        
        NSString *folder = [path stringByDeletingLastPathComponent];
        EM_ChatMessageExtendFile *extendBody = [[EM_ChatMessageExtendFile alloc]init];
        extendBody.fileType = folder.lastPathComponent;
        
        EM_ChatMessageModel *messageModel = [EM_ChatMessageModel fromFile:path name:path.lastPathComponent conversation:self.conversation];
        messageModel.messageExtend.extendBody = extendBody;
        
        [self sendMessage:messageModel];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [self sendMessage:[EM_ChatMessageModel fromImage:orgImage conversation:self.conversation]];
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        [self sendMessage:[EM_ChatMessageModel fromVideo:[mp4 relativePath] conversation:self.conversation]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EM_ChatMessageModel *message = _dataSource[indexPath.row];
    NSString *cellId = [message reuseIdentifier];
    
    EM_ChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EM_ChatMessageCell alloc]initWithBodyClass:[message classForBodyView] extendClass:[[message.messageExtend.extendBody class] viewForClass] reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.config = self.config.messageConfig;
    }
    cell.message = message;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EM_ChatMessageModel *message = _dataSource[indexPath.row];
    CGFloat max = tableView.bounds.size.width;
    CGFloat height = [EM_ChatMessageCell heightForCellWithMessage:message maxWidth:max indexPath:indexPath config:self.config.messageConfig];
    return height;
}

#pragma mark - IEMChatProgressDelegate
- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody{
    [self reloadMessage:message progress:progress];
}

#pragma mark - EMChatManagerChatDelegate
- (void)willSendMessage:(EMMessage *)message error:(EMError *)error{
    if (![_dataSource containsObject:message] && !error) {
        [self addMessage:message];
    }
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error{
    if(!error)[self reloadMessage:message];
}

- (void)didReceiveMessage:(EMMessage *)message{
    if ([message.conversationChatter isEqualToString:_conversation.chatter]) {
        [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        //标记已读
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
            [self.conversation markMessageWithId:message.messageId asRead:YES];
        }
        [self addMessage:message];
    }
}

- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage{
    
}

- (void)didReceiveMessageId:(NSString *)messageId chatter:(NSString *)conversationChatter error:(EMError *)error{
    //发送消息出现错误
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    //图片、视频缩略图,语音等下载进度
    [self reloadMessage:message progress:progress];
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    //图片、视频缩略图,语音等下载完成
    [self reloadMessage:message];
}

- (void)didUnreadMessagesCountChanged{
    //未读消息数量发生变化
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(@"接收离线消息中");
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(@"接收离线消息完毕");
    [_dataSource removeAllObjects];
    [self loadMoreMessage:YES animated:YES];
}

- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages{
    
}

#pragma mark - EMChatManagerGroupDelegate
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error{
    //聊天中,被请出
    if (self.conversation.conversationType != eConversationTypeGroupChat){
        return;
    }
    
    [self showHint:[EM_ChatResourcesUtils stringWithName:@"hint.extrude"]];
    [self.navigationController popViewControllerAnimated:YES];
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:@[self.conversation.chatter] deleteMessages:NO append2Chat:YES];
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error{
    //聊天中,群信息发生变化(成员,公告)
    if (self.conversation.conversationType != eConversationTypeGroupChat){
        return;
    }
}

#pragma mark - EMChatManagerChatroomDelegate
- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username{
    //聊天中,有成员加入
    if (self.conversation.conversationType != eConversationTypeChatRoom){
        return;
    }
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username{
    //聊天中,有成员离开
    if (self.conversation.conversationType != eConversationTypeChatRoom){
        return;
    }
}

- (void)beKickedOutFromChatroom:(EMChatroom *)chatroom reason:(EMChatroomBeKickedReason)reason{
    //聊天中,被请出
    if (self.conversation.conversationType != eConversationTypeChatRoom){
        return;
    }
    [self showHint:[EM_ChatResourcesUtils stringWithName:@"hint.extrude"]];
    [self.navigationController popViewControllerAnimated:YES];
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:@[self.conversation.chatter] deleteMessages:NO append2Chat:YES];
}

#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser){
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    [audioSession setActive:YES error:nil];
}

@end