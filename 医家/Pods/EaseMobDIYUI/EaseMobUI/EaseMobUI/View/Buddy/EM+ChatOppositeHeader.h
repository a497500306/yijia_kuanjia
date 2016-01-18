//
//  EM+ChatOppositeHeader.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EM_ChatOppositeHeaderClickedBlock)(NSInteger section);
typedef void (^EM_ChatOppositeHeaderManageBlock)(NSInteger section);

@interface EM_ChatOppositeHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *arrow;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger buddyCount;
@property (nonatomic, assign) BOOL needManage;
@property (nonatomic, assign) CGFloat angle;

- (void)setChatOppositeHeaderClickedBlock:(EM_ChatOppositeHeaderClickedBlock)block;
- (void)setChatOppositeHeaderManageBlock:(EM_ChatOppositeHeaderManageBlock)block;
@end