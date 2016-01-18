//
//  EM+ChatOppositeCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatOppositeCell.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation EM_ChatOppositeCell{
    UIView *_topLineView;
    UIView *_bottomLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.layer.masksToBounds = YES;
        
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_topLineView];
        
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.imageView.frame = CGRectMake(LEFT_PADDING, TOP_PADDING, size.height - TOP_PADDING * 2, size.height - TOP_PADDING * 2);
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + COMMON_PADDING;
    self.textLabel.frame = textFrame;
    
    CGRect detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + COMMON_PADDING;
    self.detailTextLabel.frame = detailFrame;
    
    _topLineView.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width, 0, size.width, LINE_HEIGHT);
    
    _bottomLineView.frame = CGRectMake(self.imageView.frame.origin.x, size.height - LINE_HEIGHT, size.width, LINE_HEIGHT);
}

- (void)setName:(NSString *)name{
    _name = name;
    self.textLabel.text = _name;
}

- (void)setDetails:(NSString *)details{
    _details = details;
    self.detailTextLabel.text = _details;
}

- (void)setAvatarImage:(UIImage *)avatarImage{
    _avatarImage = avatarImage;
    if (!self.avatarURL) {
        self.imageView.image = _avatarImage;
    }
}

- (void)setAvatarURL:(NSURL *)avatarURL{
    _avatarURL = avatarURL;
    [self.imageView sd_setImageWithURL:_avatarURL placeholderImage:_avatarImage completed:nil];
}

- (void)setHiddenTopLine:(BOOL)hiddenTopLine{
    _hiddenTopLine = hiddenTopLine;
    _topLineView.hidden = _hiddenTopLine;
}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine{
    _hiddenBottomLine = hiddenBottomLine;
    _bottomLineView.hidden = _hiddenBottomLine;
}

@end