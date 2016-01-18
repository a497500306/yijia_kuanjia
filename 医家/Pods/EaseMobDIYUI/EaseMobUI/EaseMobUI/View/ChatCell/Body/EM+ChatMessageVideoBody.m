//
//  EM+ChatMessageVideoBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageVideoBody.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatMessageUIConfig.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define CELL_VIDEO_PADDING (1)

@implementation EM_ChatMessageVideoBody{
    UIImageView *imageView;
    UILabel *playLabel;
}

+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    if (CGSizeEqualToSize(message.bodySize , CGSizeZero)) {
        CGSize size;
        
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.messageBody;
        size = videoBody.size;
        size.height += config.bodyVideoPadding * 2;
        size.width += config.bodyVideoPadding * 2;
        
        message.bodySize = size;
    }
    return message.bodySize;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        playLabel = [[UILabel alloc]init];
        playLabel.font = [EM_ChatResourcesUtils iconFontWithSize:30];
        playLabel.backgroundColor = [UIColor clearColor];
        playLabel.text = kEMChatIconCallVideoPlay;
        playLabel.textColor = [UIColor whiteColor];
        playLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:playLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    imageView.frame = CGRectMake(self.config.bodyVideoPadding, self.config.bodyVideoPadding, size.height - self.config.bodyVideoPadding * 2, size.height - self.config.bodyVideoPadding * 2);
    
    CGFloat playSize = (size.width > size.height ? size.height : size.width) - 16;
    playLabel.frame = CGRectMake((size.width - playSize) / 2, (size.height - playSize) / 2, playSize, playSize);
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_VIDEO forKey:kHandleActionName];
    return userInfo;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.messageBody;
    
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:videoBody.thumbnailLocalPath];
    if (image) {
        imageView.image = image;
    }else{
        if (videoBody.thumbnailRemotePath) {
            [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:videoBody.thumbnailRemotePath] placeholderImage:nil options:SDWebImageRetryFailed
             | SDWebImageLowPriority
             | SDWebImageProgressiveDownload
             | SDWebImageRefreshCached
             | SDWebImageHighPriority
             | SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                 
             } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 
             }];
        }
    }
}
@end