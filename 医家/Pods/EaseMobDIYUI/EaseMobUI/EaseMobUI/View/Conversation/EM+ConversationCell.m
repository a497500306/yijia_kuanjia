//
//  EM+ConversationCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ConversationCell.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

@implementation EM_ConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.layer.masksToBounds = YES;
        self.topPadding = 15;
        self.bottomPadding = 15;
        
        self.rightUtilityButtons = [self rightButtons];
        
        _avatarView = [[UIButton alloc]init];
        _avatarView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
        
        _introLabel = [[UILabel alloc]init];
        _introLabel.textColor = [UIColor colorWithHexRGB:TEXT_NORMAL_COLOR];
        _introLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_introLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor colorWithHexRGB:TEXT_NORMAL_COLOR];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc]init];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.font = [UIFont systemFontOfSize:12];
        _unreadLabel.bounds = CGRectMake(0, 0, 14, 14);
        _unreadLabel.layer.masksToBounds = YES;
        _unreadLabel.layer.cornerRadius = _unreadLabel.bounds.size.height / 2;
        [self.contentView addSubview:_unreadLabel];
        
        
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_topLineView];
        
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    [_timeLabel sizeToFit];
    _timeLabel.center = CGPointMake(size.width - RIGHT_PADDING -_timeLabel.frame.size.width / 2, self.topPadding + (size.height - self.topPadding - self.bottomPadding) / 4);
    _unreadLabel.center = CGPointMake(_timeLabel.center.x, self.topPadding + (size.height - self.topPadding - self.bottomPadding) / 4 * 3);
    
    _avatarView.frame = CGRectMake(LEFT_PADDING, self.topPadding, size.height - self.topPadding - self.bottomPadding, size.height - self.topPadding - self.bottomPadding);
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width / 2;
    
    CGFloat x = _avatarView.frame.origin.x + _avatarView.frame.size.width + LEFT_PADDING;
    CGFloat width = _timeLabel.frame.origin.x - COMMON_PADDING - x;
    CGFloat height = (size.height - self.topPadding - self.bottomPadding) / 2;
    _nameLabel.frame = CGRectMake(x, self.topPadding, width, height);
    _introLabel.frame = CGRectMake(x, size.height / 2, width - _unreadLabel.frame.size.width - 5, height);
    
    _topLineView.frame = CGRectMake(0, -LINE_HEIGHT, size.width, LINE_HEIGHT);
    _bottomLineView.frame = CGRectMake(_nameLabel.frame.origin.x, size.height - LINE_HEIGHT, size.width - _nameLabel.frame.origin.x, LINE_HEIGHT);
}

//左滑按钮
- (NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
    //[rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:[EM_ChatResourcesUtils stringWithName:@"common.delete"]];
    return rightUtilityButtons;
}

@end