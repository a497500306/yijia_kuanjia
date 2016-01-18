//
//  EM+ChatOppositeTag.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/26.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EM_ChatOppositeTag : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger badge;

@property (nonatomic, assign) BOOL tagSelected;

@end