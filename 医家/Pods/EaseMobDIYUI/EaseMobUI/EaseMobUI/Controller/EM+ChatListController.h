//
//  EM+ChatListController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"
@class EMConversation;
@class EM_ChatMessageModel;
@class EM_ChatOpposite;
@class EM_ConversationCell;

@protocol EM_ChatListControllerDisplay;
@protocol EM_ChatListControllerDataSource;
@protocol EM_ChatListControllerDelegate;

@interface EM_ChatListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatListControllerDisplay> display;

@property (nonatomic, weak) id<EM_ChatListControllerDataSource> dataSource;

@property (nonatomic, weak) id<EM_ChatListControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

@property (nonatomic, strong, readonly) UISearchBar *searchBar;


/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  开始下拉刷新
 */
- (void)startRefresh;

/**
 *  结束下拉刷新，这里回自动调用reloadData方法
 */
- (void)endRefresh;

@end

@protocol EM_ChatListControllerDisplay <NSObject>

@optional

/**
 *  会话显示的简短信息
 *  如果是编辑状态则默认显示编辑内容，此时不会调用该代理;
 *  如果是语音通讯或者视频通讯则默认显示通话结果，此时不会调用该代理;
 *  如果返回nil或者未实现，则默认显示最新一条消息的内容
 *  @param opposite 聊天对象，好友，群，聊天室
 *  @param message  聊天的最新一条消息，有可能为空
 */
- (NSMutableAttributedString *)introForConversationWithOpposite:(EM_ChatOpposite *)opposite message:(EM_ChatMessageModel *)message;

@end

@protocol EM_ChatListControllerDataSource <NSObject>

@required

- (NSInteger)numberOfRows;

- (EMConversation *)dataForRowAtIndex:(NSInteger)index;

@optional

@end

@protocol EM_ChatListControllerDelegate <NSObject>

@required

@optional

/**
 *  是否显示搜索
 *  默认YES,如果返回NO,则searchController和searchBar未nil
 *
 *  @return 
 */
- (BOOL)shouldShowSearchBar;

/**
 *  会话列表的行高
 *
 *  @return 
 */
- (CGFloat)heightForConversationRow;

/**
 *  选中某一会话
 *
 *  @param conversation
 */
- (void)didSelectedWithConversation:(EMConversation *)conversation;

/**
 *  删除某一会话
 *  只有在设置了dataSource才会调用
 *  @param conversation 
 */
- (void)didDeletedWithConversation:(EMConversation *)conversation;

/**
 *  开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  结束下拉刷新
 */
- (void)didEndRefresh;

@end