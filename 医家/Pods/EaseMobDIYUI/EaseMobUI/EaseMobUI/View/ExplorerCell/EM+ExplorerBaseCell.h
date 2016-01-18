//
//  EM+ExplorerBaseCell.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EM_ExplorerBaseCell : UITableViewCell

@property (nonatomic, assign) BOOL selectedItem;
@property (nonatomic, assign, readonly) BOOL upload;
@property (nonatomic, strong) NSDictionary *fileInfo;

@end