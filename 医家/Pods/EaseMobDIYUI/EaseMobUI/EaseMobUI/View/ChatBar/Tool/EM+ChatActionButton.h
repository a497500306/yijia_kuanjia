//
//  EM+MessageActionButton.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EM_ChatActionBlcok)(NSString * actionName,UIView * view);

@interface EM_ChatActionButton : UIView

@property (nonatomic, assign, readonly) CGFloat titleHeight;

- (instancetype)initWithConfig:(NSDictionary *)config;

- (void)setEM_ChatActionBlcok:(EM_ChatActionBlcok )block;

@end