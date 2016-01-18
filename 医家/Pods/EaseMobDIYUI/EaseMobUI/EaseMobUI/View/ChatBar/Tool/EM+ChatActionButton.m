//
//  EM+MessageActionButton.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatActionButton.h"

#import "EM+ChatUIConfig.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

@interface EM_ChatActionButton()

@property (nonatomic,strong) UIButton *actionButton;
@property (nonatomic,strong) UILabel *actionLabel;
@property (nonatomic,strong) NSDictionary *actionAttribute;
@property (nonatomic,copy) NSString *actionName;

@end

@implementation EM_ChatActionButton{
    EM_ChatActionBlcok _block;
}

- (instancetype)initWithConfig:(NSDictionary *)config{
    self = [super init];
    if (self) {
        _actionAttribute = config;
        
        _actionName = _actionAttribute[kAttributeName];
        
        _actionButton = [[UIButton alloc]init];
        [_actionButton addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIFont *font = _actionAttribute[kAttributeFont];
        
        if (font) {
            _actionButton.titleLabel.font = font;
            
            NSString *text = _actionAttribute[kAttributeText];
            [_actionButton setTitle:text forState:UIControlStateNormal];
            
            UIColor *normalColor = _actionAttribute[kAttributeNormalColor];
            if (normalColor) {
                [_actionButton setTitleColor:normalColor forState:UIControlStateNormal];
            }else{
                [_actionButton setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
            }
            
            UIColor *highlightColor = _actionAttribute[kAttributeHighlightColor];
            if (highlightColor) {
                [_actionButton setTitleColor:highlightColor forState:UIControlStateHighlighted];
            }else{
                [_actionButton setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateHighlighted];
            }
        }else{
            UIImage *normalImage = _actionAttribute[kAttributeNormalImage];
            if (normalImage) {
                [_actionButton setImage:normalImage forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = _actionAttribute[kAttributeHighlightImage];
            if (highlightImage){
                [_actionButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
        
        UIColor *backgroundColor = _actionAttribute[kAttributeBackgroundColor];
        if (backgroundColor) {
            _actionButton.backgroundColor = backgroundColor;
        }
        
        UIColor *borderColor = _actionAttribute[kAttributeBorderColor];
        if (borderColor) {
            _actionButton.layer.borderColor = borderColor.CGColor;
        }
        
        id borderWidth = _actionAttribute[kAttributeBorderWidth];
        if (borderWidth) {
            _actionButton.layer.borderWidth = [borderWidth floatValue];
        }
        
        id cornerRadius = _actionAttribute[kAttributeCornerRadius];
        if (cornerRadius) {
            _actionButton.layer.cornerRadius = [cornerRadius floatValue];
        }
        _actionButton.contentEdgeInsets = UIEdgeInsetsMake( 2, 2, 2, 2);
        [self addSubview:_actionButton];
        
        _actionLabel = [[UILabel alloc]init];
        _actionLabel.textColor = [UIColor blackColor];
        _actionLabel.font = [UIFont systemFontOfSize:RES_FONT_DEFAUT];
        _actionLabel.textAlignment = NSTextAlignmentCenter;
        NSString *title = _actionAttribute[kAttributeTitle];
        if (title && title.length > 0 ) {
            _actionLabel.text = title;
        }else{
            _actionLabel.hidden = YES;
        }
        
        [self addSubview:_actionLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    
    if (_actionLabel.hidden) {
        _actionButton.frame = CGRectMake(COMMON_PADDING * 2, COMMON_PADDING * 2, size.width - COMMON_PADDING * 4, size.height - COMMON_PADDING * 4);
    }else{
        CGSize titleSize = [_actionLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_actionLabel.font,NSFontAttributeName, nil]];
        
        _actionLabel.frame = CGRectMake((size.width - titleSize.width) / 2, size.height - COMMON_PADDING - titleSize.height, titleSize.width, titleSize.height);
        
        CGFloat actionSize = size.height - titleSize.height - COMMON_PADDING * 3;
        
        _actionButton.frame = CGRectMake((size.width - actionSize) / 2, COMMON_PADDING, actionSize, actionSize);
    }
}

- (CGFloat)titleHeight{
    if (_actionLabel.hidden) {
        return 0;
    }else{
        return _actionLabel.frame.size.height;
    }
}

- (void)setEM_ChatActionBlcok:(EM_ChatActionBlcok )block{
    _block = block;
}

- (void)actionClick:(id)sender{
    if (_block) {
        _block(_actionName,self);
    }
}

@end