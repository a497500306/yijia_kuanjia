//
//  EM+ChatOppositeTagBar.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatOppositeTagBar.h"
#import "EM+ChatOppositeTag.h"
#import "EM+Common.h"

@interface EM_ChatOppositeTagBar()

@end

@implementation EM_ChatOppositeTagBar

- (instancetype)init{
    self = [super init];
    if (self) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        [self addSubview:_searchBar];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[EM_ChatOppositeTag class] forCellWithReuseIdentifier:TAG_IDENTIFIER];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    if (!_searchBar.hidden) {
        _searchBar.frame = CGRectMake(0, 0, size.width, HEIGH_FOR_SEARCH_BAR);
    }else{
        _searchBar.frame = CGRectZero;
    }
    
    if (!_collectionView.hidden) {
        _collectionView.frame = CGRectMake(0, _searchBar.frame.size.height, size.width, size.height - _searchBar.frame.size.height);
    }else{
        _collectionView.frame = CGRectZero;
    }
    
}

@end