[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI.git)|[EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull.git)

**VoiceConvert**专门用于iOS音频文件转换,[amrToWav|wavToAmr],判断文件是否是mp3文件[isMP3File],判断文件是否是arm文件[isAMRFile].代码是我从环信Demo里拿出来的,本来是想直接放到自己项目里的[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI.git)。但在自己项目制作成pod然后在其他项目里集成时,总是有异常错误，没有办法只能单独拿出做成pod。这样也能够方便大家使用pod单独集成该功能模块。
感谢该功能的作者@(Jeans Huang)。

###pod

```pod 'VoiceConvert',:git => "https://github.com/AwakenDragon/VoiceConvert.git"```

###引入

```import "EMVoiceConverter.h"```

###方法

```
@interface EMVoiceConverter : NSObject

+ (int)isMP3File:(NSString *)filePath;

+ (int)isAMRFile:(NSString *)filePath;

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath;

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath;

@end
```
