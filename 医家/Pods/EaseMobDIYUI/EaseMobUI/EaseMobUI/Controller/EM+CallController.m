//
//  EM+CallController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+CallController.h"
#import "EaseMobUIClient.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendCall.h"
#import "UIViewController+HUD.h"
#import "GPUImageVideoCamera.h"
#import "GPUImageView.h"
#import "GPUImageRawDataOutput.h"

#import "UIColor+Hex.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <EaseMobSDKFull/EaseMob.h>
#import <FXBlurView/FXBlurView.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <AVFoundation/AVFoundation.h>
#import <pop/POP.h>

#define TimeInterval (1)

@interface EM_CallController ()<GPUImageVideoCameraDelegate,EMCallManagerDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *contentLabel;//昵称,时间,状态,原因

@property (nonatomic, strong) UIButton *interruptButton;//挂断
@property (nonatomic, strong) UILabel *interruptLabel;

@property (nonatomic, strong) UIButton *rejectButton;//拒绝
@property (nonatomic, strong) UILabel *rejectLabel;

@property (nonatomic, strong) UIButton *agreeButton;//同意
@property (nonatomic, strong) UILabel *agreeLabel;

@property (nonatomic, strong) UIButton *silenceButton;//静音
@property (nonatomic, strong) UILabel *silenceLabel;

@property (nonatomic, strong) UIButton *expandButton;//免提
@property (nonatomic, strong) UILabel *expandLabel;

@property (nonatomic, strong) UIButton *rotateCameraButton;

@property (nonatomic, strong) OpenGLView20 *oppositeView;//对方的画面

@property (nonatomic, strong) GPUImageView *hereView;//自己的画面
@property (nonatomic, strong) GPUImageVideoCamera *camera;


@property (nonatomic, strong) EM_ChatBuddy *buddy;

@end

@implementation EM_CallController{
    NSTimer *_timer;
    int _duration;
    BOOL _interrupt;
    BOOL _reject;
    BOOL _agree;
    BOOL _hangup;
    BOOL _exchange;
    EMCallStatusChangedReason _reason;
    AVAudioPlayer *_ringPlayer;
    UInt8 *_imageDataBuffer;
    
    BOOL hiddenControl;
    CGPoint startPoint;
}

