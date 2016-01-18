//
//  TXSoundPlayer.m
//  语音播报DOME
//
//  Created by 洛耳 on 15/11/26.
//  Copyright © 2015年 workorz. All rights reserved.
//

//
//  Created by 鑫 on 14/12/23.
//  Copyright (c) 2014年 梁镋鑫. All rights reserved.
//

#import "TXSoundPlayer.h"

static TXSoundPlayer* soundplayer=nil;

@implementation TXSoundPlayer

+(TXSoundPlayer*)soundPlayerInstance
{
    if(soundplayer==nil)
    {
        soundplayer=[[TXSoundPlayer alloc]init];
        [soundplayer initSoundSet];
    }
    return soundplayer;
}

//播放声音
-(void)play:(NSString*)text
{
    if(!text.length == 0)
    {
        AVSpeechSynthesizer* player=[[AVSpeechSynthesizer alloc]init];
        AVSpeechUtterance* u=[[AVSpeechUtterance alloc]initWithString:text];//设置要朗读的字符串
        u.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
        u.volume=self.volume;  //设置音量（0.0~1.0）默认为1.0
        u.rate=self.rate;  //设置语速
        u.pitchMultiplier=self.pitchMultiplier;  //设置语调
        [player speakUtterance:u];
    }
}

//初始化配置
-(void)initSoundSet
{
    path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SoundSet.plist"];
    soundSet=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    if(soundSet==nil)
    {
        soundSet=[NSMutableDictionary dictionary];
        [soundplayer setDefault];
        [soundplayer writeSoundSet];
    }
    else
    {
        self.autoPlay=[[soundSet valueForKeyPath:@"autoPlay"] boolValue];
        self.volume=[[soundSet valueForKeyPath:@"volume"] floatValue];
        self.rate=[[soundSet valueForKeyPath:@"rate"] floatValue];
        self.pitchMultiplier=[[soundSet valueForKeyPath:@"pitchMultiplier"] floatValue];
    }
}

//恢复默认设置
-(void)setDefault
{
    self.volume=0.7;
    self.rate=0.166;
    self.pitchMultiplier=1.0;
}

//将设置写入配置文件
-(void)writeSoundSet
{
    [soundSet setValue:[NSNumber numberWithBool:self.autoPlay] forKey:@"autoPlay"];
    [soundSet setValue:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
    [soundSet setValue:[NSNumber numberWithFloat:self.rate] forKey:@"rate"];
    [soundSet setValue:[NSNumber numberWithFloat:self.pitchMultiplier] forKey:@"pitchMultiplier"];
    [soundSet writeToFile:path atomically:YES];
}

@end
