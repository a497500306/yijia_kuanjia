//
//  EM+MessageRecordView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "EM+ChatRecordView.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "UIColor+Hex.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatRecordArcView.h"
#import "EMErrorDefs.h"


#define HEIGHT_OF_RECORD_LABEL (IS_PAD ? 25 : 20)

#define BUTTON_SIZE (40)
#define BOTTOM_HEIGHT (30)
#define RECORD_NORMAL_BACKGROUND_COLOR (0xafa376)

typedef NS_ENUM(NSUInteger,RECORD_STATE) {
    RECORD_STATE_NORMAL = 0,
    RECORD_STATE_RECORDING,//录音中
    RECORD_STATE_WILL_CANCEL,//将要取消录音
    RECORD_STATE_WILL_PLAY,//将要播放录音
    RECORD_STATE_RECORDED,
    RECORD_STATE_PLAYING,
    RECORD_STATE_STOP
};

@interface EM_ChatRecordView()<EM_ChatRecordArcViewDelegate>

@end

@implementation EM_ChatRecordView{
    EM_ChatRecordArcView *arcView;
    UILabel *recordLabel;
    UILabel *recordView;
    UILabel *cancelView;
    UILabel *playView;
    UIButton *cancelButton;
    UIButton *sendButton;
    UIView *buttonLine;
    BOOL shouldRecord;
    RECORD_STATE _state;
    NSString *_recordName;
    NSString *_recordPath;
    NSInteger _recordDuration;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        arcView = [[EM_ChatRecordArcView alloc]init];
        arcView.delegate = self;
        arcView.hidden = YES;
        [self addSubview:arcView];
        
        recordLabel = [[UILabel alloc]init];
        recordLabel.textColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
        recordLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:recordLabel];
        
        recordView = [[UILabel alloc]init];
        recordView.font = [EM_ChatResourcesUtils iconFontWithSize:80];
        recordView.textAlignment = NSTextAlignmentCenter;
        recordView.backgroundColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
        recordView.textColor = [UIColor whiteColor];
        recordView.layer.masksToBounds = YES;
        [self addSubview:recordView];
        
        cancelView = [[UILabel alloc]init];
        cancelView.font = [EM_ChatResourcesUtils iconFontWithSize:25];
        cancelView.text = kEMChatIconMoreTrash;
        cancelView.backgroundColor = [UIColor whiteColor];
        cancelView.textColor = [UIColor grayColor];
        cancelView.textAlignment = NSTextAlignmentCenter;
        cancelView.layer.cornerRadius = BUTTON_SIZE / 2;
        cancelView.layer.masksToBounds = YES;
        cancelView.layer.borderColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR].CGColor;
        cancelView.layer.borderWidth = LINE_WIDTH;
        [self addSubview:cancelView];
        
        playView = [[UILabel alloc]init];
        playView.font = [EM_ChatResourcesUtils iconFontWithSize:25];
        playView.text = KEMChatIconMorePlay;
        playView.backgroundColor = [UIColor whiteColor];
        playView.textColor = [UIColor grayColor];
        playView.textAlignment = NSTextAlignmentCenter;
        playView.layer.cornerRadius = BUTTON_SIZE / 2;
        playView.layer.masksToBounds = YES;
        playView.layer.borderColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR].CGColor;
        playView.layer.borderWidth = LINE_WIDTH;
        [self addSubview:playView];
        
        cancelButton = [[UIButton alloc]init];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:[EM_ChatResourcesUtils stringWithName:@"common.cancel"] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        sendButton = [[UIButton alloc]init];
        sendButton.backgroundColor = [UIColor whiteColor];
        [sendButton setTitle:[EM_ChatResourcesUtils stringWithName:@"common.send"] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(recordSend:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        
        buttonLine = [[UIView alloc]init];
        buttonLine.backgroundColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
        [self addSubview:buttonLine];
        
        [self refreshUIWithSate:RECORD_STATE_NORMAL];
    }
    return self;
}

