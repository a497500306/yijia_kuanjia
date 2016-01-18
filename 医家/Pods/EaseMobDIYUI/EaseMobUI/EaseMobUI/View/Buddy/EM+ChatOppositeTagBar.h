//
//  EM+ChatOppositeTableHeader.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGH_FOR_SEARCH_BAR (IS_PAD ? 60 : 44)
#define TAG_IDENTIFIER (@"tag_identifier")

@interface EM_ChatOppositeTagBar : UIView

@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end