#EaseMobDIYUI
@(EaseMob)[自定义聊天UI|简单继承|pod]
- **[LeanCloud](https://leancloud.cn/)**：LeanCloud 实时消息只需几行代码，就可使用户的应用完成移动 IM 的功能添加。 IM 系统与当前用户系统完全解耦，无需同步或修改现有用户体系，即可使用；除 iOS、Android 移动开发的原生 SDK 之外，还也支持网页内聊天。
- **[融云](http://www.rongcloud.cn/)**：融云是国内首家专业的即时通讯云服务提供商，专注为互联网、移动互联网开发者提供即时通讯基础能力和云端服务。通过融云平台，开发者不必搭建服务端硬件环境，就可以将即时通讯、实时网络能力快速集成至应用中 针对开发者所需的不同场景，融云平台提供了一系列产品、技术解决方案，包括：客户端 IM组件，客户端 IM 基础库，服务端 RESTAPI，客户端实时网络通讯基础库等。利用这些解决方案，开发者可以直接在自己的应用中构建出即时通讯产品，也可以无限创意出自己的即时通讯场景。 融云 SDK 包括两部分：IM 界面组件和 IM 能力库。
- **[环信](http://www.easemob.com/)**：环信即时通讯云是移动即时通讯能力的云计算 PaaS (Platform as a Service, 平台即服务)平台服务商。移动即时通讯能力是指基于互联网和移动终端的单聊，群聊，富媒体消息，实时语音，实时视频，多人语音视频，流媒体播放及互动等通讯能力。环信将移动即时通讯能力通过云端开放的API 和客户端 SDK 包的方式提供给开发者和企业，帮助合作伙伴在自己的产品中便捷、快速的实现通讯和社交功能
- **[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)**：[LeanCloud](https://leancloud.cn/)、[融云](http://www.rongcloud.cn/)、[环信](http://www.easemob.com/)是我用过IM平台，也是当前比较受欢迎的三个IM平台。通过对比它们的优缺点，还是非常明显的。[LeanCloud](https://leancloud.cn/)免费内容太少，超过500用户就要收费，SDK支持的平台倒是挺多的。[融云](http://www.rongcloud.cn/)还不错，在1.0时代有太多的问题，有幸看到过它们的UI代码，写的比较烂。没有WinPhone的支持， Server SDK支持也比较多。[环信](http://www.easemob.com/)在免费内容上和融云做得差不多，SDK 的API也不错，但是没有让开发者直接拿来继承使用的UI（只是有个Demo，但是直接使用太麻烦，如果能pod得话就更好，这也是我现在写这个项目的初衷）。

---
* [简介](#1) 
    * [环信SDK](#1.1) 
    * [额外功能](#1.2) 
* [使用](#2)
    * [要求](#2.1) 
    * [pod](#2.2) 
    * [依赖](#2.3) 
    * [初始化及权限](#2.4) 
        * [初始化](#2.4.1)
        * [权限](#2.4.2)
    * [会话列表](#2.5)   
    * [好友列表](#2.6) 
    * [聊天界面](#2.7)
        * [配置文件](#2.7.1)
    * [自定义扩展](#2.8)
    * [UI](#2.9)
* [期望](#3)
  
<h2 id = "1">简介</h2>
集成环信的即时通讯功能，pod集成，方便管理。简单继承，轻松定制自己的UI界面。当前最新版本```0.2.6```,主要由会话列表(```EM_ConversationListController```)、好友列表(```EM_FriendsController```)和聊天界面(```EM_ChatController```)组成。很多功能和界面都在开发中，聊天界面的UI也没有开发完善，所以现在显示很挫。在```1.0.0```版本之前会完成所有可以使用环信SDK实现的功能，并且加入其它实用的功能，在此之前也不适合使用。当然你也可以参考环信的[Demo](http://www.easemob.com/downloads)。

<h3 id = "1.1">环信SDK</h3>
使用pod集成的[EaseMobSDKFull](https://github.com/easemob/sdk-ios-cocoapods-integration)，集成版本```2.2.0```。因为pod集成[EaseMobSDK](https://github.com/easemob/sdk-ios-cocoapods/tree/master/EaseMobSDK)是没有语音和视频通讯功能的。根据环信的官方文档来看，pod集成的是私有库，cocoapods公共库上的SDK已经弃用了。所以需要大家自己单独pod环信SDK

<h3 id = "1.2">额外功能</h3>
- 会话编辑状态保存
- 最近Emoji表情的保存
- 自定义扩展View，由环信的消息扩展来决定
- 语音消息发送之前的播放
- 自定义Action，除了图片、相机、语音、视频、位置和文件等Action外，可以额外添加其它Action，View会根据数量来自动增加翻页
- 语音识别（未实现）
- 文件浏览器
- WiFi文件上传
- .......

<h2 id = "2">使用</h2>
<h3 id = "2.1">要求</h3>
iOS版本7.0以上
<h3 id = "2.2">pod</h3>
```
pod 'EaseMobSDKFull',:git => 'https://github.com/easemob/sdk-ios-cocoapods-integration.git'
```
```
pod 'EaseMobDIYUI', :git => 'https://github.com/AwakenDragon/EaseMobDIYUI.git'
```
```
pod 'VoiceConvert',:git => "https://github.com/AwakenDragon/VoiceConvert.git"
```

*PS:语音消息的播放需要[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能模块，开始我试图直接把[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能代码放到项目里使用，但在制作成pod并使用的时候，总是报找不到相关类库文件的错误。无奈只能单独将[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能做成pod来集成。但在制作[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)的pod的时候，没有办法把[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)作为依赖添加进入，所以只能要求使用者，在pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI) 的时候，同时pod [VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)。后期，我会想办法修复这个问题，好可以只pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)。*

<h3 id = "2.3">依赖</h3>
在pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)的时候，EaseMobUI已经添加了以下依赖：
- ```'SDWebImage', '3.7.3'``` 用来加载图片的 [SDWebImage](https://github.com/rs/SDWebImage)
- ```'MJRefresh', '2.4.7'``` 上拉下拉，相信你也会用到 [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
- ```'MWPhotoBrowser', '2.1.1'``` 图片浏览，同时也支持视频播放 [MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)
- ```'MBProgressHUD', '0.9.1'``` 主要还是toast功能 [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
- ```'TTTAttributedLabel', '1.13.4'``` 富文本显示 [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)
- ```'SWTableViewCell','0.3.7'```   Cell左滑显示自定按钮 [SWTableViewCell](https://github.com/CEWendel/SWTableViewCell)
- ```'FXBlurView','1.6.3'``` 毛玻璃效果  [FXBlurView](https://github.com/nicklockwood/FXBlurView)
- ```'JSONModel','1.1.0'```    JSON数据解析 [JSONModel](https://github.com/icanzilb/JSONModel)
- ```'pop','1.0.7'```       View动画  [pop](https://github.com/facebook/pop)
- ```GPUImage```          图片及视频处理，pod运行的时候报错，暂时直接将代码放到了项目里 [GPUImage](https://github.com/BradLarson/GPUImage)
- ```CocoaHTTPServer```   用来实现WiFi文件上传，pod无效   [CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer)
- ```Emoji```       Emoji表情，无法pod   [Emoji](https://github.com/limejelly/Emoji)
所以你不需要再额外pod这些了。后期我会对依赖做适当的增加或删除。

**注意事项1：**在pod完成开始运行的时候， [EaseMobSDKFull](https://github.com/easemob/sdk-ios-cocoapods-integration.git)
的一个文件*```EMErrorDefs.h```*可能会报错，具体原因是几个枚举没有或者重复。

**解决办法：**从环信最新的SDK([EaseMobSDK](https://github.com/easemob/sdk-ios-cocoapods/tree/master/EaseMobSDK) )中拿到这个文件，然后进入自己项目[EaseMobSDKFull](https://github.com/easemob/sdk-ios-cocoapods-integration.git)的对应pod目录，覆盖掉该文件即可。虽然在```XCode```里不允许修改pod的文件，但这样做事没有问题的。

**注意事项2：**当前Git上的项目其实就是一个```Demo```，然后把其中一部分作为```pod```。相信你在看podspec文件的时候就能够看出来，当你```clone```本项目的时候，也需要```pod install```命令来集成一些必要的组件。如果你直接运行```pod install```命令是不行的，直接报错。因为项目的```Podfile```文件中有的组件是通过本地路径来```pod```的，我也是通过这种方式来测试```pod```的。

**解决办法：**将本地```pod```路径修改为对应的网络路径便可。例如```pod 'EaseMobSDKFull', :git => '/Users/ZhouYuzhen/Documents/Git/IOS/EaseMobSDKFull'```改为```pod 'EaseMobSDKFull',:git => 'https://github.com/easemob/sdk-ios-cocoapods-integration.git'```即可。项目所用到的所有第三方组件都会在文档中有跳转链接。不过我的建议是，最好把一些大的组件```clone```到本地，然后进行本地```pod```，这样速度会很快。

**文件目录：**
- ```EaseMobSDK --> include --> Utility --> ErrorManager --> EMErrorDefs.h``` 
- ```你项目根目录 --> Pods --> EaseMobSDKFull --> EaseMobSDKFull --> include --> Utility --> ErrorManager --> EMErrorDefs.h```

<h3 id = "2.4">初始化及权限</h3>
<h4 id = "2.4.1">初始化</h4>
在```AppDelegate```中添加
```
#import "EaseMobUIClient.h"
#import "EaseMob.h"
```
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMob_AppKey apnsCertName:EaseMob_APNSCertName];
    [[EaseMobUIClient sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMobUIClient sharedInstance] registerForRemoteNotificationsWithApplication:application];//你也可以自己注册APNS
    return YES;
}

//这里不是必须调用的方法
- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application{
    [[EaseMobUIClient sharedInstance] applicationProtectedDataWillBecomeUnavailable:application];
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application{
    [[EaseMobUIClient sharedInstance] applicationProtectedDataDidBecomeAvailable:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[EaseMobUIClient sharedInstance] applicationDidReceiveMemoryWarning:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillTerminate:application];
}

//必须调用的方法，不调用也不会报错，只是某些功能不能用而已
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMobUIClient sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMobUIClient sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[EaseMobUIClient sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[EaseMobUIClient sharedInstance] application:application didReceiveLocalNotification:notification];
}
```
实现相关必要的代理
```
[EaseMobUIClient sharedInstance].userDelegate = self; //EM_ChatUserDelegate
[EaseMobUIClient sharedInstance].oppositeDelegate = self; //EM_ChatOppositeDelegate
[EaseMobUIClient sharedInstance].notificationDelegate = self; //EM_ChatNotificationDelegate
```
```
@protocol EM_ChatUserDelegate <NSObject>

@optional
/**
 * 返回当前登录的用户信息
 *
 */
- (EM_ChatUser *)userForEMChat;

@end
```
```
- (EM_ChatUser *)userForEMChat{
    EM_ChatUser *user = [[EM_ChatUser alloc]init];
    user.uid = @"登录用户的环信ID";
    user.displayName = @"要显示的名字";
    user.intro = @"一些简介";
    user.avatar = [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3321692254,2747196227&fm=21&gp=0.jpg"];
    return user;
}
```
```
@protocol EM_ChatOppositeDelegate <NSObject>

@optional
/**
 *  根据chatter返回好友信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回群信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatGroup *)groupInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回群中好友信息
 *
 *  @param chatter
 *  @param group
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inGroup:(EM_ChatGroup *)group;

/**
 *  根据chatter返回讨论组信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatRoom *)roomInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回讨论组成员信息
 *
 *  @param chatter
 *  @param room
 *
 *  @return 
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inRoom:(EM_ChatRoom *)room;

@end
```
```
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter{
    EM_ChatBuddy *buddy = [[EM_ChatBuddy alloc]init];
    buddy.uid = @"好友的环信ID";
    buddy.displayName = @"要显示的名字";
    buddy.intro = @"一些简介";
    buddy.avatar = [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3321692254,2747196227&fm=21&gp=0.jpg"];

    //这两个属性暂时用来存储，真正显示的还是displayName
    buddy.nickName = @"昵称";
    buddy.remarkName = @"备注名称";
    return buddy;
}

- (EM_ChatGroup *)groupInfoWithChatter:(NSString *)chatter{
    EM_ChatBuddy *group = [[EM_ChatBuddy alloc]init];
    group.uid = @"群组的环信ID";
    group.displayName = @"群组名字";
    group.intro = @"一些简介";
    group.avatar = [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3321692254,2747196227&fm=21&gp=0.jpg"];//群组头像
    return group;
}

- (EM_ChatRoom *)roomInfoWithChatter:(NSString *)chatter{
    EM_ChatBuddy *room = [[EM_ChatBuddy alloc]init];
    room.uid = @"讨论组的环信ID";
    room.displayName = @"讨论组名字";
    room.intro = @"一些简介";
    room.avatar = [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3321692254,2747196227&fm=21&gp=0.jpg"];//讨论组组头像
    return room;
}
```
```
@protocol EM_ChatNotificationDelegate <NSObject>

/**
 *  本地消息通知显示内容
 *  只有在消息有用户自己的自定义扩展的时候才会调用
 *
 *  @param message
 *
 *  @return 默认“发来一个新消息”，默认自动在前面加上消息发送者的显示名称
 */
- (NSString *)alertBodyWithMessage:(EM_ChatMessageModel *)message;

@end
```
```
- (NSString *)alertBodyWithMessage:(EM_ChatMessageModel *)message{
    //只有消息里有自定义扩展消息的时候才会调用该方法
    NSString *alertBody = @"根据消息内容显示的alertBody";
    return alertBody;
}
```

环信的部分API仍然需要自己去调用，比如初始化及登录方法。具体其他的环信API调用请参考环信的[官方文档](http://www.easemob.com/docs/ios/IOSSDKPrepare/)。
<h4 id = "2.4.2">权限</h4>
为了功能的正常时候，我们需要以下权限
- **位置**    *在Info.plist中添加NSLocationAlwaysUsageDescription(始终允许使用)、NSLocationWhenInUseUsageDescription(使用期间允许使用)*
- **照片**
- **麦克风**
- **相机**
- **通知**    *注册APNS*
- **后台应用程序刷新**  *在Info.plist中添加Required background modes 并添加App plays audio or streams audio/video using AirPlay、App downloads content in response to push notifications和App provides Voice over IP services三项；或者在Capabilities中打开Background Models，勾选Audio and Airplay、Voice over IP和Remote notifications*
- **使用蜂窝移动数据**
- **iOS9下的网络访问**    *iOS9引入了新特性```App Transport Security (ATS)```，新特性要求App内访问的网络必须使用```HTTPS```协议。所以可能会导致网络访问不通，在```Info.plist```中添加```NSAppTransportSecurity类型Dictionary```，
并在```NSAppTransportSecurity```下添加```NSAllowsArbitraryLoads类型Boolean```，值设为```YES```，便可。*
<h3 id = "2.5">会话列表</h3>
```
EM_ChatListController
```
你只需要简单集成，并实现相应的代理就可以了。
```
#import "EM+ChatBaseController.h"
@class EMConversation;
@class EM_ChatMessageModel;
@class EM_ChatOpposite;
@class EM_ConversationCell;

@protocol EM_ChatListControllerDisplay;
@protocol EM_ChatListControllerDataSource;
@protocol EM_ChatListControllerDelegate;

@interface EM_ChatListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatListControllerDisplay> display;

@property (nonatomic, weak) id<EM_ChatListControllerDataSource> dataSource;

@property (nonatomic, weak) id<EM_ChatListControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

@property (nonatomic, strong, readonly) UISearchBar *searchBar;


/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  开始下拉刷新
 */
- (void)startRefresh;

/**
 *  结束下拉刷新，这里回自动调用reloadData方法
 */
- (void)endRefresh;

@end

@protocol EM_ChatListControllerDisplay <NSObject>

@optional

/**
 *  会话显示的简短信息
 *  如果是编辑状态则默认显示编辑内容，此时不会调用该代理;
 *  如果是语音通讯或者视频通讯则默认显示通话结果，此时不会调用该代理;
 *  如果返回nil或者未实现，则默认显示最新一条消息的内容
 *  @param opposite 聊天对象，好友，群，聊天室
 *  @param message  聊天的最新一条消息，有可能为空
 */
- (NSMutableAttributedString *)introForConversationWithOpposite:(EM_ChatOpposite *)opposite message:(EM_ChatMessageModel *)message;

@end

@protocol EM_ChatListControllerDataSource <NSObject>

@required

- (NSInteger)numberOfRows;

- (EMConversation *)dataForRowAtIndex:(NSInteger)index;

@optional

@end

@protocol EM_ChatListControllerDelegate <NSObject>

@required

@optional

/**
 *  是否显示搜索
 *  默认YES,如果返回NO,则searchController和searchBar未nil
 *
 *  @return 
 */
- (BOOL)shouldShowSearchBar;

/**
 *  会话列表的行高
 *
 *  @return 
 */
- (CGFloat)heightForConversationRow;

/**
 *  选中某一会话，可以跳转继承自EM_ChatController的聊天界面
 *
 *  @param conversation
 */
- (void)didSelectedWithConversation:(EMConversation *)conversation;

/**
 *  删除某一会话
 *  只有在设置了dataSource才会调用
 *  @param conversation 
 */
- (void)didDeletedWithConversation:(EMConversation *)conversation;

/**
 *  开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  结束下拉刷新
 */
- (void)didEndRefresh;

@end
```
如果你不设置dataSource，则默认加载环信的会话列表。搜索功能暂时不可用，请在```shouldShowSearchBar```返回```NO```。
![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/chat_list.png?raw=true)

<h3 id = "2.6">好友列表</h3>
```
EM_BuddyListController
```
好友列表，只需要简单继承就可以了。
```
#import "EM+ChatBaseController.h"
@class EM_ChatOpposite;

@protocol EM_ChatBuddyListControllerDataSource;
@protocol EM_ChatBuddyListControllerDelegate;

@interface EM_BuddyListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatBuddyListControllerDataSource> dataSource;
@property (nonatomic, weak) id<EM_ChatBuddyListControllerDelegate> delegate;

- (void)reloadTagBar;

- (void)reloadOppositeList;

- (void)reloadOppositeGroupWithIndex:(NSInteger)index;

- (void)startRefresh;

- (void)endRefresh;

@end

@protocol EM_ChatBuddyListControllerDataSource <NSObject>

@required

/**
 *  是否显示搜索
 *
 *  @return 默认NO
 */
- (BOOL)shouldShowSearchBar;

/**
 *  是否显示Tag
 *
 *  @return 默认NO
 */
- (BOOL)shouldShowTagBar;

/**
 *  每个分组有多少个好友，群或者讨论组
 *
 *  @param groupIndex 组索引
 *
 *  @return 默认0
 */
- (NSInteger)numberOfRowsAtGroupIndex:(NSInteger)groupIndex;

/**
 *  好友，群或者讨论组数据
 *
 *  @param rowIndex
 *  @param groupIndex 组索引
 *
 *  @return 默认nil
 */
- (EM_ChatOpposite *)dataForRow:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex;

@optional

/**
 *  搜索结果数量
 *
 *  @return 默认0
 */
- (NSInteger)numberOfRowsForSearch;

/**
 *  搜索数据
 *
 *  @param index
 *
 *  @return
 */
- (EM_ChatOpposite *)dataForSearchRowAtIndex:(NSInteger)index;

/**
 *  tag数据量
 *
 *  @return 默认0
 */
- (NSInteger)numberOfTags;

/**
 *  tag是否需要被选中
 *  在初始化加载时，默认第一个允许selected的tag为YES
 *  @return 默认NO
 */
- (BOOL)shouldSelectedForTagAtIndex:(NSInteger)index;

/**
 *  tag标题
 *
 *  @param index tag索引
 *
 *  @return 默认nil
 */
- (NSString *)titleForTagAtIndex:(NSInteger)index;

/**
 *  tag字体
 *
 *  @param index
 *
 *  @return
 */
- (UIFont *)fontForTagAtIndex:(NSInteger)index;

/**
 *  tag图标
 *
 *  @param index
 *
 *  @return
 */
- (NSString *)iconForTagAtIndex:(NSInteger)index;

/**
 *  角标
 *
 *  @param index
 *
 *  @return 
 */
- (NSInteger)badgeForTagAtIndex:(NSInteger)index;

/**
 *  是否显示分组管理菜单
 *
 *  @return
 */
- (BOOL)shouldShowGroupManage;

/**
 *  好友分组数量
 *
 *  @return 默认1
 */
- (NSInteger)numberOfGroups;

/**
 *  是否展开分组
 *  只有numberOfGroups大于1时设置才有效
 *  @param groupIndex
 *
 *  @return 默认YES
 */
- (BOOL)shouldExpandForGroupAtIndex:(NSInteger)index;

/**
 *  分组标题
 *
 *  @param index
 *
 *  @return 默认 "我的好友"
 */
- (NSString *)titleForGroupAtIndex:(NSInteger)index;

@end

@protocol EM_ChatBuddyListControllerDelegate <NSObject>

@required

@optional

/**
 *  搜索
 *
 *  @param searchString
 *
 *  @return 是否加载搜索结果
 */
- (BOOL)shouldReloadSearchForSearchString:(NSString *)searchString;

/**
 *  tag被点击
 *
 *  @param index
 */
- (void)didSelectedForTagAtIndex:(NSInteger)index;

/**
 *  分组管理被点击
 *
 *  @param groupIndex 
 */
- (void)didSelectedForGroupManageAtIndex:(NSInteger)groupIndex;

/**
 *  分组被点击
 *
 *  @param groupIndex
 */
- (void)didSelectedForGroupAtIndex:(NSInteger)groupIndex;

/**
 *  好友，群或者讨论组被点击，可以跳转继承自EM_ChatController的聊天界面
 *
 *  @param opposite
 */
- (void)didSelectedWithOpposite:(EM_ChatOpposite *)opposite;

/**
 *  已经开始开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  已经结束下拉刷新
 */
- (void)didEndRefresh;

@end
```
如果不设置dataSource，则默认加载环信的好友关系。
![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/buddy_list.png?raw=true)

<h3 id = "2.7">聊天界面</h3>
直接继承使用即可，有很多功能和UI还在完善中。
<h4 id = "2.7.1">配置文件</h4>
在使用聊天界面之前，请先了解```EM_ChatUIConfig```和```EM_ChatMessageUIConfig```两个配置文件的相关属性。配置文件只在初始化显示聊天界面的时候使用，在聊天界面显示后再修改无效。
```
EM_ChatUIConfig
```
聊天界面的配置
```
#import <Foundation/Foundation.h>
@class EM_ChatMessageUIConfig;

//聊天界面中大部分文字的默认大小
#define RES_FONT_DEFAUT (14)

//文字输入工具栏图标字体的默认大小
#define RES_TOOL_ICO_FONT (30)

//动作图标的默认大小
#define RES_ACTION_ICO_FONT (30)

//属性
/**
 *  属性名称
 */
extern NSString * const kAttributeName;

/**
 *  标题
 */
extern NSString * const kAttributeTitle;

/**
 *  一般图片
 */
extern NSString * const kAttributeNormalImage;

/**
 *  高亮图片
 */
extern NSString * const kAttributeHighlightImage;

/**
 *  背景色,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBackgroundColor;

/**
 *  边框颜色,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBorderColor;

/**
 *  边框宽度,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBorderWidth;

/**
 *  圆角,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeCornerRadius;

/**
 *  图标字体,设置此属性后,kAttributeNormalImage和kAttributeHighlightImage会失效
 */
extern NSString * const kAttributeFont;

/**
 *  图标
 */
extern NSString * const kAttributeText;

/**
 *  图标一般颜色
 */
extern NSString * const kAttributeNormalColor;

/**
 *  图标高亮颜色
 */
extern NSString * const kAttributeHighlightColor;

//工具栏按钮Name
extern NSString * const kButtonNameRecord;
extern NSString * const kButtonNameKeyboard;
extern NSString * const kButtonNameEmoji;
extern NSString * const kButtonNameAction;

//动作Name
extern NSString * const kActionNameImage;
extern NSString * const kActionNameCamera;
extern NSString * const kActionNameVoice;
extern NSString * const kActionNameVideo;
extern NSString * const kActionNameLocation;
extern NSString * const kActionNameFile;

@interface EM_ChatUIConfig : NSObject

@property (nonatomic, assign) BOOL hiddenOfRecord;
@property (nonatomic, assign) BOOL hiddenOfEmoji;
@property (nonatomic, strong) EM_ChatMessageUIConfig *messageConfig;

@property (nonatomic, strong, readonly) NSMutableDictionary *actionDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary *toolDictionary;
@property (nonatomic, strong, readonly) NSMutableArray *keyArray;


+ (instancetype)defaultConfig;

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeToolWithName:(NSString *)name;
- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName;

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeActionWithName:(NSString *)name;
- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName;
```

```
EM_ChatMessageUIConfig
```
显示消息cell的配置
```
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EM_AVATAR_STYLE) {
    EM_AVATAR_STYLE_SQUARE = 0,//方形
    EM_AVATAR_STYLE_CIRCULAR//圆形
};

@interface EM_ChatMessageUIConfig : NSObject

//cell
/**
 *  头像风格,默认EM_AVATAR_STYLE_CIRCULAR
 */
@property (nonatomic, assign) EM_AVATAR_STYLE avatarStyle;

/**
 *  头像的大小
 */
@property (nonatomic, assign) float messageAvatarSize;

/**
 *  消息左右的padding
 */
@property (nonatomic, assign) float messagePadding;

/**
 *  消息顶部padding,即消息和消息之间的空隙
 */
@property (nonatomic, assign) float messageTopPadding;

/**
 *  消息时间显示高度
 */
@property (nonatomic, assign) float messageTimeLabelHeight;

/**
 *  昵称显示高度
 */
@property (nonatomic, assign) float messageNameLabelHeight;

/**
 *  菊花高度
 */
@property (nonatomic, assign) float messageIndicatorSize;

/**
 *  气泡尾巴宽度
 */
@property (nonatomic, assign) float messageTailWithd;

//bubble
/**
 *  气泡padding
 */
@property (nonatomic, assign) float bubblePadding;

/**
 *  气泡文字大小
 */
@property (nonatomic, assign) float bubbleTextFont;

/**
 *  文字行间距
 */
@property (nonatomic, assign) float bubbleTextLineSpacing;

/**
 *  气泡圆角大小
 */
@property (nonatomic, assign) float bubbleCornerRadius;

@property (nonatomic, assign) float bodyTextPadding;

@property (nonatomic, assign) float bodyImagePadding;

@property (nonatomic, assign) float bodyVideoPadding;

@property (nonatomic, assign) float bodyVoicePadding;

@property (nonatomic, assign) float bodyLocationPadding;

@property (nonatomic, assign) float bodyFilePadding;

+ (instancetype)defaultConfig;

@end
```

<h4 id = "2.7.2">聊天Controller</h4>
```
EM_ChatController
```
聊天界面的Controller，直接继承并自定义自己的部分。

```
#import "EM+ChatBaseController.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"
@class EM_ChatOpposite;
@class EM_ChatUser;

@protocol EM_ChatControllerDelegate;

@interface EM_ChatController : EM_ChatBaseController

/**
 *  会话对象
 */
@property (nonatomic, strong, readonly) EMConversation *conversation;

@property (nonatomic, strong, readonly) EM_ChatOpposite *opposite;
@property (nonatomic, strong, readonly) EM_ChatUser *user;
@property (nonatomic,weak) id<EM_ChatControllerDelegate> delegate;

- (instancetype)initWithOpposite:(EM_ChatOpposite *)opposite;

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType;

- (instancetype)initWithConversation:(EMConversation *)conversation;

- (void)sendMessage:(EM_ChatMessageModel *)message;

- (void)dismissKeyboard;

- (void)dismissMoreTool;

@end

@protocol EM_ChatControllerDelegate <NSObject>

@required

@optional

/**
 *  配置
 *
 *  @return
 */
- (EM_ChatUIConfig *)configForChat;

/**
 *  为要发送的消息添加扩展
 *
 *  @param body 消息内容
 *
 *  @return
 */
- (void)extendForMessage:(EM_ChatMessageModel *)message;

/**
 *  是否允许发送消息
 *
 *  @param body 消息内容
 *  @param type 消息类型
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)shouldSendMessage:(id)body messageType:(MessageBodyType)type;

/**
 *  自定义动作监听
 *
 *  @param name 自定义动作
 */
- (void)didActionSelectedWithName:(NSString *)name;

/**
 *  头像点击事件
 *
 *  @param chatter 
 *  @param isOwn 是否是自己的头像
 */
- (void)didAvatarTapWithChatter:(NSString *)chatter isOwn:(BOOL)isOwn;

/**
 *  扩展View被点击
 *
 *  @param userInfo  数据
 *  @param indexPath
 */
- (void)didExtendTapWithUserInfo:(NSDictionary *)userInfo;

/**
 *  扩展View菜单被选择
 *
 *  @param userInfo  数据
 *  @param indexPath 
 */
- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo;

@end
```
继承
```
#import "EM+ChatController.h"

@interface CustomChatController : EM_ChatController

@end
```
```
#import "CustomChatController.h"
#import "CustomExtend.h"

@interface CustomChatController ()<EM_ChatControllerDelegate>

@end

@implementation CustomChatController

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType{
    self = [super initWithChatter:chatter conversationType:conversationType];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#define mark - EM_ChatControllerDelegate
- (EM_ChatUIConfig *)configForChat{
    return [EM_ChatUIConfig defaultConfig];
}

- (void)extendForMessage:(EM_ChatMessageModel *)message{
    message.messageExtend.extendAttributes = @{@"a":@"不显示的属性"};
}

- (void)didActionSelectedWithName:(NSString *)name{
    
}

- (void)didAvatarTapWithChatter:(NSString *)chatter isOwn:(BOOL)isOwn{
    //点击了头像
}

- (void)didExtendTapWithUserInfo:(NSDictionary *)userInfo{
    //点击了扩展View
}

- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo{
    
}

@end
```

聊天界面会涉及的其他三个Controller，```EM_LocationController```(定位，用于获取定位信息)、```EM_ExplorerController```（文件浏览器，获取要发送的文件）、```EM_CallController```(语音、视频即时通讯)

<h3 id = "2.8">自定义扩展</h3>
**自定义扩展**是通过环信```EMMessage```的扩展属性```ext```来实现的，我只是对自定义扩展进行了规范，可以让大家方便扩展的同时实现了自己的一些功能。为了统一iOS和Android，在声明属性的时候请尽量只声明NSString、BOOL和数字类型，因为Android只支持这些类型。
```
EM_ChatMessageExtendBody
```
所有的自定义扩展必须继承```EM_ChatMessageExtendBody```，且必须重写```+ (NSString *)identifierForExtend```、```+ (Class)viewForClass```、```+ (BOOL)showBody```和```+ (BOOL)showExtend```方法。同时在初始化```EaseMobUIClient```的时候注册自定义消息，```[[EaseMobUIClient sharedInstance] registerExtendClass:[UserCustomExtend class]];```。

发送自定义扩展消息，在聊天界面中调用```- (void)sendMessage:(EM_ChatMessageModel *)message```方法。
```
UserCustomExtend *custom = [[UserCustomExtend alloc]init];
EM_ChatMessageModel *customMessage = [EM_ChatMessageModel fromText:@"" conversation:self.conversation];
customMessage.messageExtend.extendBody = custom;
[self sendMessage:customMessage];
```

```
#import "JSONModel.h"

#define kIdentifierForExtend                    (@"kIdentifierForExtend")

@interface EM_ChatMessageExtendBody : JSONModel

/**
 *  扩展标示，iOS和Android两个平台必须一致
 *
 *  @return
 */
+ (NSString *)identifierForExtend;

/**
 *  扩展对应的显示View
 *
 *  @return
 */
+ (Class)viewForClass;

/**
 *  是否显示消息体
 *
 *  @return
 */
+ (BOOL)showBody;

/**
 *  是否显示扩展体
 *
 *  @return 
 */
+ (BOOL)showExtend;

@end
```
扩展绑定的```View```必须继承自```EM_ChatMessageExtendView```，同时必须重写```+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config```方法。
```
#import "EM+ChatMessageExtendView.h"

@interface UserCustomExtendView : EM_ChatMessageExtendView

@end
```
```
#import "UserCustomExtendView.h"
#import "EM+ChatMessageModel.h"
#import "UserCustomExtend.h"

@implementation UserCustomExtendView{
    UILabel *label;
}

+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    return CGSizeMake(80, 30);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    label.frame = self.bounds;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    UserCustomExtend *extend = (UserCustomExtend *)message.messageExtend.extendBody;
    label.text = extend.extendProperty;
}
```
EM_ChatMessageExtendView本身没有太多可以实现的（后期会加入更多的实现），和```EM_ChatMessageBodyView```（用来显示消息内容的View）一样都是继承自```EM_ChatMessageContent```。你可以重写```EM_ChatMessageContent```的一些方法来实现更多的功能。
```
EM_ChatMessageContent
```
```
#import <UIKit/UIKit.h>
@class EM_ChatMessageModel;
@class EM_ChatMessageUIConfig;

/**
 *  userInfo key
 */
extern NSString * const kHandleActionName;
extern NSString * const kHandleActionMessage;
extern NSString * const kHandleActionValue;
extern NSString * const kHandleActionView;
extern NSString * const kHandleActionFrom;

/**
 *  from
 */
extern NSString * const HANDLE_FROM_CONTENT;
extern NSString * const HANDLE_FROM_BODY;
extern NSString * const HANDLE_FROM_EXTEND;

/**
 *  action
 */
extern NSString * const HANDLE_ACTION_URL;
extern NSString * const HANDLE_ACTION_PHONE;
extern NSString * const HANDLE_ACTION_TEXT;
extern NSString * const HANDLE_ACTION_IMAGE;
extern NSString * const HANDLE_ACTION_VOICE;
extern NSString * const HANDLE_ACTION_VIDEO;
extern NSString * const HANDLE_ACTION_LOCATION;
extern NSString * const HANDLE_ACTION_FILE;
extern NSString * const HANDEL_ACTION_BODY;
extern NSString * const HANDLE_ACTION_EXTEND;
extern NSString * const HANDLE_ACTION_UNKNOWN;

/**
 *  menu action
 */
extern NSString * const MENU_ACTION_DELETE;//删除
extern NSString * const MENU_ACTION_COPY;//复制
extern NSString * const MENU_ACTION_FACE;//添加到表情
extern NSString * const MENU_ACTION_DOWNLOAD;//下载
extern NSString * const MENU_ACTION_COLLECT;//收藏
extern NSString * const MENU_ACTION_FORWARD;//转发

@protocol EM_ChatMessageContentDelegate;

@interface EM_ChatMessageContent : UIView

@property (nonatomic, weak) id<EM_ChatMessageContentDelegate> delegate;
@property (nonatomic,strong) EM_ChatMessageModel *message;

/**
 *  是否需要点击,默认YES
 */
@property (nonatomic, assign) BOOL needTap;

/**
 *  是否需要长按,默认YES
 */
@property (nonatomic, assign) BOOL needLongPress;

@property (nonatomic, strong) EM_ChatMessageUIConfig *config;


+ (CGSize )sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config;

//overwrite

/**
 *  返回菜单项,请使用super
 *
 *  @return 菜单项
 */
- (NSMutableArray *)menuItems;

/**
 *  返回点击、长按传入的数据,请使用super
 *
 *  @return 数据
 */
- (NSMutableDictionary *)userInfo;

@end

@protocol EM_ChatMessageContentDelegate <NSObject>

@required

@optional

/**
 *  点击监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentTap:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  长按监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentLongPress:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  菜单选项监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentMenu:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

@end
```
```
#import "CustomExtendView.h"

@implementation CustomExtendView{
    UILabel *label;
}

+ (CGSize)sizeForContentWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    return CGSizeMake(80, 30);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    label.frame = self.bounds;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    UserCustomExtend *extend = (UserCustomExtend *)message.extend;
    label.text = extend.extendProperty;
}

- (NSMutableArray *)menuItems{
    NSMutableArray *items = [super menuItems];
    UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copy:)];
    [items addObject:copyItem];
    return items;
}

- (void)copy:(id)sender{
    //这里执行你的代码，或者调用代理中的方法。如果你使用代理，EM_ChatControllerDelegate中的- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo方法会被调用。
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];//
        [userInfo setObject:MENU_ACTION_COPY forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_COPY withUserInfo:userInfo];
    }
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    //在userInfo中放入自己的一些数据，点击和长按都触发
    [userInfo setObject:@"Click" forKey:kHandleActionName];
    return userInfo;
}

@end
```
<h3 id = "2.9">UI</h3>

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/action_view.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/emoji_view.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/voice_input.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/voice_play.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/call_in.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/call_voice.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/call_video.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/wifi_upload.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/web_wifi_upload.png?raw=true)

<h2 id = "3">期望</h2>
- **合作：**如果你 也是环信的使用者，可以一起和我开发这个项目，让更多的环信开发者方便使用
- **联系：**请联系我 QQ：940549652
