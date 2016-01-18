//
//  UAlertView.h
//  U-Stylist
//
//  Created by 周玉震 on 15/4/27.
//  Copyright (c) 2015年 觉烁科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^AlertDismissBlcok)();
typedef void (^AlertShowCompletedBlcok)();

typedef NS_ENUM(NSUInteger, UAlertPosition) {
    UAlertPosition_Top = 0,
    UAlertPosition_Bottom,
    UAlertPosition_Middle
};

@interface EM_AlertView : UIView

@property (nonatomic,assign,readonly) UAlertPosition alertPosition;
@property (nonatomic,assign,readonly) CGFloat offestY;
@property (nonatomic,assign) CGFloat coverOffestY;
@property (nonatomic,assign) CGFloat coverHidden;
@property (nonatomic,assign,readonly) BOOL isShow;
@property (nonatomic, assign) BOOL tapDismiss;
@property (nonatomic,assign) CGFloat leftPadding;
@property (nonatomic, assign) BOOL needTap;

- (void)completion;

- (CGFloat)contentHeight;

- (void)show;

- (void)show:(UAlertPosition)position offestY:(CGFloat)offestY;

- (void)dismiss;

- (void)setAlertDismissBlcok:(AlertDismissBlcok)block;

- (void)setAlertShowCompletedBlcok:(AlertShowCompletedBlcok)block;

@end
