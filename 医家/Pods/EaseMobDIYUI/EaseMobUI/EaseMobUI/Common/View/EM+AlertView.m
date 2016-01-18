//
//  UAlertView.m
//  U-Stylist
//
//  Created by 周玉震 on 15/4/27.
//  Copyright (c) 2015年 觉烁科技. All rights reserved.
//

#import "EM+AlertView.h"
#import "UIColor+Hex.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"

#define ALERT_BUTTON_WIDTH (60)
#define ALERT_BUTTON_HEIGHT (44)


@interface EM_AlertView()

@property (nonatomic,strong) UIView *cover;

@end

@implementation EM_AlertView{
    AlertDismissBlcok dismissBlock;
    AlertShowCompletedBlcok showBlcok;
    CGRect startFrame;
    CGRect endFrame;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.needTap = YES;
    }
    return self;
}

- (void)setAlertDismissBlcok:(AlertDismissBlcok)block{
    dismissBlock = block;
}

- (void)setAlertShowCompletedBlcok:(AlertShowCompletedBlcok)block{
    showBlcok = block;
}

- (CGFloat)contentHeight{
    return 0;
}

- (void)completion{
    
}

- (void)show{
    [self show:UAlertPosition_Bottom offestY:0];
}

- (void)show:(UAlertPosition)position offestY:(CGFloat)offestY{
    _isShow = YES;
    _alertPosition = position;
    _offestY = offestY;
    
    CGRect coverFrame = ShareWindow.bounds;
    coverFrame.origin.y = self.coverOffestY;
    _cover = [[UIView alloc] initWithFrame:coverFrame];
    _cover.backgroundColor = [UIColor blackColor];
    _cover.alpha = 0.0;
    _cover.userInteractionEnabled = YES;
    _cover.hidden = self.coverHidden;
    
    if (self.needTap) {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_cover addGestureRecognizer:tapGes];
    }
    
    CGFloat height = self.contentHeight;
    
    startFrame  = CGRectZero;
    endFrame = CGRectZero;
    CGFloat offest = _offestY + self.coverOffestY;
    
    switch (_alertPosition) {
        case UAlertPosition_Top:{
            startFrame = CGRectMake(self.leftPadding, offest, ShareWindow.frame.size.width - self.leftPadding * 2, 0);
            endFrame = CGRectMake(self.leftPadding, offest, ShareWindow.frame.size.width - self.leftPadding * 2, height);
        }
            break;
        case UAlertPosition_Bottom:{
            startFrame = CGRectMake(self.leftPadding, ShareWindow.frame.size.height + offest, ShareWindow.frame.size.width - self.leftPadding * 2, 0);
            endFrame = CGRectMake(self.leftPadding, ShareWindow.frame.size.height - height + offest, ShareWindow.frame.size.width - self.leftPadding * 2, height);
        }
            break;
        default:{
            startFrame = CGRectMake(self.leftPadding, ShareWindow.center.y - height / 2, ShareWindow.frame.size.width - self.leftPadding * 2, height);
            endFrame = startFrame;
        }
            break;
    }
    
    [ShareWindow addSubview:_cover];
    
    self.frame = startFrame;
    [ShareWindow addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cover.alpha = 0.3;
        self.alpha = 1.0;
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        if (showBlcok) {
            showBlcok();
        }
        [self completion];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = startFrame;
        _cover.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_cover removeFromSuperview];
    }];
    [self endEditing:YES];
    if (dismissBlock) {
        dismissBlock();
    }
    _isShow = NO;
}

@end