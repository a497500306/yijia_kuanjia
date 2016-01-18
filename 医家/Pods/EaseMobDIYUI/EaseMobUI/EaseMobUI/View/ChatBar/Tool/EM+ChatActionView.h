//
//  EM+MessageActionView.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseView.h"
@class EM_ChatUIConfig;

@protocol EM_ChatActionViewDelegate;

@interface EM_ChatActionView : EM_ChatBaseView

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;

@property (nonatomic, weak) id<EM_ChatActionViewDelegate> delegate;

@end

@protocol  EM_ChatActionViewDelegate <NSObject>

@required

- (void)didActionClicked:(NSString *)actionName;

@optional

@end