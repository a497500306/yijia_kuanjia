//
//  EM+LocationController.h
//  EaseMobUI 定位界面
//
//  Created by 周玉震 on 15/7/20.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"

@protocol EM_LocationControllerDelegate <NSObject>

-(void)sendLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address;

@end

@interface EM_LocationController : EM_ChatBaseController

@property (nonatomic, assign) id<EM_LocationControllerDelegate> delegate;

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

@end