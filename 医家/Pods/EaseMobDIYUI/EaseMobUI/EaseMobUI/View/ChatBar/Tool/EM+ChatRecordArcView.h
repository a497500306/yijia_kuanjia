//
//  FXRecordArcView.h
//  FXRecordArc
//
//  Created by 方 霄 on 14-6-10.
//  Copyright (c) 2014年 方 霄. All rights reserved.
//
#import <UIKit/UIKit.h>

#define WAVE_UPDATE_FREQUENCY   (0.1)
#define SILENCE_VOLUME          (45.0)
#define SOUND_METER_COUNT       (6)

@protocol EM_ChatRecordArcViewDelegate;

@interface EM_ChatRecordArcView : UIView

@property(nonatomic, assign,readonly) CGFloat recordTime;

@property (nonatomic) id<EM_ChatRecordArcViewDelegate> delegate;
@property (nonatomic,assign,readonly) BOOL isRecording;
@property (nonatomic,assign,readonly) BOOL isPlaying;

- (void)startRecord;
- (void)cancelRecord;
- (void)stopRecord;

- (void)startPlay:(NSString *)recordPath duration:(CGFloat)duration;
- (void)stopPlay;
@end

@protocol EM_ChatRecordArcViewDelegate <NSObject>

@required

@optional
- (void)willRecordStart;
- (void)didRecordStart:(NSString *)recordName;
- (void)didRecording:(CGFloat)recordTime;
- (void)didRecordEnd:(NSString *)recordName path:(NSString *)recordPath duration:(NSInteger)recordDuration;
- (void)didRecordCancel;
- (void)didRecordError:(NSError *)error;

- (void)didPlayStart;
- (void)didPlayStop;
- (void)didPlaying:(CGFloat )recordTime;

@end