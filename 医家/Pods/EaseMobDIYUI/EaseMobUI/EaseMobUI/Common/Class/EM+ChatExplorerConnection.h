//
//  EM+ChatExplorerConnection.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/18.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "HTTPConnection.h"

extern NSString * const kEMNotificationFileUpload;
extern NSString * const kEMNotificationFileDelete;
extern NSString * const kEMNotificationFileDownload;

typedef NS_ENUM(NSInteger, WiFiFileUploadState) {
    WiFiFileUploadStateStart = 0,
    WiFiFileUploadStateProcess,
    WiFiFileUploadStateEnd
};

@interface EM_ChatExplorerConnection : HTTPConnection


@end