- (instancetype)initWithSession:(EMCallSession *)session type:(NSInteger)type action:(EMChatCallAction)action{
    self = [super init];
    if (self) {
        _callSession = session;
        _callType = type;
        _callAction = action;
        
        id<EM_ChatOppositeDelegate> userDelegate = [EaseMobUIClient sharedInstance].oppositeDelegate;
        if (userDelegate && [userDelegate respondsToSelector:@selector(buddyInfoWithChatter:)]) {
            _buddy = [userDelegate buddyInfoWithChatter:_callSession.sessionChatter];
        }else{
            _buddy = [[EM_ChatBuddy alloc]init];
            _buddy.uid = _callSession.sessionChatter;
            _buddy.displayName = _callSession.sessionChatter;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallShow object:nil userInfo:@{kEMCallChatter:self.callSession.sessionChatter,kEMCallType:@(self.callType)}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundView];
    
    [FXBlurView setBlurEnabled:YES];
    CALayer *layer = [CALayer layer];
    layer.frame = self.view.frame;
    layer.backgroundColor = [UIColor colorWithHexRGB:0x000000 Alpha:0.5].CGColor;
    
    _blurView = [[FXBlurView alloc]init];
    _blurView.frame = self.view.frame;
    [_blurView.layer addSublayer:layer];
    [self.view addSubview:_blurView];
    
    if (self.callType == eCallSessionTypeVideo) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        //对方画面
        _oppositeView = [[OpenGLView20 alloc] initWithFrame:self.view.frame];
        _oppositeView.layer.masksToBounds = YES;
        [self.view addSubview:_oppositeView];
        _callSession.displayView = _oppositeView;
        
        //自己的画面
        _hereView = [[GPUImageView alloc] initWithFrame:self.view.frame];
        _hereView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [self.view addSubview:_hereView];
        
        _camera = [[GPUImageVideoCamera alloc]initWithSessionPreset:_oppositeView.sessionPreset cameraPosition:AVCaptureDevicePositionFront];
        _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _camera.horizontallyMirrorFrontFacingCamera = YES;
        _camera.horizontallyMirrorRearFacingCamera = YES;
        _camera.delegate = self;
        [_camera addTarget:_hereView];
        [_camera startCameraCapture];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [pan requireGestureRecognizerToFail:tap];
        [self.hereView addGestureRecognizer:pan];
        
        _rotateCameraButton = [[UIButton alloc]init];
        _rotateCameraButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:20];
        [_rotateCameraButton setTitle:kEMChatIconCallReset forState:UIControlStateNormal];
        [_rotateCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotateCameraButton sizeToFit];
        _rotateCameraButton.center = CGPointMake(self.view.frame.size.width - _rotateCameraButton.frame.size.width / 2 - 15, 50);
        [_rotateCameraButton addTarget:self action:@selector(rotateCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rotateCameraButton];
    }
    
    
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.bounds = CGRectMake(0, 0, 120, 120);
    _avatarImageView.center = CGPointMake(self.view.frame.size.width / 2, 200);
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2;
    _avatarImageView.image = [EM_ChatResourcesUtils defaultAvatarImage];
    [self.view addSubview:_avatarImageView];
    if (_buddy.avatar) {
        [_avatarImageView sd_setImageWithURL:_buddy.avatar];
    }
    _backgroundView.image = _avatarImageView.image;
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width, 150);
    _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
    [self.view addSubview:_contentLabel];
    
    _interruptButton = [[UIButton alloc]init];
    _interruptButton.backgroundColor = [UIColor colorWithHexRGB:0xff3b30];
    _interruptButton.bounds = CGRectMake(0, 0, 60, 60);
    _interruptButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 100);
    _interruptButton.layer.masksToBounds = YES;
    _interruptButton.layer.cornerRadius = _interruptButton.frame.size.width / 2;
    _interruptButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:26];
    [_interruptButton setTitle:kEMChatIconCallHangup forState:UIControlStateNormal];
    [_interruptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_interruptButton addTarget:self action:@selector(interruptCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_interruptButton];
    
    _interruptLabel = [[UILabel alloc]init];
    _interruptLabel.textColor = [UIColor whiteColor];
    _interruptLabel.text = [EM_ChatResourcesUtils stringWithName:@"call.title_interrupt"];
    [_interruptLabel sizeToFit];
    _interruptLabel.center = CGPointMake(_interruptButton.center.x, _interruptButton.center.y + _interruptButton.frame.size.height);
    [self.view addSubview:_interruptLabel];
    
    _rejectButton = [[UIButton alloc]init];
    _rejectButton.backgroundColor = [UIColor colorWithHexRGB:0xff3b30];
    _rejectButton.bounds = CGRectMake(0, 0, 60, 60);
    _rejectButton.center = CGPointMake(_interruptButton.center.x - _interruptButton.frame.size.width - _rejectButton.frame.size.width / 2, _interruptButton.center.y);
    _rejectButton.layer.masksToBounds = YES;
    _rejectButton.layer.cornerRadius = _rejectButton.frame.size.width / 2;
    _rejectButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:26];
    [_rejectButton setTitle:kEMChatIconCallHangup forState:UIControlStateNormal];
    [_rejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rejectButton addTarget:self action:@selector(rejectCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rejectButton];
    
    _rejectLabel = [[UILabel alloc]init];
    _rejectLabel.textColor = [UIColor whiteColor];
    _rejectLabel.text = [EM_ChatResourcesUtils stringWithName:@"call.title_reject"];
    [_rejectLabel sizeToFit];
    _rejectLabel.center = CGPointMake(_rejectButton.center.x, _rejectButton.center.y + _rejectButton.frame.size.height);
    [self.view addSubview:_rejectLabel];
    
    _agreeButton = [[UIButton alloc]init];
    _agreeButton.backgroundColor = [UIColor colorWithHexRGB:0x08F048];
    _agreeButton.bounds = CGRectMake(0, 0, 60, 60);
    _agreeButton.center = CGPointMake(_interruptButton.center.x + _interruptButton.frame.size.width + _agreeButton.frame.size.width / 2, _interruptButton.center.y);
    _agreeButton.layer.masksToBounds = YES;
    _agreeButton.layer.cornerRadius = _agreeButton.frame.size.width / 2;
    _agreeButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:26];
    [_agreeButton setTitle:kEMChatIconCallConnect forState:UIControlStateNormal];
    [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agreeButton addTarget:self action:@selector(agreeCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeButton];
    
    _agreeLabel = [[UILabel alloc]init];
    _agreeLabel.textColor = [UIColor whiteColor];
    _agreeLabel.text = [EM_ChatResourcesUtils stringWithName:@"call.title_agree"];
    [_agreeLabel sizeToFit];
    _agreeLabel.center = CGPointMake(_agreeButton.center.x, _agreeButton.center.y + _agreeButton.frame.size.height);
    [self.view addSubview:_agreeLabel];
    
    _silenceButton = [[UIButton alloc]init];
    _silenceButton.bounds = CGRectMake(0, 0, 60, 60);
    _silenceButton.center = CGPointMake(self.view.frame.size.width - COMMON_PADDING - _silenceButton.frame.size.width / 2, _agreeButton.center.y);
    _silenceButton.layer.masksToBounds = YES;
    _silenceButton.layer.cornerRadius = _silenceButton.bounds.size.width / 2;
    _silenceButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _silenceButton.layer.borderWidth = LINE_WIDTH * 2;
    _silenceButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:26];
    [_silenceButton setTitle:kEMChatIconCallSilence forState:UIControlStateNormal];
    [_silenceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_silenceButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_silenceButton];
    
    _silenceLabel = [[UILabel alloc]init];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.text = [EM_ChatResourcesUtils stringWithName:@"call.title_silence"];
    [_silenceLabel sizeToFit];
    _silenceLabel.center = CGPointMake(_silenceButton.center.x, _silenceButton.center.y + _silenceButton.frame.size.height);
    [self.view addSubview:_silenceLabel];
    
    _expandButton = [[UIButton alloc]init];
    _expandButton.bounds = CGRectMake(0, 0, 60, 60);
    _expandButton.center = CGPointMake(COMMON_PADDING + _expandButton.frame.size.width / 2, _agreeButton.center.y);
    _expandButton.layer.masksToBounds = YES;
    _expandButton.layer.cornerRadius = _expandButton.bounds.size.width / 2;
    _expandButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _expandButton.layer.borderWidth = LINE_WIDTH * 2;
    _expandButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:26];
    [_expandButton setTitle:kEMChatIconCallExpand forState:UIControlStateNormal];
    [_expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_expandButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_expandButton addTarget:self action:@selector(expandCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_expandButton];
    
    _expandLabel = [[UILabel alloc]init];
    _expandLabel.textColor = [UIColor whiteColor];
    _expandLabel.text = [EM_ChatResourcesUtils stringWithName:@"call.title_expand"];
    [_expandLabel sizeToFit];
    _expandLabel.center = CGPointMake(_expandButton.center.x, _expandButton.center.y + _expandButton.frame.size.height);
    [self.view addSubview:_expandLabel];
    
    [self setCallState:EMChatCallStateWait];
    
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    [[CTCallCenter alloc] init].callEventHandler = ^(CTCall* call){
        if([call.callState isEqualToString:CTCallStateIncoming]){
            //来电话了
            _hangup = YES;
            _interrupt = YES;
            [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Hangup];
        }
    };
}

