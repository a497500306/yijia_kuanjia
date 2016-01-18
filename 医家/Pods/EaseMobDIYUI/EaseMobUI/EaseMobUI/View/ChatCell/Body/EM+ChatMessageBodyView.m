//
//  EM+ChatMessageBaseBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/17.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBodyView.h"

#import "EM+ChatResourcesUtils.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendCall.h"
#import "EM_ChatMessage.h"

#import "EM+Common.h"
#import "UIColor+Hex.h"

@implementation EM_ChatMessageBodyView

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSMutableArray *)menuItems{
    NSMutableArray *menuItems = [super menuItems];
    id<IEMMessageBody> messageBody = self.message.messageBody;
    if (![self.message.messageExtend.identifier isEqualToString:kIdentifierForCall]) {
        if (messageBody.messageBodyType == eMessageBodyType_Text) {
            //复制
            UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.copy"] action:@selector(copyEMMessage:)];
            [menuItems addObject:copyItem];
        }else if (messageBody.messageBodyType == eMessageBodyType_Image){
            //收藏到表情
            //暂时屏蔽收藏到表情
//            UIMenuItem *collectFaceItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.collect_face"] action:@selector(collectEMMessageFace:)];
//            [menuItems addObject:collectFaceItem];
        }else if (messageBody.messageBodyType == eMessageBodyType_File){
            //下载,如果未下载
            //暂时屏蔽下载
//            EMFileMessageBody *fileBody = (EMFileMessageBody *)messageBody;
//            if (fileBody.attachmentDownloadStatus == EMAttachmentNotStarted) {
//                UIMenuItem *downloadItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.download"] action:@selector(downloadEMMessageFile:)];
//                [menuItems addObject:downloadItem];
//            }
        }
        
        if (messageBody.messageBodyType != eMessageBodyType_Video) {
            //收藏
            NSString *conllect = [EM_ChatResourcesUtils stringWithName:@"common.collect"];
            if (self.message.messageSign && self.message.messageSign.collected) {
                conllect = [EM_ChatResourcesUtils stringWithName:@"common.collect_cancel"];
            }
            UIMenuItem *collectItem = [[UIMenuItem alloc]initWithTitle:conllect action:@selector(collectEMMessage:)];
            [menuItems addObject:collectItem];
        }
        
        if (messageBody.messageBodyType != eMessageBodyType_Voice) {
            //转发
            //暂时屏蔽转发
//            UIMenuItem *forwardItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.forward"] action:@selector(forwardEMMessage:)];
//            [menuItems addObject:forwardItem];
            
            //转发多条
        }
    }
    
    //删除
    UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.delete"] action:@selector(deleteEMMessage:)];
    [menuItems addObject:deleteItem];
    
    return menuItems;
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_FROM_BODY forKey:kHandleActionFrom];
    [userInfo setObject:HANDEL_ACTION_BODY forKey:kHandleActionName];
    return userInfo;
}

//复制
- (void)copyEMMessage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:MENU_ACTION_COPY forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_COPY withUserInfo:userInfo];
    }
}

//添加到表情
- (void)collectEMMessageFace:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:MENU_ACTION_FACE forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_FACE withUserInfo:userInfo];
    }
}

//下载
- (void)downloadEMMessageFile:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:MENU_ACTION_DOWNLOAD forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_DOWNLOAD withUserInfo:userInfo];
    }
}

//收藏
- (void)collectEMMessage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:MENU_ACTION_COLLECT forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_COLLECT withUserInfo:userInfo];
    }
}

//转发
- (void)forwardEMMessage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:MENU_ACTION_FORWARD forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_FORWARD withUserInfo:userInfo];
    }
}

//删除
- (void)deleteEMMessage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];
        [userInfo setObject:MENU_ACTION_DELETE forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_DELETE withUserInfo:userInfo];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (!self.message) {
        return NO;
    }
    
    if (action == @selector(deleteEMMessage:)) {
        return YES;
    }
    
    if (action == @selector(collectEMMessage:)) {
        return YES;
    }
    
    id<IEMMessageBody> messageBody = [self.message.message.messageBodies firstObject];
    
    if (messageBody.messageBodyType == eMessageBodyType_Text && action == @selector(copyEMMessage:)) {
        return YES;
    }
    
    if (messageBody.messageBodyType == eMessageBodyType_Image && action == @selector(collectEMMessageFace:)){
        return YES;
    }
    if (messageBody.messageBodyType == eMessageBodyType_File && action == @selector(downloadEMMessageFile:)){
        return YES;
    }
    
    if (messageBody.messageBodyType != eMessageBodyType_Video && action == @selector(collectEMMessage:)) {
        return YES;
    }
    
    if (messageBody.messageBodyType != eMessageBodyType_Voice && action == @selector(forwardEMMessage:)) {
        return YES;
    }
    return NO;
}

@end