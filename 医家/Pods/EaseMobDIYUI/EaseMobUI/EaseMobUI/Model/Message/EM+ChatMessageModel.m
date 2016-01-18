//
//  EM+ChatMessageModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendBody.h"

#import "EM+ChatMessageBodyView.h"
#import "EM+ChatMessageTextBody.h"
#import "EM+ChatMessageImageBody.h"
#import "EM+ChatMessageVideoBody.h"
#import "EM+ChatMessageLocationBody.h"
#import "EM+ChatMessageVoiceBody.h"
#import "EM+ChatMessageFileBody.h"

#import "EM+ChatMessageUIConfig.h"

#import "EaseMobUIClient.h"

@interface EM_ChatMessageModel()

@end

@implementation EM_ChatMessageModel

+ (instancetype)fromEMMessage:(EMMessage *)message{
    if (message) {
        EM_ChatMessageModel *model = [[EM_ChatMessageModel alloc]init];
        model.message = message;
        if(message.ext){
            model.messageExtend = [[EM_ChatMessageExtend alloc]initWithDictionary:message.ext error:nil];
            NSDictionary *extendBody = message.ext[@"extendBody"];
            NSString *identifier  = message.ext[kIdentifier];
            Class cls = [[EaseMobUIClient sharedInstance] classForExtendWithIdentifier:identifier];
            if (cls) {
                model.messageExtend.extendBody = [[cls alloc]initWithDictionary:extendBody error:nil];
            }else{
                model.messageExtend.extendBody = [[EM_ChatMessageExtendBody alloc]initWithDictionary:extendBody error:nil];
            }
            if (!model.messageExtend.showBody && !model.messageExtend.showExtend) {
                model.messageExtend.showBody = YES;
                model.messageExtend.showExtend = NO;
            }
        }else{
            model.messageExtend = [[EM_ChatMessageExtend alloc]init];
        }
        return model;
    }
    return nil;
}

+ (instancetype)fromText:(NSString *)text conversation:(EMConversation *)conversation{
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    return [EM_ChatMessageModel fromBody:textBody conversation:conversation];
}

+ (instancetype)fromVoice:(NSString *)path name:(NSString *)name duration:(NSInteger)duration conversation:(EMConversation *)conversation{
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:path displayName:name];
    chatVoice.duration = duration;
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    return [EM_ChatMessageModel fromBody:voiceBody conversation:conversation];
}

+ (instancetype)fromImage:(UIImage *)image conversation:(EMConversation *)conversation{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:[NSString stringWithFormat:@"%d%d%@",(int)[NSDate date].timeIntervalSince1970,arc4random() % 100000,@".jpg"]];
    EMImageMessageBody *imageBody = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    return [EM_ChatMessageModel fromBody:imageBody conversation:conversation];
}

+ (instancetype)fromVideo:(NSString *)path conversation:(EMConversation *)conversation{
    EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:path displayName:[NSString stringWithFormat:@"%d%d%@",(int)[NSDate date].timeIntervalSince1970,arc4random() % 100000,@".mp4"]];
    EMVideoMessageBody *videoBody = [[EMVideoMessageBody alloc]initWithChatObject:chatVideo];
    return [EM_ChatMessageModel fromBody:videoBody conversation:conversation];
}

+ (instancetype)fromLatitude:(double)latitude longitude:(double)longitude address:(NSString *)address conversation:(EMConversation *)conversation{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
    EMLocationMessageBody *locationBody = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    return [EM_ChatMessageModel fromBody:locationBody conversation:conversation];
}

+ (instancetype)fromFile:(NSString *)path name:(NSString *)name conversation:(EMConversation *)conversation{
    EMChatFile *chatFile = [[EMChatFile alloc]initWithFile:path displayName:name];
    EMFileMessageBody *fileBody = [[EMFileMessageBody alloc]initWithChatObject:chatFile];
    return [EM_ChatMessageModel fromBody:fileBody conversation:conversation];
}

+ (instancetype)fromBody:(id<IEMMessageBody>)body conversation:(EMConversation *)conversation{
    EMMessage *retureMsg = [[EMMessage alloc]initWithReceiver:conversation.chatter bodies:[NSArray arrayWithObject:body]];
    switch (conversation.conversationType) {
        case eConversationTypeGroupChat:{
            retureMsg.messageType = eMessageTypeGroupChat;
        }
            break;
        case eConversationTypeChatRoom:{
            retureMsg.messageType = eMessageTypeChatRoom;
        }
            break;
        default:{
            retureMsg.messageType = eMessageTypeChat;
        }
            break;
    }
    
    EM_ChatMessageModel *model = [[EM_ChatMessageModel alloc]init];
    model.message = retureMsg;
    return model;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.messageExtend = [[EM_ChatMessageExtend alloc]init];
    }
    return self;
}

- (id<IEMMessageBody>)messageBody{
    if (self.message) {
        return [self.message.messageBodies firstObject];
    }
    return nil;
}

- (BOOL)updateExt{
    BOOL update = YES;
    if (self.messageExtend) {
        self.message.ext = [self.messageExtend toDictionary];
        update = [self.message updateMessageExtToDB];
    }
    return update;
}

- (NSString *)reuseIdentifier{
    NSMutableString *reuseIdentifier = [[NSMutableString alloc]init];
    if (self.message) {
        [reuseIdentifier appendString:NSStringFromClass([self.messageBody class])];
    }
    
    if (self.messageExtend) {
        [reuseIdentifier appendString:self.messageExtend.identifier];
    }
    
    return reuseIdentifier;
}

- (Class)classForBodyView{
    Class classForBuildView;
    switch (self.messageBody.messageBodyType) {
        case eMessageBodyType_Text:{
            classForBuildView = [EM_ChatMessageTextBody class];
        }
            break;
        case eMessageBodyType_Image:{
            classForBuildView = [EM_ChatMessageImageBody class];
        }
            break;
        case eMessageBodyType_Video:{
            classForBuildView = [EM_ChatMessageVideoBody class];
        }
            break;
        case eMessageBodyType_Location:{
            classForBuildView = [EM_ChatMessageLocationBody class];
        }
            break;
        case eMessageBodyType_Voice:{
            classForBuildView = [EM_ChatMessageVoiceBody class];
        }
            break;
        case eMessageBodyType_File:{
            classForBuildView = [EM_ChatMessageFileBody class];
        }
            break;
        default:{
            classForBuildView = [EM_ChatMessageBodyView class];
        }
            break;
    }
    return classForBuildView;
}

- (BOOL)isEqual:(id)object{
    
    BOOL isEqual = NO;
    
    EM_ChatMessageModel *model = object;
    if (model.message && self.message) {
        isEqual = [model.message isEqual:self.message];
        if (!isEqual) {
            isEqual = [model.message.messageId isEqualToString:self.message.messageId];
        }
    }
    
    return isEqual;
}

@end