- (void)dealloc{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self timerInvalidate];
    if (_ringPlayer) {
        [_ringPlayer stop];
    }
    _ringPlayer = nil;
    if (_camera) {
        [_camera stopCameraCapture];
    }
    _camera = nil;
    
    _oppositeView = nil;
    _hereView = nil;
    
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallDismiss object:nil userInfo:@{kEMCallChatter:self.callSession.sessionChatter,kEMCallType:@(self.callType)}];
}

#pragma mark - private
- (void)rotateCamera:(id)sender{
    if (self.camera) {
        [self.camera rotateCamera];
    }
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.hereView];
    if (CGRectContainsPoint(self.hereView.bounds, point)) {
        //切换画面
//        [self.view exchangeSubviewAtIndex:[self.view.subviews indexOfObject:self.oppositeView] withSubviewAtIndex:[self.view.subviews indexOfObject:self.hereView]];
//        if (_exchange) {
//            self.hereView.frame = self.oppositeView.frame;
//            self.oppositeView.frame = self.view.frame;
//        }else{
//            [self.oppositeView bringSubviewToFront:self.hereView];
//            self.oppositeView.frame = self.hereView.frame;
//            self.hereView.frame = self.view.frame;
//        }
//        _exchange = !_exchange;
    }else{
        if (self.callType == eCallSessionTypeVideo && self.callState == EMChatCallStateIn) {
            [self setViewHeidden:!hiddenControl];
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.hereView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.callType == eCallSessionTypeVideo && self.callState == EMChatCallStateIn) {
            [self setViewHeidden:YES];
        }
        startPoint = point;
    }else{
        float dx = point.x - startPoint.x;
        float dy = point.y - startPoint.y;
        
        CGPoint newCenter = CGPointMake(self.hereView.center.x + dx, self.hereView.center.y + dy);
        
        float halfx = CGRectGetMidX(self.hereView.bounds);
        float halfy = CGRectGetMidY(self.hereView.bounds);
        
        newCenter.x = MAX(halfx, newCenter.x);
        newCenter.x = MIN(self.view.bounds.size.width - halfx, newCenter.x);
        
        newCenter.y = MAX(halfy,newCenter.y);
        newCenter.y = MIN(self.view.bounds.size.height - halfy, newCenter.y);
        
        self.hereView.center = newCenter;
    }
}

