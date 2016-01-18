//
//  EM+MessageEmojiView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatEmojiView.h"
#import "EmojiEmoticons.h"

#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatUIConfig.h"
#import "UIColor+Hex.h"

#import "EM_ChatEmoji.h"
#import "EM+ChatDBUtils.h"

#define HORIZONTAL_COUNT (8)
#define VERTICAL_COUNT  (3)

typedef NS_ENUM(NSInteger, Emoji_Type) {
    Emoji_Lately = -1,
    Emoji_Emoticons = 0
};

@interface EM_ChatEmojiView()<UIScrollViewDelegate>

@end

@implementation EM_ChatEmojiView{
    NSArray *emojiArray;
    NSMutableArray *latelyArray;
    NSMutableArray *tempArray;
    
    UIScrollView *scroll;
    NSMutableArray *indicatorArray;
    
    UIView *lineView;
    UIButton *latelyButton;
    UIButton *emojiButton;
    UIButton *sendButton;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        scroll = [[UIScrollView alloc]init];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        [self addSubview:scroll];
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self addSubview:lineView];
        
        latelyButton = [[UIButton alloc]init];
        latelyButton.backgroundColor = self.backgroundColor;
        [latelyButton setTitle:[EM_ChatResourcesUtils stringWithName:@"common.lately"] forState:UIControlStateNormal];
        [latelyButton setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [latelyButton setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateSelected];
        [latelyButton addTarget:self action:@selector(emojiLatelyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:latelyButton];
        
        emojiButton = [[UIButton alloc]init];
        emojiButton.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        emojiButton.selected = YES;
        [emojiButton setTitle:@"Emoji" forState:UIControlStateNormal];
        [emojiButton setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [emojiButton setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateSelected];
        [emojiButton addTarget:self action:@selector(emojiActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emojiButton];
        
        sendButton = [[UIButton alloc]init];
        sendButton.backgroundColor = [UIColor colorWithHEX:@"#A4D3EE" alpha:1.0];
        sendButton.selected = YES;
        [sendButton setTitle:[EM_ChatResourcesUtils stringWithName:@"common.send"] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateSelected];
        [sendButton addTarget:self action:@selector(emojiSendClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        
        latelyArray = [[NSMutableArray alloc]initWithArray:[[EM_ChatDBUtils shared] queryEmoji]];
        emojiArray = [EmojiEmoticons allEmoticons];
        tempArray = [[NSMutableArray alloc]init];
        
        [self initEmoji:Emoji_Emoticons];
    }
    return self;
}

- (void)dealloc{

}

- (void)initEmoji:(Emoji_Type)type{
    
    NSArray *array;
    switch (type) {
        case Emoji_Emoticons:{
            array = emojiArray;
        }
            break;
        case Emoji_Lately:{
            array = latelyArray;
        }
            break;
    }
    
    for(UIView * view in scroll.subviews){
        [view removeFromSuperview];
    }
    
    NSInteger pageEmojiCount = HORIZONTAL_COUNT * VERTICAL_COUNT - 1;
    for (int i = 0; i < array.count; i++) {
        UIButton *emoji = [[UIButton alloc]init];
        if (type == Emoji_Lately) {
            EM_ChatEmoji *latelyEmoji = array[i];
            [emoji setTitle:latelyEmoji.emoji forState:UIControlStateNormal];
        }else{
            [emoji setTitle:array[i] forState:UIControlStateNormal];
        }
        
        [emoji addTarget:self action:@selector(emojiClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:emoji];
        
        if (i % pageEmojiCount == pageEmojiCount - 1 || i == array.count - 1) {
            UIButton *deleteButton = [[UIButton alloc]init];
            deleteButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:25];
            [deleteButton setTitle:kEMChatIconMoreRepeal forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateHighlighted];
            [deleteButton addTarget:self action:@selector(emojiDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:deleteButton];
        }
    }
    
    NSInteger count = array.count / (HORIZONTAL_COUNT * VERTICAL_COUNT - 1);
    if (array.count % (HORIZONTAL_COUNT * VERTICAL_COUNT - 1) > 0) {
        count += 1;
    }
    
    if (indicatorArray && indicatorArray.count > 0) {
        for (int i = 0; i < indicatorArray.count; i++) {
            UIView *view = indicatorArray[i];
            [view removeFromSuperview];
        }
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
    }else{
        indicatorArray = nil;
    }
    [self setNeedsDisplay];
    
}

- (void)updateLatelyEmojiArray{
    for (NSString *tempEmoji in tempArray) {
        EM_ChatEmoji *emoji = [[EM_ChatDBUtils shared] queryEmoji:tempEmoji];
        if (!emoji){
            emoji = [[EM_ChatDBUtils shared] insertNewEmoji];
            emoji.emoji = tempEmoji;
            [latelyArray insertObject:emoji atIndex:0];
            if (latelyArray.count > 46) {
                EM_ChatEmoji *removeEmoji = [latelyArray lastObject];
                [latelyArray removeObject:removeEmoji];
                [[EM_ChatDBUtils shared] deleteEmoji:removeEmoji];
            }
        }
        
        emoji.calculate = [emoji.calculate decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
        emoji.modify = [NSDate date];
    }
    [tempArray removeAllObjects];
    [[EM_ChatDBUtils shared] saveChat];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    scroll.frame = CGRectMake(0, 0, size.width, (size.width - LEFT_PADDING - RIGHT_PADDING) / HORIZONTAL_COUNT * VERTICAL_COUNT);
    
    CGFloat actionX = 0;
    CGFloat actionY = 0;
    CGFloat actionSize = scroll.frame.size.height / VERTICAL_COUNT;
    NSInteger actionPageIndex = 0;
    
    for (int i = 0; i < scroll.subviews.count; i++) {
        UIView *actionView = scroll.subviews[i];
        actionPageIndex = i / (HORIZONTAL_COUNT * VERTICAL_COUNT);
        if (i == scroll.subviews.count - 1) {
            actionX = scroll.frame.size.width * actionPageIndex + LEFT_PADDING + actionSize * (HORIZONTAL_COUNT - 1);
            actionY = actionSize * (VERTICAL_COUNT - 1);
        }else{
            actionX = scroll.frame.size.width * actionPageIndex + LEFT_PADDING + actionSize * (i % HORIZONTAL_COUNT);
            actionY = actionSize * (((i % (HORIZONTAL_COUNT * VERTICAL_COUNT) ) / HORIZONTAL_COUNT));
        }
        actionView.frame = CGRectMake(actionX, actionY, actionSize, actionSize);
    }
    
    if (indicatorArray && indicatorArray.count > 1) {
        scroll.contentSize = CGSizeMake(scroll.frame.size.width * indicatorArray.count, scroll.frame.size.height);
        
        CGFloat x = (size.width - HEIGHT_INDICATOR_OF_DEFAULT * indicatorArray.count - COMMON_PADDING * (indicatorArray.count - 1)) / 2;
        for (int i = 0; i < indicatorArray.count; i++) {
            UIView *subview = indicatorArray[i];
            subview.frame = CGRectMake(x + (HEIGHT_INDICATOR_OF_DEFAULT + COMMON_PADDING) * i, scroll.frame.size.height + HEIGHT_INDICATOR_OF_DEFAULT / 2, HEIGHT_INDICATOR_OF_DEFAULT, HEIGHT_INDICATOR_OF_DEFAULT);
            subview.layer.cornerRadius = HEIGHT_INDICATOR_OF_DEFAULT / 2;
        }
    }else{
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, scroll.frame.size.height);
    }
    
    CGFloat toolHeight = (size.width - LEFT_PADDING - RIGHT_PADDING) / HORIZONTAL_COUNT;
    lineView.frame = CGRectMake(0, size.height - toolHeight, size.width, 0.5);
    latelyButton.frame = CGRectMake(0, size.height - toolHeight, size.width / 4, toolHeight);
    emojiButton.frame = CGRectMake(size.width / 4, size.height - toolHeight, size.width / 4, toolHeight);
    sendButton.frame = CGRectMake(size.width / 4 * 3, size.height - toolHeight, size.width / 4, toolHeight);
}

- (void)emojiClicked:(UIButton *)sender{
    [tempArray addObject:sender.titleLabel.text];
    if (_delegate) {
        [_delegate didEmojiClicked:sender.titleLabel.text];
    }
}

- (void)emojiDeleteClicked:(UIButton *)sender{
    [tempArray removeObject:sender.titleLabel.text];
    if (_delegate) {
        [_delegate didEmojiDeleteClicked];
    }
}

- (void)emojiLatelyClicked:(UIButton *)sender{
    emojiButton.selected = NO;
    emojiButton.backgroundColor = self.backgroundColor;
    sender.selected = YES;
    sender.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
    [self initEmoji:Emoji_Lately];
}

- (void)emojiActionClicked:(UIButton *)sender{
    latelyButton.selected = NO;
    latelyButton.backgroundColor = self.backgroundColor;
    sender.selected = YES;
    sender.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
    [self initEmoji:Emoji_Emoticons];
}

- (void)emojiSendClicked:(UIButton *)sender{
    [self updateLatelyEmojiArray];
    if (_delegate) {
        [_delegate didEmojiSendClicked];
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
                subview.backgroundColor = [UIColor colorWithHEX:@"#FFF0F5" alpha:1.0];
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