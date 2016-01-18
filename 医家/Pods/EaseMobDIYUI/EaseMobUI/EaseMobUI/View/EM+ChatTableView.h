//
//  EM+ChatTableView.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EM_ChatTableViewTapDelegate;

@interface EM_ChatTableView : UITableView

@property (nonatomic,assign) id<EM_ChatTableViewTapDelegate> tapDelegate;

@end

@protocol EM_ChatTableViewTapDelegate <NSObject>

@required

@optional

- (void)chatTableView:(EM_ChatTableView *)table didTapEnded:(NSSet *)touches withEvent:(UIEvent *)event;


@end