- (void)setViewHeidden:(BOOL)hidden{
    _avatarImageView.hidden = hidden;
    _interruptButton.hidden = hidden;
    _interruptLabel.hidden = hidden;
    
    _silenceButton.hidden = hidden;
    _silenceLabel.hidden = hidden;
    
    _expandButton.hidden = hidden;
    _expandLabel.hidden = hidden;
    
    _contentLabel.hidden = hidden;
    _rotateCameraButton.hidden = hidden;
    hiddenControl = hidden;
}

- (void)setCallState:(EMChatCallState)callState{
    switch (callState) {
        case EMChatCallStateWait:{
            if (self.callAction == EMChatCallActionIn) {
                _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.in"],_buddy.displayName];
                _interruptButton.hidden = YES;
                _interruptLabel.hidden = YES;
                
                _rejectButton.hidden = NO;
                _rejectLabel.hidden = NO;
                
                _agreeButton.hidden = NO;
                _agreeLabel.hidden = NO;
                NSError *error;
                NSString *ringPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3" inDirectory:@"EM_Resource.bundle/media"];
                _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:ringPath] error:&error];
                if (_ringPlayer && !error) {
                    _ringPlayer.volume = 0.8;
                    _ringPlayer.numberOfLoops = -1;
                    if([_ringPlayer prepareToPlay]){
                        [_ringPlayer play];
                    }
                }
            }else{
                _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.out"],_buddy.displayName];
                _interruptButton.hidden = NO;
                _interruptLabel.hidden = NO;
                
                _rejectButton.hidden = YES;
                _rejectLabel.hidden = YES;
                
                _agreeButton.hidden = YES;
                _agreeLabel.hidden = YES;
            }
            [_contentLabel sizeToFit];
            _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
            _silenceButton.hidden = YES;
            _silenceLabel.hidden = YES;
            
            _expandButton.hidden = YES;
            _expandLabel.hidden = YES;
        }
            break;
        case EMChatCallStateIn:{
            if (_callState == EMChatCallStateWait) {
                _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.ongoing"],_buddy.displayName,[self stringWithTime]];
                [_contentLabel sizeToFit];
                _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
                _interruptButton.hidden = NO;
                _interruptLabel.hidden = NO;
                
                _rejectButton.hidden = YES;
                _rejectLabel.hidden = YES;
                
                _agreeButton.hidden = YES;
                _agreeLabel.hidden = YES;
                
                _silenceButton.hidden = NO;
                _silenceLabel.hidden = NO;
                
                _expandButton.hidden = NO;
                _expandLabel.hidden = NO;
                
                if (_ringPlayer) {
                    [_ringPlayer stop];
                }
                _ringPlayer = nil;
                
                if (self.hereView) {
                    CGRect frame = self.hereView.frame;
                    frame.origin.x = self.view.frame.size.width / 3 * 2;
                    frame.origin.y = self.view.frame.size.height / 3 * 2;
                    frame.size.width = self.view.frame.size.width / 3;
                    frame.size.height = self.view.frame.size.height / 3;
                    

                    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    anim.toValue = [NSValue valueWithCGRect:frame];
                    anim.duration = 2;
                    [_hereView pop_addAnimation:anim forKey:@"anim"];

                    [self setViewHeidden:YES];
                }
            }
        }
            break;
        case EMChatCallStatePause:{
            
        }
            break;
        case EMChatCallStateEnd:{
            NSString *content;
            NSString *hintMessage;
            //接入
            if (_callAction == EMChatCallActionIn) {
                if (_callState == EMChatCallStateWait) {
                    if (_reject) {
                        //等待中拒绝
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.interrupt"],_buddy.displayName];
                        hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.reject"];
                    }else{
                        if (_reason == eCallReason_NoResponse) {
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.no_answer"],_buddy.displayName];
                            hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.no_response"];
                        }else{
                            //等待中对方挂断
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.hangup"],_buddy.displayName];
                            hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.opposite_cancel"];
                        }
                    }
                }else{
                    if (_interrupt) {
                        //通话中挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }else{
                        //通话中对方挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }
                    hintMessage = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.message.hint.end"],[self stringWithTime]];
                }
                
            }else{
                if (_callState == EMChatCallStateWait) {
                    if (_interrupt) {
                        //等待中挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.interrupt"],_buddy.displayName];
                        hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.own_cancel"];
                    }else{
                        if (_reason == eCallReason_Offline) {
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.offline"],_buddy.displayName];
                        }else if(_reason == eCallReason_NoResponse || _reason == eCallReason_Null){
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.no_response"],_buddy.displayName];
                        }else if(_reason == eCallReason_Busy){
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.busy"],_buddy.displayName];
                        }else{
                            //等待中对方拒绝
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.reject"],_buddy.displayName];
                        }
                        hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.opposite_no_response"];
                    }
                }else{
                    if (_interrupt) {
                        //通话中挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }else{
                        //通话中对方挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }
                    hintMessage = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.message.hint.end"],[self stringWithTime]];
                }
            }
            
            _contentLabel.text = content;
            
            [_contentLabel sizeToFit];
            _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
            _interruptButton.hidden = YES;
            _interruptLabel.hidden = YES;
            
            _rejectButton.hidden = YES;
            _rejectLabel.hidden = YES;
            
            _agreeButton.hidden = YES;
            _agreeLabel.hidden = YES;
            
            _silenceButton.hidden = YES;
            _silenceLabel.hidden = YES;
            
            _expandButton.hidden = YES;
            _expandLabel.hidden = YES;
            
            if (_ringPlayer) {
                [_ringPlayer stop];
            }
            _ringPlayer = nil;
            
            BACK((^{
                EM_ChatMessageExtendCall *extendBody = [[EM_ChatMessageExtendCall alloc]init];
                NSString *text = nil;
                if (self.callType == eCallSessionTypeAudio) {
                    text = [NSString stringWithFormat:@"%@%@",[EM_ChatResourcesUtils stringWithName:@"common.message_type_call_voice"],hintMessage];
                }else{
                    text = [NSString stringWithFormat:@"%@%@",[EM_ChatResourcesUtils stringWithName:@"common.message_type_call_video"],hintMessage];
                }
                extendBody.callType = self.callType;
                
                EM_ChatMessageExtend *extend = [[EM_ChatMessageExtend alloc]init];
                extend.extendBody = extendBody;
                
                EMChatText *chatText = [[EMChatText alloc] initWithText:text];
                EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
                EMMessage *message = [[EMMessage alloc] initWithReceiver:_callSession.sessionChatter bodies:@[textBody]];
                message.isRead = YES;
                message.deliveryState = eMessageDeliveryState_Delivered;
                message.ext = [extend toDictionary];
                
                [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[message] forChatter:_callSession.sessionChatter append2Chat:YES];
                sleep(3);
                MAIN(^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }));
        }
            break;
    }
    _callState = callState;
}

- (NSString *)stringWithTime{
    int h = _duration / 3600;
    int m = (_duration - h * 3600) / 60;
    int s = _duration - h * 3600 - m * 60;
    
    NSMutableString *timeStr = [[NSMutableString alloc]init];
    if (h > 0) {
        [timeStr appendFormat:@"%i:",h];
    }
    if (m >= 10) {
        [timeStr appendFormat:@"%i:",m];
    }else{
        [timeStr appendFormat:@"0%i:",m];
    }
    if (s >= 10) {
        [timeStr appendFormat:@"%i",s];
    }else{
        [timeStr appendFormat:@"0%i",s];
    }
    
    return timeStr;
}

- (void)timerInit{
    [self timerInvalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerInvalidate{
    if (_timer) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)timerAction:(id)sender{
    _duration += 1;
    _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.ongoing"],_buddy.displayName,[self stringWithTime]];
    [_contentLabel sizeToFit];
    _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
}

/**
 *  挂断
 *
 *  @param sender
 */
- (void)interruptCall:(id)sender{
    _interrupt = YES;
    _hangup = YES;
    [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Hangup];
}

/**
 *  拒绝
 *
 *  @param sender
 */
- (void)rejectCall:(id)sender{
    if (_callState != EMChatCallStateWait) {
        return;
    }
    _reject = YES;
    _hangup = YES;
    [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Reject];
}

/**
 *  同意
 *
 *  @param sender
 */
- (void)agreeCall:(id)sender{
    if (_callState != EMChatCallStateWait) {
        return;
    }
    _agree = YES;
    [[EaseMob sharedInstance].callManager asyncAnswerCall:self.callSession.sessionId];
}

/**
 *  静音
 *
 *  @param sender
 */
- (void)silenceCall:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor whiteColor];
        _expandButton.selected = NO;
        _expandButton.backgroundColor = [UIColor clearColor];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else{
        sender.backgroundColor = [UIColor clearColor];
    }
    
    [[EaseMob sharedInstance].callManager markCallSession:self.callSession.sessionId asSilence:sender.selected];
}

/**
 *  免提
 *
 *  @param sender
 */
- (void)expandCall:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor whiteColor];
        _silenceButton.selected = NO;
        _silenceButton.backgroundColor = [UIColor clearColor];
        [[EaseMob sharedInstance].callManager markCallSession:self.callSession.sessionId asSilence:NO];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }else{
        sender.backgroundColor = [UIColor clearColor];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
}