- (void)refreshUIWithSate:(RECORD_STATE)state{
    _state = state;
    switch (_state) {
        case RECORD_STATE_RECORDING:{
            recordLabel.tag = 0;
            
            recordView.font = [EM_ChatResourcesUtils iconFontWithSize:60];
            recordView.text = kEMChatIconMoreRecord;
            recordView.backgroundColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
            recordView.textColor = [UIColor whiteColor];
            
            playView.hidden = NO;
            
            cancelView.hidden = NO;
            
            cancelButton.hidden = YES;
            sendButton.hidden = YES;
            buttonLine.hidden = YES;
            
            arcView.hidden = NO;
        }
            break;
        case RECORD_STATE_WILL_CANCEL:{
            recordLabel.tag = 1;
            recordLabel.text = [EM_ChatResourcesUtils stringWithName:@"record.will_cancel"];
            
            recordView.font = [EM_ChatResourcesUtils iconFontWithSize:60];
            recordView.text = kEMChatIconMoreRecord;
            recordView.backgroundColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
            recordView.textColor = [UIColor whiteColor];
            
            playView.hidden = NO;
            
            cancelView.hidden = NO;
            
            cancelButton.hidden = YES;
            sendButton.hidden = YES;
            buttonLine.hidden = YES;
            
            arcView.hidden = NO;
        }
            break;
        case RECORD_STATE_WILL_PLAY:{
            recordLabel.tag = 1;
            recordLabel.text = [EM_ChatResourcesUtils stringWithName:@"record.will_audition"];
            
            recordView.font = [EM_ChatResourcesUtils iconFontWithSize:60];
            recordView.text = kEMChatIconMoreRecord;
            recordView.backgroundColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
            recordView.textColor = [UIColor whiteColor];
            
            playView.hidden = NO;
            
            cancelView.hidden = NO;
            
            cancelButton.hidden = YES;
            sendButton.hidden = YES;
            buttonLine.hidden = YES;
            
            arcView.hidden = NO;
        }
            break;
        case RECORD_STATE_PLAYING:{
            recordLabel.tag = 0;
            
            recordView.font = [EM_ChatResourcesUtils iconFontWithSize:50];
            recordView.text = kEMChatIconMoreStop;
            recordView.backgroundColor = [UIColor whiteColor];
            recordView.textColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
            
            playView.hidden = YES;
            
            cancelView.hidden = YES;
            
            cancelButton.hidden = NO;
            sendButton.hidden = NO;
            buttonLine.hidden = NO;
            
            arcView.hidden = NO;
        }
            break;
        case RECORD_STATE_STOP:{
            int minute = ((int)_recordDuration) / 60;
            int second = ((int)_recordDuration) % 60;
            NSMutableString *time = [[NSMutableString alloc]init];
            if (minute < 10) {
                [time appendString:@"0"];
            }
            [time appendFormat:@"%d",minute];
            [time appendString:@":"];
            if (second < 10) {
                [time appendString:@"0"];
            }
            [time appendFormat:@"%d",second];
            recordLabel.text = time;
            recordLabel.tag = 0;
            
            recordView.font = [EM_ChatResourcesUtils iconFontWithSize:50];
            recordView.text = KEMChatIconMorePlay;
            recordView.backgroundColor = [UIColor whiteColor];
            recordView.textColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
            
            playView.hidden = YES;
            
            cancelView.hidden = YES;
            
            cancelButton.hidden = NO;
            sendButton.hidden = NO;
            buttonLine.hidden = NO;
            
            arcView.hidden = NO;
        }
            break;
        default:{
            recordLabel.tag = 0;
            recordLabel.text = [EM_ChatResourcesUtils stringWithName:@"record.normal_record"];
            
            recordView.font = [EM_ChatResourcesUtils iconFontWithSize:60];
            recordView.text = kEMChatIconMoreRecord;
            recordView.backgroundColor = [UIColor colorWithHexRGB:RECORD_NORMAL_BACKGROUND_COLOR];
            recordView.textColor = [UIColor whiteColor];
            
            playView.hidden = YES;
            
            cancelView.hidden = YES;
            
            cancelButton.hidden = YES;
            sendButton.hidden = YES;
            buttonLine.hidden = YES;
            
            arcView.hidden = YES;
        }
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    recordLabel.frame = CGRectMake(0, 0, size.width, HEIGHT_OF_RECORD_LABEL);
    
    arcView.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat recordButtonSize = size.height - recordLabel.frame.size.height - BUTTON_SIZE - COMMON_PADDING * 2;
    
    recordView.frame = CGRectMake((size.width - recordButtonSize) / 2, (size.height - recordButtonSize) / 2, recordButtonSize, recordButtonSize);
    recordView.layer.cornerRadius = recordButtonSize / 2;
    
    cancelView.frame = CGRectMake(size.width - RIGHT_PADDING * 2 - BUTTON_SIZE, (size.height - BUTTON_SIZE) / 2, BUTTON_SIZE, BUTTON_SIZE);
    playView.frame = CGRectMake(LEFT_PADDING * 2, (size.height - BUTTON_SIZE) / 2, BUTTON_SIZE, BUTTON_SIZE);
    
    cancelButton.frame = CGRectMake(0, size.height - BOTTOM_HEIGHT, size.width / 2, BOTTOM_HEIGHT);
    sendButton.frame = CGRectMake(size.width / 2, size.height - BOTTOM_HEIGHT, size.width / 2, BOTTOM_HEIGHT);
    buttonLine.frame = CGRectMake(size.width / 2, size.height - BOTTOM_HEIGHT, 0.5, BOTTOM_HEIGHT);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (_state == RECORD_STATE_NORMAL) {
        UITouch *touch = [touches anyObject];
        if (event.allTouches.allObjects.count > 1) {
            return;
        }
        CGPoint point = [touch locationInView:self];
        
        if (CGRectContainsPoint(recordView.frame,point)) {
            shouldRecord = YES;
            if (_delegate) {
                shouldRecord = [_delegate shouldRecord];
            }
            if (!shouldRecord) {
                return;
            }
            [arcView startRecord];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (!shouldRecord) {
        return;
    }
    if (_state != RECORD_STATE_RECORDING && _state != RECORD_STATE_WILL_CANCEL && _state != RECORD_STATE_WILL_PLAY) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if (event.allTouches.allObjects.count > 1) {
        return;
    }
    
    CGPoint point = [touch locationInView:self];
    
    BOOL willCancel = CGRectContainsPoint(cancelView.frame,point);
    BOOL willPlay = CGRectContainsPoint(playView.frame, point);
    
    switch (_state) {
        case RECORD_STATE_RECORDING:{
            if (willCancel) {
                [self refreshUIWithSate:RECORD_STATE_WILL_CANCEL];
            }else if(willPlay){
                [self refreshUIWithSate:RECORD_STATE_WILL_PLAY];
            }
        }
            break;
        case RECORD_STATE_WILL_CANCEL:{
            if (willPlay) {
                [self refreshUIWithSate:RECORD_STATE_WILL_PLAY];
            }else if(!willCancel){
                [self refreshUIWithSate:RECORD_STATE_RECORDING];
            }
        }
            break;
        case RECORD_STATE_WILL_PLAY:{
            if (willCancel) {
                [self refreshUIWithSate:RECORD_STATE_WILL_CANCEL];
            }else if(!willPlay){
                [self refreshUIWithSate:RECORD_STATE_RECORDING];
            }
        }
            break;
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    if (!shouldRecord) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if (event.allTouches.allObjects.count > 1) {
        return;
    }
    
    if (_state == RECORD_STATE_RECORDING) {
        //发送
        [self refreshUIWithSate:RECORD_STATE_NORMAL];
        [arcView stopRecord];
    }else if(_state == RECORD_STATE_WILL_CANCEL || _state == RECORD_STATE_WILL_PLAY){
        if (_state == RECORD_STATE_WILL_CANCEL) {
            //取消发送
            [arcView cancelRecord];
        }else if(_state == RECORD_STATE_WILL_PLAY){
            //试听
            [self refreshUIWithSate:RECORD_STATE_STOP];
            [arcView stopRecord];
        }
    }else if(_state == RECORD_STATE_STOP || _state == RECORD_STATE_PLAYING){
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(recordView.frame, point)) {
            if(_state == RECORD_STATE_STOP){
                if (_recordPath) {
                    [arcView startPlay:_recordPath duration:_recordDuration];
                }
            }else if(_state == RECORD_STATE_PLAYING){
                [arcView stopPlay];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    
    if (!shouldRecord) {
        return;
    }
    //取消
    [arcView cancelRecord];
}

- (void)recordCancel:(id)sender{
    [arcView cancelRecord];
}

- (void)recordSend:(id)sender{
    [self refreshUIWithSate:RECORD_STATE_NORMAL];
    if (_delegate && _recordPath && _recordPath.length > 0) {
        [_delegate didRecordEnd:_recordName path: _recordPath duration:_recordDuration];
    }
    _recordName = nil;
    _recordPath = nil;
    _recordDuration = 0;
}

#pragma mark - EM_ChatRecordArcViewDelegate
- (void)willRecordStart{
    recordLabel.text = [EM_ChatResourcesUtils stringWithName:@"record.will_record"];
}
- (void)didRecordStart:(NSString *)recordName{
    _recordName = recordName;
    recordLabel.text = @"00:00";
    [self refreshUIWithSate:RECORD_STATE_RECORDING];
    if(_delegate){
        [_delegate didRecordStart];
    }
}
- (void)didRecording:(CGFloat)recordTime{
    if (recordLabel.tag != 0) {
        return;
    }
    int minute = ((int)recordTime) / 60;
    int second = ((int)recordTime) % 60;
    NSMutableString *time = [[NSMutableString alloc]init];
    if (minute < 10) {
        [time appendString:@"0"];
    }
    [time appendFormat:@"%d",minute];
    [time appendString:@":"];
    if (second < 10) {
        [time appendString:@"0"];
    }
    [time appendFormat:@"%d",second];
    recordLabel.text = time;
    
    if (_delegate) {
        [_delegate didRecording:recordTime];
    }
}

- (void)didRecordEnd:(NSString *)recordName path:(NSString *)recordPath duration:(NSInteger)recordDuration{
    if (recordPath && recordPath.length > 0) {
        _recordPath = recordPath;
        _recordDuration = recordDuration;
        if (_state == RECORD_STATE_NORMAL) {
            [self recordSend:nil];
        }
    }else{
        if (_delegate) {
            [_delegate didRecordError:nil];
        }
    }
}
- (void)didRecordCancel{
    [self refreshUIWithSate:RECORD_STATE_NORMAL];
    if(_delegate){
        [_delegate didRecordCancel];
    }
}

- (void)didRecordError:(NSError *)error{
    if (_delegate) {
        [_delegate didRecordError:error];
    }
}

- (void)didPlayStart{
    [self refreshUIWithSate:RECORD_STATE_PLAYING];
    if (_delegate) {
        [_delegate didRecordPlay];
    }
}
- (void)didPlayStop{
    [self refreshUIWithSate:RECORD_STATE_STOP];
    if (_delegate) {
        [_delegate didRecordPlayStop];
    }
}
- (void)didPlaying:(CGFloat )recordTime{
    [self didRecording:recordTime];
    if (_delegate) {
        [_delegate didRecordPlaying:recordTime];
    }
}
@end