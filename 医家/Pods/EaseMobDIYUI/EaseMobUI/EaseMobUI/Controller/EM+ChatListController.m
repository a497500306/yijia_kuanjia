//
//  EM+ChatListController.m
//  EaseMobUI 会话列表
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatListController.h"
#import "EM+ChatController.h"

#import "EM+ChatTableView.h"
#import "EM+ConversationCell.h"

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendCall.h"
#import "EM_ChatConversation.h"

#import "EM+Common.h"
#import "EaseMobUIClient.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatDateUtils.h"
#import "EM+ChatDBUtils.h"
#import "RealtimeSearchUtil.h"

#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface EM_ChatListController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,EMChatManagerDelegate,EM_ChatTableViewTapDelegate,SWTableViewCellDelegate>

@property (nonatomic, strong) EM_ChatTableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) NSArray *dataConversations;
@property (nonatomic, assign) BOOL needReload;

@end

@implementation EM_ChatListController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = [EM_ChatResourcesUtils stringWithName:@"common.message"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndCall:) name:kEMNotificationCallDismiss object:nil];
    
    
    
    CGFloat rowHiehgt = 74;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForConversationRow)]) {
        rowHiehgt = [self.delegate heightForConversationRow];
    }
    
    _tableView = [[EM_ChatTableView alloc]initWithFrame:self.view.frame];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = rowHiehgt;
    _tableView.contentInset = UIEdgeInsetsMake(self.offestY > 0 ? self.offestY : 0, 0, 0, 0);
    _tableView.tapDelegate = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(didBeginRefresh)];
    _tableView.header = header;
    [self.view addSubview:_tableView];
    
    BOOL showSearch = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldShowSearchBar)]) {
        showSearch = [self.delegate shouldShowSearchBar];
    }
    
    if (showSearch) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _tableView.tableHeaderView = _searchBar;
        
        _searchController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
    }
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    if (!self.dataSource) {
        self.needReload = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChatEditorChanged) name:kEMNotificationEditorChanged object:nil];
    [self setBadgeValue];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needReload) {
        [self reloadData];
        self.needReload = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_searchBar && _searchBar.isFirstResponder) {
        [_searchController setActive:NO];
    }
}

- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setBadgeValue{
    if (self.tabBarItem) {
        NSInteger unreadMessagesCount = [[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
        if (unreadMessagesCount > 0) {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",unreadMessagesCount];
        }else{
            self.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)didEndCall:(NSNotification *)notification{
    if (self.isShow) {
        [_tableView reloadData];
    }else{
        self.needReload = YES;
    }
}

- (void)reloadData{
    //刷新数据
    if (self.dataSource) {
        [_tableView reloadData];
    }else{
        [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
}

- (void)startRefresh{
    [_tableView.header beginRefreshing];
}

- (void)endRefresh{
    [_tableView.header endRefreshing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndRefresh)]) {
        [self.delegate didEndRefresh];
    }
}

- (void)didBeginRefresh{
    //如果没有代理方法直接结束刷新,如果有则需要用户自己调用结束刷新方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartRefresh)]) {
        [self.delegate didStartRefresh];
    }else{
        [self reloadData];
    }
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (index == 0) {
        if (self.dataSource) {
            EMConversation *conversation = [self.dataSource dataForRowAtIndex:indexPath.row];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didDeletedWithConversation:)]) {
                [self.delegate didDeletedWithConversation:conversation];
            }
        }else{
            EMConversation *conversation = _dataConversations[indexPath.row];
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:NO append2Chat:YES];
        }
    }
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc]init];
    }
    [_searchResultArray removeAllObjects];
    
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:[EaseMob sharedInstance].chatManager.conversations searchText:searchString collationStringSelector:nil resultBlock:^(NSArray *results) {
        MAIN(^{
            [_searchResultArray addObjectsFromArray:results];
        });
    }];
    return YES;
}

