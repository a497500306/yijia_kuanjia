//
//  TXSoundPlayer.h
//  语音播报DOME
//
//  Created by 洛耳 on 15/11/26.
//  Copyright © 2015年 workorz. All rights reserved.
//

//  Created by 鑫 on 14/12/23.
//  Copyright (c) 2014年 梁镋鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TXSoundPlayer : NSObject
{
    NSMutableDictionary* soundSet;  //声音设置
    NSString* path;  //配置文件路径
}

@property(nonatomic,assign)float rate;   //语速
@property(nonatomic,assign)float volume; //音量
@property(nonatomic,assign)float pitchMultiplier;  //音调
@property(nonatomic,assign)BOOL autoPlay;  //自动播放


+(TXSoundPlayer*)soundPlayerInstance;

-(void)play:(NSString*)text;

-(void)setDefault;

-(void)writeSoundSet;

@end
