//
//  EM+ChatMessageLocationBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageLocationBody.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatMessageUIConfig.h"

@implementation EM_ChatMessageLocationBody{
    UIImageView *mapView;
    UILabel *addressLabel;
}

+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    
    if (CGSizeEqualToSize(message.bodySize , CGSizeZero)) {
        CGSize size;
        
        size = CGSizeMake(150, 150);
        size.height += config.bodyLocationPadding * 2;
        size.width += config.bodyLocationPadding * 2;
        message.bodySize = size;
    }
    return message.bodySize;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        mapView = [[UIImageView alloc]init];
        mapView.image = [EM_ChatResourcesUtils cellImageWithName:@"location_preview"];
        [self addSubview:mapView];
        
        addressLabel = [[UILabel alloc]init];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.numberOfLines = 0;
        [self addSubview:addressLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    mapView.bounds = CGRectMake(0, 0, size.width - self.config.bodyLocationPadding * 2, size.height - self.config.bodyLocationPadding * 2);
    mapView.center = CGPointMake(size.width / 2, size.height / 2);
    addressLabel.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y + (mapView.frame.size.height - 44), mapView.frame.size.width , 44);

}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_LOCATION forKey:kHandleActionName];
    return userInfo;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMLocationMessageBody *locationBody = (EMLocationMessageBody *)message.messageBody;
    addressLabel.text = locationBody.address;
}

@end