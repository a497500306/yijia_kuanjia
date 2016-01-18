//
//  EM+MessageActionView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatActionView.h"
#import "EM+ChatActionButton.h"
#import "EM+Common.h"
#import "EM+ChatUIConfig.h"

#define HORIZONTAL_COUNT (4)
#define VERTICAL_COUNT  (2)

@interface EM_ChatActionView()<UIScrollViewDelegate>

@property (nonatomic,strong) EM_ChatUIConfig *config;

@end

@implementation EM_ChatActionView{
    UIScrollView *scroll;
    NSMutableArray *indicatorArray;
}

-(instancetype)initWithConfig:(EM_ChatUIConfig *)config{
    self = [super init];
    if (self) {
        _config = config;
        
        scroll = [[UIScrollView alloc]init];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        [self addSubview:scroll];
        
        __weak EM_ChatActionView *actionView = self;
        for (int i = 0; i < _config.keyArray.count; i++) {
            NSString *key = _config.keyArray[i];
            NSDictionary *actionAttribute = _config.actionDictionary[key];
            EM_ChatActionButton * actionButton = [[EM_ChatActionButton alloc]initWithConfig:actionAttribute];
            [actionButton setEM_ChatActionBlcok:^(NSString *actionName, UIView *view) {
                if (actionView.delegate) {
                    [actionView.delegate didActionClicked:key];
                }
            }];
            [scroll addSubview:actionButton];
        }
        
        NSInteger count = _config.actionDictionary.count / (HORIZONTAL_COUNT * VERTICAL_COUNT);
        if (_config.actionDictionary.count % (HORIZONTAL_COUNT * VERTICAL_COUNT) > 0) {
            count += 1;
        }
        if (count > 1) {
            indicatorArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < count; i++) {
                UIButton *indicatorItem = [[UIButton alloc]init];
                indicatorItem.tag = i;
                [indicatorItem addTarget:self action:@selector(indicatorClicked:) forControlEvents:UIControlEventTouchUpInside];
                if (i == 0) {
                    indicatorItem.backgroundColor = [UIColor grayColor];
                }else{
                    indicatorItem.backgroundColor = [UIColor whiteColor];
                }
                
                [indicatorArray addObject:indicatorItem];
                [self addSubview:indicatorItem];
            }
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    scroll.frame = CGRectMake(LEFT_PADDING, 0, size.width - LEFT_PADDING - RIGHT_PADDING, (size.width - LEFT_PADDING - RIGHT_PADDING) / HORIZONTAL_COUNT * VERTICAL_COUNT);
    CGFloat offest = scroll.frame.size.height / VERTICAL_COUNT;
    CGFloat actionSize = scroll.frame.size.height / 2 - 5;
    NSInteger actionPageIndex = 0;
    CGFloat centerX;
    CGFloat centerY;

    for (int i = 0; i < scroll.subviews.count; i++) {
        UIView *actionView = scroll.subviews[i];

        actionPageIndex = i / (HORIZONTAL_COUNT * VERTICAL_COUNT);
        centerX = scroll.frame.size.width * actionPageIndex + offest / 2 + offest * (i % HORIZONTAL_COUNT);
        centerY = offest / 2 + offest * (((i % (HORIZONTAL_COUNT * VERTICAL_COUNT) ) / HORIZONTAL_COUNT));
        
        actionView.bounds = CGRectMake(0, 0, actionSize, actionSize);
        actionView.center = CGPointMake(centerX, centerY);
    }
    
    if (indicatorArray && indicatorArray.count > 1) {
        scroll.contentSize = CGSizeMake(scroll.frame.size.width * indicatorArray.count, scroll.frame.size.height);
        
        CGFloat x = (size.width - HEIGHT_INDICATOR_OF_DEFAULT * indicatorArray.count - COMMON_PADDING * (indicatorArray.count - 1)) / 2;
        for (int i = 0; i < indicatorArray.count; i++) {
            UIView *subview = indicatorArray[i];
            subview.frame = CGRectMake(x + (HEIGHT_INDICATOR_OF_DEFAULT + COMMON_PADDING) * i, scroll.frame.size.height + HEIGHT_INDICATOR_OF_DEFAULT / 2, HEIGHT_INDICATOR_OF_DEFAULT, HEIGHT_INDICATOR_OF_DEFAULT);
            subview.layer.cornerRadius = HEIGHT_INDICATOR_OF_DEFAULT / 2;
        }
    }
}

- (void)indicatorClicked:(UIButton *)sender{
    NSInteger pageIndex = sender.tag;
    if (pageIndex >= 0 && pageIndex < indicatorArray.count) {
        CGPoint offset = CGPointMake(scroll.frame.size.width * pageIndex, 0);
        [scroll setContentOffset:offset animated:YES];
        for (int i = 0; i < indicatorArray.count; i++) {
            UIView *subview = indicatorArray[i];
            if (i == pageIndex) {
                subview.backgroundColor = [UIColor grayColor];
            }else{
                subview.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    NSInteger pageIndex = offset.x / scrollView.frame.size.width;
    if (pageIndex >= 0 && pageIndex < indicatorArray.count) {
        for (int i = 0; i < indicatorArray.count; i++) {
            UIView *subview = indicatorArray[i];
            if (i == pageIndex) {
                subview.backgroundColor = [UIColor grayColor];
            }else{
                subview.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

@end