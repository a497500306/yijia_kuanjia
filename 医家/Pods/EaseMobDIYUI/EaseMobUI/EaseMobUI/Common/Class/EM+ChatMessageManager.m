//
//  EM+ChatMessageRead.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/22.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageManager.h"
#import "EM+ChatMessageModel.h"
#import "EM_ChatMessage.h"
#import "EMCDDeviceManager.h"

#import <MWPhotoBrowser/MWPhotoBrowser.h>

static EM_ChatMessageManager *detailInstance = nil;

@interface EM_ChatMessageManager()<MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UINavigationController *photoNavigationController;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) NSTimer *voiceObserver;
@property (nonatomic, strong) NSMutableArray *voiceArray;
@property (nonatomic, assign) NSInteger playIndex;

@end

@implementation EM_ChatMessageManager

+ (instancetype)defaultManager{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }
    
    return detailInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _photoArray = [[NSMutableArray alloc]init];
        _voiceArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (UIWindow *)keyWindow{
    if(!_keyWindow){
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    return _keyWindow;
}

- (UINavigationController *)photoNavigationController{
    if (!_photoNavigationController) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

- (MWPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    return _photoBrowser;
}

- (BOOL)isPlaying{
    return [EMCDDeviceManager sharedInstance].isPlaying;
}

- (void)showBrowserWithImagesMessage:(NSArray *)imageArray index:(NSInteger)index{
    [self.photoArray removeAllObjects];
    for (int i = 0; i < imageArray.count; i++) {
        EM_ChatMessageModel *messageModel = imageArray[i];
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageModel.messageBody;
        
        MWPhoto *photo;
        if (messageModel.sender) {
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:imageBody.localPath]];
        }else{
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageBody.remotePath]];
        }
        photo.caption = imageBody.displayName;
        [self.photoArray addObject:photo];
    }
    [self.photoBrowser setCurrentPhotoIndex:index];
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (void)showBrowserWithVideoMessage:(EM_ChatMessageModel *)videoMessage{
    [self.photoArray removeAllObjects];
    EMVideoMessageBody *videoBody = (EMVideoMessageBody *)videoMessage.messageBody;
    MWPhoto *video;
    if (videoMessage.sender) {
        video = [MWPhoto videoWithURL:[NSURL fileURLWithPath:videoBody.localPath]];
    }else{
        video = [MWPhoto videoWithURL:[NSURL URLWithString:videoBody.remotePath]];
    }
    video.caption = videoBody.displayName;
    [self.photoArray addObject:video];
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (void)playVoice:(NSArray *)voiceArray index:(NSInteger)index{    
    self.playIndex = index;
    [self.voiceArray addObjectsFromArray:voiceArray];
    
    self.voiceObserver =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playNextVoice) userInfo:nil repeats:YES];
}

- (void)playNextVoice{
    EM_ChatMessageModel *per;
    if (self.playIndex > 0 && self.playIndex <= self.voiceArray.count) {
        per = self.voiceArray[self.playIndex - 1];
        per.messageSign.checking = NO;
        per.messageSign.details = YES;
    }
    
    if (!self.isPlaying && self.playIndex < self.voiceArray.count) {
        EM_ChatMessageModel *next = self.voiceArray[self.playIndex];
        next.messageSign.checking = YES;
        next.messageSign.details = YES;
        
        EMVoiceMessageBody *messageBody = (EMVoiceMessageBody *)next.messageBody;
        
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:messageBody.localPath completion:^(NSError *error) {
            self.playIndex ++;
        }];
        
        if (self.voiceArray.count > 0 && self.delegate && [self.delegate respondsToSelector:@selector(didStartPlayWithMessage:previous:)]) {
            [self.delegate didStartPlayWithMessage:next previous:per];
        }
    }else{
        if (self.playIndex >= self.voiceArray.count) {
            if (self.voiceArray.count > 0 && self.delegate && [self.delegate respondsToSelector:@selector(didEndPlayWithMessage:)]) {
                [self.delegate didEndPlayWithMessage:self.voiceArray.lastObject];
            }
            [self stopVoice];
        }
    }
}

- (void)stopVoice{
    if (self.isPlaying) {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
    }
    
    for (EM_ChatMessageModel *model in self.voiceArray) {
        model.messageSign.checking = NO;
    }
    
    [_voiceArray removeAllObjects];
    self.playIndex = 0;
    if (self.voiceObserver) {
        [self.voiceObserver invalidate];
        self.voiceObserver = nil;
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return _photoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    return _photoArray[index];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    
}

- (void)dealloc{
    _photoArray = nil;
}

@end