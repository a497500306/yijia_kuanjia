//
//  EM+BuddyListController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"
@class EM_ChatOpposite;

@protocol EM_ChatBuddyListControllerDataSource;
@protocol EM_ChatBuddyListControllerDelegate;

@interface EM_BuddyListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatBuddyListControllerDataSource> dataSource;
@property (nonatomic, weak) id<EM_ChatBuddyListControllerDelegate> delegate;

- (void)reloadTagBar;

- (void)reloadOppositeList;

- (void)reloadOppositeGroupWithIndex:(NSInteger)index;

- (void)startRefresh;

- (void)endRefresh;

@end

@protocol EM_ChatBuddyListControllerDataSource <NSObject>

@required

/**
 *  是否显示搜索
 *
 *  @return 默认NO
 */
- (BOOL)shouldShowSearchBar;

/**
 *  是否显示Tag
 *
 *  @return 默认NO
 */
- (BOOL)shouldShowTagBar;

/**
 *  每个分组有多少个好友，群或者讨论组
 *
 *  @param groupIndex 组索引
 *
 *  @return 默认0
 */
- (NSInteger)numberOfRowsAtGroupIndex:(NSInteger)groupIndex;

/**
 *  好友，群或者讨论组数据
 *
 *  @param rowIndex
 *  @param groupIndex 组索引
 *
 *  @return 默认nil
 */
- (EM_ChatOpposite *)dataForRow:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex;

@optional

/**
 *  搜索结果数量
 *
 *  @return 默认0
 */
- (NSInteger)numberOfRowsForSearch;

/**
 *  搜索数据
 *
 *  @param index
 *
 *  @return
 */
- (EM_ChatOpposite *)dataForSearchRowAtIndex:(NSInteger)index;

/**
 *  tag数据量
 *
 *  @return 默认0
 */
- (NSInteger)numberOfTags;

/**
 *  tag是否需要被选中
 *  在初始化加载时，默认第一个允许selected的tag为YES
 *  @return 默认NO
 */
- (BOOL)shouldSelectedForTagAtIndex:(NSInteger)index;

/**
 *  tag标题
 *
 *  @param index tag索引
 *
 *  @return 默认nil
 */
- (NSString *)titleForTagAtIndex:(NSInteger)index;

/**
 *  tag字体
 *
 *  @param index
 *
 *  @return
 */
- (UIFont *)fontForTagAtIndex:(NSInteger)index;

/**
 *  tag图标
 *
 *  @param index
 *
 *  @return
 */
- (NSString *)iconForTagAtIndex:(NSInteger)index;

/**
 *  角标
 *
 *  @param index
 *
 *  @return 
 */
- (NSInteger)badgeForTagAtIndex:(NSInteger)index;

/**
 *  是否显示分组管理菜单
 *
 *  @return
 */
- (BOOL)shouldShowGroupManage;

/**
 *  好友分组数量
 *
 *  @return 默认1
 */
- (NSInteger)numberOfGroups;

/**
 *  是否展开分组
 *  只有numberOfGroups大于1时设置才有效
 *  @param groupIndex
 *
 *  @return 默认YES
 */
- (BOOL)shouldExpandForGroupAtIndex:(NSInteger)index;

/**
 *  分组标题
 *
 *  @param index
 *
 *  @return 默认 "我的好友"
 */
- (NSString *)titleForGroupAtIndex:(NSInteger)index;

@end

@protocol EM_ChatBuddyListControllerDelegate <NSObject>

@required

@optional

/**
 *  搜索
 *
 *  @param searchString
 *
 *  @return 是否加载搜索结果
 */
- (BOOL)shouldReloadSearchForSearchString:(NSString *)searchString;

/**
 *  tag被点击
 *
 *  @param index
 */
- (void)didSelectedForTagAtIndex:(NSInteger)index;

/**
 *  分组管理被点击
 *
 *  @param groupIndex 
 */
- (void)didSelectedForGroupManageAtIndex:(NSInteger)groupIndex;

/**
 *  分组被点击
 *
 *  @param groupIndex
 */
- (void)didSelectedForGroupAtIndex:(NSInteger)groupIndex;

/**
 *  好友，群或者讨论组被点击
 *
 *  @param opposite
 */
- (void)didSelectedWithOpposite:(EM_ChatOpposite *)opposite;

/**
 *  已经开始开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  已经结束下拉刷新
 */
- (void)didEndRefresh;

@end