#pragma mark - EM_ChatTableViewTapDelegate
- (void)chatTableView:(EM_ChatTableView *)table didTapEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_searchBar && _searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (self.dataSource) {
            return [self.dataSource numberOfRows];
        }else{
            return _dataConversations.count;
        }
    }else{
        return _searchResultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"conversation";
    
    EMConversation *conversation;
    if (tableView == _tableView) {
        if (self.dataSource) {
            conversation = [self.dataSource dataForRowAtIndex:indexPath.row];;
        }else{
            conversation = _dataConversations[indexPath.row];
        }
    }else{
        conversation = _searchResultArray[indexPath.row];
    }
    
    EM_ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EM_ConversationCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (tableView == _tableView) {
        if (self.dataSource) {
            cell.topLineView.hidden = indexPath.row != [self.dataSource numberOfRows] - 1;
        }else{
            cell.topLineView.hidden = indexPath.row != _dataConversations.count - 1;
        }
    }else{
        cell.topLineView.hidden = indexPath.row != _searchResultArray.count - 1;
    }
    
    EM_ChatOpposite *opposite;
    id<EM_ChatOppositeDelegate> oppositeDelegate = [EaseMobUIClient sharedInstance].oppositeDelegate;
    if (oppositeDelegate) {
        if (conversation.conversationType == eConversationTypeGroupChat) {
            if ([oppositeDelegate respondsToSelector:@selector(groupInfoWithChatter:)]) {
                opposite = [oppositeDelegate groupInfoWithChatter:conversation.chatter];
            }
        }else if (conversation.conversationType == eConversationTypeChatRoom){
            if ([oppositeDelegate respondsToSelector:@selector(roomInfoWithChatter:)]) {
                opposite = [oppositeDelegate roomInfoWithChatter:conversation.chatter];
            }
        }else{
            if ([oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:)]) {
                opposite = [oppositeDelegate buddyInfoWithChatter:conversation.chatter];
            }
        }
    }
    if (opposite) {
        if (opposite.avatar) {
            [cell.avatarView sd_setImageWithURL:opposite.avatar forState:UIControlStateNormal placeholderImage:[EM_ChatResourcesUtils defaultAvatarImage]];
        }else{
            [cell.avatarView setImage:[EM_ChatResourcesUtils defaultAvatarImage] forState:UIControlStateNormal];
        }
        if (opposite.displayName) {
            cell.nameLabel.text = opposite.displayName;
        }else{
            cell.nameLabel.text = conversation.chatter;
        }
    }else{
        [cell.avatarView setImage:[EM_ChatResourcesUtils defaultAvatarImage] forState:UIControlStateNormal];
        cell.nameLabel.text = conversation.chatter;
    }
    
    NSInteger unreadCount = conversation.unreadMessagesCount;
    cell.unreadLabel.hidden = unreadCount == 0;
    cell.unreadLabel.text = [NSString stringWithFormat:@"%ld",unreadCount];
    
    NSMutableAttributedString *introAttributedString;
    NSString *timeString;
    EM_ChatConversation *editor = [[EM_ChatDBUtils shared]queryConversationWithChatter:conversation.chatter];
    if (editor) {
        NSString *draft = [EM_ChatResourcesUtils stringWithName:@"common.message_draft"];
        NSString *intro = [NSString stringWithFormat:@"%@%@",draft,editor.editor];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor redColor],NSForegroundColorAttributeName,nil];
        
        introAttributedString = [[NSMutableAttributedString alloc]initWithString:intro];
        [introAttributedString setAttributes:attributes range:NSMakeRange(0,draft.length)];
        
        timeString = [EM_ChatDateUtils stringFormatterMessageDateFromDate:editor.modify];
    }else{
        EM_ChatMessageModel *message = [EM_ChatMessageModel fromEMMessage:[conversation latestMessage]];
        if (message) {
            if ([message.messageExtend.identifier isEqualToString:kIdentifierForCall]){
                EMTextMessageBody *body = (EMTextMessageBody *)message.messageBody;
                introAttributedString = [[NSMutableAttributedString alloc]initWithString:body.text];
            }else{
                if (self.display && [self.display respondsToSelector:@selector(introForConversationWithOpposite:message:)]) {
                    introAttributedString = [self.display introForConversationWithOpposite:opposite message:message];
                }
                if (!introAttributedString || introAttributedString.length == 0) {
                    
                    NSString *intro = nil;
                    switch (message.messageBody.messageBodyType) {
                        case eMessageBodyType_Text:{
                            EMTextMessageBody *body = (EMTextMessageBody *)message.messageBody;
                            intro = body.text;
                        }
                            break;
                        case eMessageBodyType_Image:{
                            intro = [EM_ChatResourcesUtils stringWithName:@"common.message_type_image"];
                        }
                            break;
                        case eMessageBodyType_Video:{
                            intro = [EM_ChatResourcesUtils stringWithName:@"common.message_type_video"];
                        }
                            break;
                        case eMessageBodyType_Voice:{
                            intro = [EM_ChatResourcesUtils stringWithName:@"common.message_type_voice"];
                        }
                            break;
                        case eMessageBodyType_File:{
                            EMFileMessageBody *body = (EMFileMessageBody *)message.messageBody;
                            intro = [NSString stringWithFormat:@"%@%@",[EM_ChatResourcesUtils stringWithName:@"common.message_type_file"],body.displayName];
                        }
                            break;
                        case eMessageBodyType_Location:{
                            EMLocationMessageBody *body = (EMLocationMessageBody *)message.messageBody;
                            intro = [NSString stringWithFormat:@"%@%@",[EM_ChatResourcesUtils stringWithName:@"common.message_type_location"],body.address];
                        }
                            break;
                        default:{
                            intro = [EM_ChatResourcesUtils stringWithName:@"common.message_type_unkown"];
                        }
                            break;
                    }
                    
                    EM_ChatBuddy *buddy;
                    
                    if (opposite) {
                        //oppositeDelegate必然不为nil
                        if (opposite.oppositeType != EMChatOppositeTypeChat) {
                            if (opposite.oppositeType == EMChatOppositeTypeGroup && [oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:inGroup:)]) {
                                buddy = [oppositeDelegate buddyInfoWithChatter:message.message.from inGroup:(EM_ChatGroup *)opposite];
                            }else if (opposite.oppositeType == EMChatOppositeTypeRoom && [oppositeDelegate respondsToSelector:@selector(buddyInfoWithChatter:inRoom:)]){
                                buddy = [oppositeDelegate buddyInfoWithChatter:message.message.from inRoom:(EM_ChatRoom *)opposite];
                            }
                        }else{
                            buddy = (EM_ChatBuddy *)opposite;
                        }
                    }
                    
                    if (conversation.conversationType != eConversationTypeChat) {
                        if (buddy) {
                            intro = [NSString stringWithFormat:@"[%@]%@",buddy.displayName,intro];
                        }else{
                            intro = [NSString stringWithFormat:@"[%@]%@",message.message.from,intro];
                        }
                    }
                    
                    introAttributedString = [[NSMutableAttributedString alloc]initWithString:intro];
                }
            }
            timeString = [EM_ChatDateUtils stringFormatterMessageDateFromTimeInterval:message.message.timestamp / 1000];
        }else{
            if (self.display && [self.display respondsToSelector:@selector(introForConversationWithOpposite:message:)]) {
                introAttributedString = [self.display introForConversationWithOpposite:opposite message:message];
            }else{
                if (opposite && opposite.intro) {
                    introAttributedString = [[NSMutableAttributedString alloc]initWithString:opposite.intro];
                }
            }
            
            timeString = nil;
        }
    }
    cell.introLabel.attributedText = introAttributedString;
    cell.timeLabel.text = timeString;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation *conversation;
    if (tableView == _tableView) {
        if (self.dataSource) {
            conversation = [self.dataSource dataForRowAtIndex:indexPath.row];
        }else{
            conversation = _dataConversations[indexPath.row];
        }
    }else{
        conversation = _searchResultArray[indexPath.row];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithConversation:)]) {
        [self.delegate didSelectedWithConversation:conversation];
    }else{
        EM_ChatController *chatController = [[EM_ChatController alloc]initWithConversation:conversation];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (void)didChatEditorChanged{
    if (self.isShow) {
        [_tableView reloadData];
    }else{
        self.needReload = YES;
    }
}

#pragma mark - EMChatManagerChatDelegate
- (void)didUpdateConversationList:(NSArray *)conversationList{
    NSComparator comparator = ^(id obj1, id obj2){
        EMConversation *msg1 = obj1;
        EMConversation *msg2 = obj2;
        
        if (msg1.latestMessage && msg2.latestMessage) {
            if (msg1.latestMessage.timestamp > msg2.latestMessage.timestamp) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            if (msg1.latestMessage.timestamp < msg2.latestMessage.timestamp) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    _dataConversations = [[EaseMob sharedInstance].chatManager.conversations sortedArrayUsingComparator:comparator];
    
    //手动向会话添加消息时
    [self endRefresh];
    if (self.isShow) {
        [_tableView reloadData];
    }else{
        self.needReload = YES;
    }
}

- (void)didReceiveMessage:(EMMessage *)message{
    if (self.isShow) {
        [self reloadData];
    }else{
        self.needReload = YES;
    }
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    if (self.isShow) {
        [self reloadData];
    }else{
        self.needReload = YES;
    }
}

- (void)didUnreadMessagesCountChanged{
    if (self.isShow) {
        [self reloadData];
    }else{
        self.needReload = YES;
    }
    [self setBadgeValue];
}

#pragma mark - EMChatManagerBuddyDelegate
//好友增加或删除,特殊的会话消息

#pragma mark - EMChatManagerUtilDelegate
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    
}

#pragma mark - EMChatManagerGroupDelegate
//群操作,特殊的会话消息

#pragma mark - EMChatManagerChatroomDelegate
//聊天室操作,特殊的会话消息

#pragma mark - EMChatManagerPushNotificationDelegate

@end