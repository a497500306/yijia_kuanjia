//
//  EM+ConversationCell.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "SWTableViewCell.h"

@interface EM_ConversationCell : SWTableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, assign) CGFloat bottomPadding;

@property (nonatomic, strong, readonly) UIView *topLineView;
@property (nonatomic, strong, readonly) UIView *bottomLineView;

@property (nonatomic, strong, readonly) UIButton *avatarView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *introLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *unreadLabel;

@end