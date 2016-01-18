//
//  EM+ChatWifiView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/10.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatWifiView.h"
#import "EM+ChatResourcesUtils.h"
#import "UIColor+Hex.h"

#define TOP_PADDING (20)

@interface EM_ChatWifiView()

@end

@implementation EM_ChatWifiView{
    UILabel *titleLabel;
    UILabel *hintLabel;
    UILabel *iconLabel;
    UILabel *actionHintLabel;
    UILabel *serveAddressLabel;
    UIButton *closeButton;
}

- (instancetype)initWithIPAdress:(NSString *)ipAdress{
    self = [super init];
    if (self) {
        self.needTap = NO;
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.text = [EM_ChatResourcesUtils stringWithName:@"wifi.server_title"];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        hintLabel = [[UILabel alloc]init];
        hintLabel.text = [EM_ChatResourcesUtils stringWithName:@"wifi.server_warn"];
        hintLabel.textColor = [UIColor blueColor];
        [hintLabel sizeToFit];
        [self addSubview:hintLabel];
        
        iconLabel = [[UILabel alloc]init];
        iconLabel.bounds = CGRectMake(0, 0, 60, 60);
        [self addSubview:iconLabel];
        
        actionHintLabel = [[UILabel alloc]init];
        actionHintLabel.text = [EM_ChatResourcesUtils stringWithName:@"wifi.server_hint"];
        actionHintLabel.textColor = [UIColor blackColor];
        [actionHintLabel sizeToFit];
        [self addSubview:actionHintLabel];
        
        serveAddressLabel = [[UILabel alloc]init];
        serveAddressLabel.textColor = [UIColor blackColor];
        [self addSubview:serveAddressLabel];
        
        closeButton = [[UIButton alloc]init];
        [closeButton setTitle:[EM_ChatResourcesUtils stringWithName:@"common.close"] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton sizeToFit];
        closeButton.backgroundColor = [UIColor redColor];
        closeButton.layer.cornerRadius = 3;
        [self addSubview:closeButton];
        
        serveAddressLabel.text = ipAdress;
        [serveAddressLabel sizeToFit];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    titleLabel.center = CGPointMake(size.width / 2, TOP_PADDING);
    hintLabel.center = CGPointMake(size.width / 2, titleLabel.frame.origin.y + titleLabel.frame.size.height + hintLabel.frame.size.height / 2);
    iconLabel.center = CGPointMake(size.width / 2, titleLabel.frame.origin.y + titleLabel.bounds.size.height + iconLabel.bounds.size.height / 2);
    
    actionHintLabel.center = CGPointMake(size.width / 2, iconLabel.frame.origin.y + iconLabel.frame.size.height + actionHintLabel.frame.size.height / 2);
    serveAddressLabel.center = CGPointMake(size.width / 2, actionHintLabel.frame.origin.y + actionHintLabel.frame.size.height + serveAddressLabel.frame.size.height / 2);
    
    closeButton.bounds = CGRectMake(0, 0, size.width - 30, closeButton.frame.size.height);
    closeButton.center = CGPointMake(size.width / 2, TOP_PADDING + serveAddressLabel.frame.origin.y + serveAddressLabel.frame.size.height + closeButton.frame.size.height / 2);
}

- (CGFloat)contentHeight{
    return TOP_PADDING + titleLabel.frame.size.height + hintLabel.frame.size.height + iconLabel.frame.size.height + actionHintLabel.frame.size.height + serveAddressLabel.frame.size.height +  closeButton.frame.size.height;
}

- (void)completion{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)dismiss{
    [super dismiss];
}

- (void)close:(id)sender{
    [self dismiss];
}

@end