#pragma mark - EMCallManagerDelegate
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error{
    if (![callSession.sessionId isEqualToString:self.callSession.sessionId]) {
        [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Busy];
        return;
    }
    if (callSession.status == eCallSessionStatusAccepted){
        [self timerInit];
        [self setCallState:EMChatCallStateIn];
    }else if (callSession.status == eCallSessionStatusDisconnected){
        _reason = reason;
        [self timerInvalidate];
        [self setCallState:EMChatCallStateEnd];
    }
}

#pragma mark - GPUImageVideoCameraDelegate
- (void)didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    if (_callSession.status != eCallSessionStatusAccepted) {
        return;
    }
    
    CMSampleBufferRef dataBuffer = sampleBuffer;
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(dataBuffer);
    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess){
        UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
        
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
        size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 1);
        
        if (_imageDataBuffer == nil) {
            _imageDataBuffer = (UInt8 *)malloc(width * height * 3 / 2);
        }
        UInt8 *pY = bufferPtr;
        UInt8 *pUV = bufferPtr1;
        UInt8 *pU = _imageDataBuffer + width * height;
        UInt8 *pV = pU + width * height / 4;
        for(int i =0; i < height; i++){
            memcpy(_imageDataBuffer + i * width, pY + i * bytesrow0, width);
        }
        
        for(int j = 0; j < height / 2; j++){
            for(int i = 0; i < width / 2; i++){
                *(pU++) = pUV[i<<1];
                *(pV++) = pUV[(i<<1) + 1];
            }
            pUV += bytesrow1;
        }
        
        YUV420spRotate90(bufferPtr, _imageDataBuffer, width, height);
        [[EaseMob sharedInstance].callManager processPreviewData:(char *)bufferPtr width:(int)width height:(int)height];
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
}

void YUV420spRotate90(UInt8 *  dst, UInt8* src, size_t srcWidth, size_t srcHeight){
    size_t wh = srcWidth * srcHeight;
    size_t uvHeight = srcHeight >> 1;//uvHeight = height / 2
    size_t uvWidth = srcWidth >> 1;
    size_t uvwh = wh >> 2;
    //旋转Y
    int k = 0;
    for(int i = 0; i < srcWidth; i++) {
        int nPos = (int)(wh - srcWidth);
        for(int j = 0; j < srcHeight; j++) {
            dst[k] = src[nPos + i];
            k++;
            nPos -= srcWidth;
        }
    }
    for(int i = 0; i < uvWidth; i++) {
        int nPos = (int)(wh + uvwh - uvWidth);
        for(int j = 0; j < uvHeight; j++) {
            dst[k] = src[nPos + i];
            dst[k+uvwh] = src[nPos + i+uvwh];
            k++;
            nPos -= uvWidth;
        }
    }
}

@end