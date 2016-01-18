//
//  FXRecordArcView.m
//  FXRecordArc
//
//  Created by 方 霄 on 14-6-10.
//  Copyright (c) 2014年 方 霄. All rights reserved.
//

#import "EM+ChatRecordArcView.h"
#import "EMCDDeviceManager.h"
#import "UIColor+Hex.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger,ACTION_STATE) {
    ACTION_STATE_NORMAL = 0,
    ACTION_STATE_RECORD,
    ACTION_STATE_PLAY
};

@interface EM_ChatRecordArcView (){
    int soundMeters[SOUND_METER_COUNT];
}

@property(readwrite, nonatomic, strong) AVAudioRecorder *recorder;
@property(readwrite, nonatomic, strong) NSTimer *timer;
@property(readwrite, nonatomic, assign) ACTION_STATE state;

@end

@implementation EM_ChatRecordArcView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSoundMeters];
    }
    return self;
}

- (void)initSoundMeters{
    for(int i=0; i<SOUND_METER_COUNT; i++) {
        soundMeters[i] = SILENCE_VOLUME;
    }
}

//
- (void)startPlay:(NSString *)recordPath duration:(CGFloat)duration{
    if (!self.isPlaying) {
        _recordTime = duration;
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:recordPath completion:^(NSError *error) {
            [self.timer invalidate];
            [self initSoundMeters];
            [self setNeedsDisplay];
            _recordTime = 0;
            _state = ACTION_STATE_NORMAL;
            if (_delegate) {
                [_delegate didPlayStop];
            }
        }];
        _state = ACTION_STATE_PLAY;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
        if (_delegate) {
            [_delegate didPlayStart];
        }
    }
}

- (void)stopPlay{
    if (self.isPlaying) {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
        [self.timer invalidate];
        [self initSoundMeters];
        [self setNeedsDisplay];
        _recordTime = 0;
        _state = ACTION_STATE_NORMAL;
        if (_delegate) {
            [_delegate didPlayStop];
        }
    }
}

- (BOOL)isPlaying{
    return [EMCDDeviceManager sharedInstance].isPlaying;
}

- (void)startRecord{
    _recordTime = 0.0;
    if (_delegate) {
        [_delegate willRecordStart];
    }
    
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error){
        _recordTime = 0;
        if (!error) {
            _state = ACTION_STATE_RECORD;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
            if (_delegate) {
                [_delegate didRecordStart:fileName];
            }
        }else{
            if (_delegate) {
                [_delegate didRecordError:error];
            }
        }
    }];
}

- (void)cancelRecord{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [self.timer invalidate];
    [self initSoundMeters];
    [self setNeedsDisplay];
    _state = ACTION_STATE_NORMAL;
    if (_delegate) {
        [_delegate didRecordCancel];
    }
}

- (void)stopRecord{
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        [self.timer invalidate];
        [self initSoundMeters];
        [self setNeedsDisplay];
        _state = ACTION_STATE_NORMAL;
        if (_delegate) {
            [_delegate didRecordEnd:recordPath path:recordPath duration:aDuration];
        }
    }];
}

- (BOOL)isRecording{
    return [EMCDDeviceManager sharedInstance].isRecording;
}

//
- (void)updateMeters{
    
    int volume = SILENCE_VOLUME;
    
    if (_state == ACTION_STATE_PLAY) {
        _recordTime -= WAVE_UPDATE_FREQUENCY;
        volume = [[EMCDDeviceManager sharedInstance] emPlayerAveragePower];
        if(_delegate){
            [_delegate didPlaying:_recordTime];
        }
    }else if(_state == ACTION_STATE_RECORD){
        _recordTime += WAVE_UPDATE_FREQUENCY;
        volume = [[EMCDDeviceManager sharedInstance] emRecorderAveragePower];
        if(_delegate){
            [_delegate didRecording:_recordTime];
        }
    }
    
    if (volume < -SILENCE_VOLUME) {
        [self addSoundMeterItem:SILENCE_VOLUME];
        return;
    }
    [self addSoundMeterItem:volume];
}

- (void)addSoundMeterItem:(int)lastValue{
    for(int i = 0; i < SOUND_METER_COUNT - 1; i++) {
        soundMeters[i] = soundMeters[i+1];
    }
    soundMeters[SOUND_METER_COUNT - 1] = lastValue;
    [self setNeedsDisplay];
}

#pragma mark - Drawing operations
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    int baseLine = rect.size.height / 2;
    static int multiplier = 1;
    int maxLengthOfWave = 45;
    int maxValueOfMeter = 400;
    int yHeights[6];
    float segement[6] = {0.05, 0.2, 0.35, 0.25, 0.1, 0.05};
    
    [[UIColor colorWithHexRGB:0xafa376] set];
    CGContextSetLineWidth(context, 2.0);
    
    for(int x = SOUND_METER_COUNT - 1; x >= 0; x--){
        int multiplier_i = ((int)x % 2) == 0 ? 1 : -1;
        CGFloat y = ((maxValueOfMeter * (maxLengthOfWave - abs(soundMeters[(int)x]))) / maxLengthOfWave);
        yHeights[SOUND_METER_COUNT - 1 - x] = multiplier_i * y * segement[SOUND_METER_COUNT - 1 - x]  * multiplier+ baseLine;
    }
    
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:2.0 alpha:0.8 percent:1.0 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.4 percent:0.66 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.2 percent:0.33 segementArray:segement];
    multiplier = -multiplier;
}

- (void)drawLinesWithContext:(CGContextRef)context BaseLine:(float)baseLine HeightArray:(int*)yHeights lineWidth:(CGFloat)width alpha:(CGFloat)alpha percent:(CGFloat)percent segementArray:(float *)segement{
    
    CGFloat start = 0;
    [[UIColor colorWithHexRGB:0xafa376] set];
    CGContextSetLineWidth(context, width);
    
    CGFloat HUD_SIZE = self.bounds.size.width;
    for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) {
            CGContextMoveToPoint(context, start, baseLine);
            CGContextAddCurveToPoint(context, HUD_SIZE *segement[i] / 2 + start, (yHeights[i] - baseLine)*percent + baseLine, HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1] / 2 + start, (yHeights[i + 1] - baseLine)*percent + baseLine,HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1] + start , baseLine);
            start += HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1];
        }
    }
    CGContextStrokePath(context);
}


- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.recorder.delegate = nil;
}

@end