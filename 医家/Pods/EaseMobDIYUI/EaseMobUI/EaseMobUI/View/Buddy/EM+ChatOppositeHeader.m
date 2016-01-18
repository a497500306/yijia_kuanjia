//
//  EM+ChatOppositeHeader.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatOppositeHeader.h"
#import "UIColor+Hex.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"

@implementation EM_ChatOppositeHeader{
    UIView *_topLineView;
    UILabel *_arrowLabel;
    UILabel *_titleLabel;
    UILabel *_buddyCountLabel;
    
    EM_ChatOppositeHeaderClickedBlock _clickedBlock;
    EM_ChatOppositeHeaderManageBlock _manageBlock;
    
    UIMenuController *manageController;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        _arrowLabel = [[UILabel alloc]init];
        _arrowLabel.font = [EM_ChatResourcesUtils iconFontWithSize:16];
        _arrowLabel.textColor = [UIColor blackColor];
        _arrowLabel.text = KEMChatIconMorePlay;
        [self.contentView addSubview:_arrowLabel];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_topLineView];
        
        _buddyCountLabel = [[UILabel alloc]init];
        _buddyCountLabel.text = @"0";
        _buddyCountLabel.textColor = [UIColor colorWithHexRGB:TEXT_NORMAL_COLOR];
        _buddyCountLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_buddyCountLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [tap requireGestureRecognizerToFail:longPress];
        [self addGestureRecognizer:tap];
        
        UIMenuItem *groupManage = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.group_manage"] action:@selector(groupManage:)];
        manageController = [UIMenuController sharedMenuController];
        [manageController setMenuItems:@[groupManage]];
        self.needManage = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    [_arrowLabel sizeToFit];
    _arrowLabel.center = CGPointMake(LEFT_PADDING + _arrowLabel.frame.size.width / 2, size.height / 2);
    
    _titleLabel.frame = CGRectMake(LEFT_PADDING * 2 + _arrowLabel.frame.size.width, 0, size.width, size.height);
    [_buddyCountLabel sizeToFit];
    _buddyCountLabel.center = CGPointMake(size.width - RIGHT_PADDING - _buddyCountLabel.frame.size.width / 2, size.height / 2);
    
    _topLineView.frame = CGRectMake(0, 0, size.width, LINE_HEIGHT);
}

- (void)setChatOppositeHeaderClickedBlock:(EM_ChatOppositeHeaderClickedBlock)block{
    _clickedBlock = block;
}

- (void)setChatOppositeHeaderManageBlock:(EM_ChatOppositeHeaderManageBlock)block{
    _manageBlock = block;
}

- (void)setArrow:(NSString *)arrow{
    _arrow = arrow;
    _arrowLabel.text = _arrow;
}

- (void)setAngle:(CGFloat)angle{
    _angle = angle;
    _arrowLabel.transform = CGAffineTransformMakeRotation(angle);
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}

- (void)setBuddyCount:(NSInteger)buddyCount{
    _buddyCount = buddyCount;
    _buddyCountLabel.text = [NSString stringWithFormat:@"%ld",_buddyCount];
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if (_clickedBlock && !manageController.menuVisible) {
        _clickedBlock(self.section);
    }
    if (manageController.menuVisible) {
        [manageController setMenuVisible:NO animated:YES];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (!self.needManage) {
        return;
    }
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self becomeFirstResponder];
    
    [manageController setTargetRect:self.frame inView:self.superview];
    [manageController setMenuVisible:YES animated:YES];
}

- (void)groupManage:(id)sender{
    if (_manageBlock) {
        _manageBlock(self.section);
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return action == @selector(groupManage:);
}

@end