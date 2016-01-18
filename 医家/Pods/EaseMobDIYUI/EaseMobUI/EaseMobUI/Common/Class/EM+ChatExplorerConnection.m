//
//  EM+ChatExplorerConnection.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/18.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatExplorerConnection.h"

#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"
#import "NSString+Base64.h"

#import "MultipartFormDataParser.h"
#import "MultipartMessageHeaderField.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPFileResponse.h"
#import "EM+ChatHttpErrorResponse.h"

#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"

#ifdef DEBUG
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;
#else
static const int httpLogLevel = HTTP_LOG_LEVEL_OFF;
#endif

@interface EM_ChatExplorerConnection()<MultipartFormDataParserDelegate>
@property (nonatomic, strong)  NSMutableDictionary *responseDic;
@end

@implementation EM_ChatExplorerConnection{
    MultipartFormDataParser *parser;
    NSFileHandle    *storeFile;
    
}

NSString * const kEMNotificationFileUpload = @"kEMNotificationFileUpload";
NSString * const kEMNotificationFileDelete = @"kEMNotificationFileDelete";
NSString * const kEMNotificationFileDownload = @"kEMNotificationFileDownload";

- (NSMutableDictionary *)responseDic{
    if (!_responseDic) {
        _responseDic = [[NSMutableDictionary alloc]init];
    }
    return _responseDic;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path{
    HTTPLogTrace();
    if ([method isEqualToString:@"POST"]){
        return YES;
    }else if ([method isEqualToString:@"DELETE"]) {
        return YES;
    }else if ([method isEqualToString:@"PUT"]) {
        return YES;
    }else{
        return [super supportsMethod:method atPath:path];
    }
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path{
    HTTPLogTrace();
    if([method isEqualToString:@"POST"] && [path isEqualToString:@"/files"]) {
        NSString* contentType = [request headerField:@"Content-Type"];
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        if(NSNotFound == paramsSeparator) {
            return NO;
        }
        if(paramsSeparator >= contentType.length - 1) {
            return NO;
        }
        NSString* type = [contentType substringToIndex:paramsSeparator];
        if(![type isEqualToString:@"multipart/form-data"] ) {
            return NO;
        }
        NSArray* params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        for( NSString* param in params ) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if( (NSNotFound == paramsSeparator) || paramsSeparator >= param.length - 1 ) {
                continue;
            }
            NSString* paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator-1)];
            NSString* paramValue = [param substringFromIndex:paramsSeparator+1];
            
            if( [paramName isEqualToString:@"boundary"] ) {
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        if(![request headerField:@"boundary"])  {
            return NO;
        }
        return YES;
    }
    if ([method isEqualToString:@"DELETE"]) {
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path{
    HTTPLogTrace();
    if ([method isEqualToString:@"GET"]) {
        if ([path isEqualToString:@"/"]) {
            //请求index.html
            
            NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [appInfo objectForKey:@"CFBundleDisplayName"];
            
            NSMutableDictionary *replaceData = [[NSMutableDictionary alloc]init];
            [replaceData setObject:[NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"wifi.server_web_title"],appName] forKey:@"title"];
            
            NSArray *folderArray = [EM_ChatFileUtils folderArray];
            for (NSDictionary *folderDic in folderArray) {
                NSString *folderName = folderDic[kFolderName];
                NSMutableString *replaceHtml = [[NSMutableString alloc]init];
                NSArray *files = [EM_ChatFileUtils filesInfoWithType:folderName];
                
                for (NSDictionary *fileInfo in files) {
                    NSString *fileName = [fileInfo objectForKey:kFileName];
                    NSDictionary *fileAttributes = [fileInfo objectForKey:kFileAttributes];
                    long long fileSize = [fileAttributes fileSize];
                    
                    NSString *html = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td><a href=\"%@\" download><i class=\"fa fa-cloud-download\"></i></a><a href=\"javascript:;\"><i class=\"fa fa-trash-o\" data=\"%@\"></i></a></td></tr>",fileName,[EM_ChatFileUtils stringFileSize:fileSize],[NSString stringWithFormat:@"files/%@/%@",folderName,fileName],fileName];
                    [replaceHtml appendString:html];
                }
                
                [replaceData setObject:replaceHtml forKey:folderName];
            }
            
            NSString* indexPagePath = [[config documentRoot] stringByAppendingPathComponent:@"index.html"];
            return [[HTTPDynamicFileResponse alloc] initWithFilePath:indexPagePath forConnection:self separator:@"%" replacementDictionary:replaceData];
        }else if([path hasPrefix:@"/files/"]){
            NSString *filePath = [[path substringFromIndex:7] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            return [[HTTPFileResponse alloc]initWithFilePath:[NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,filePath] forConnection:self];
        }
    }else if([method isEqualToString:@"POST"]){
        if ([path isEqualToString:@"/files"]) {
            NSDictionary *headers = [request allHeaderFields];
            NSString *fileName = [headers objectForKey:@"filename"];
            if (fileName && fileName.length > 0) {
                fileName = [fileName fromBase64WithNative];
                EM_ChatHttpErrorResponse *response = [self.responseDic objectForKey:fileName];
                if (response) {
                    [self.responseDic removeObjectForKey:fileName];
                    return response;
                }
            }
            return [[HTTPErrorResponse alloc]initWithErrorCode:200];
            
        }
    }else if([method isEqualToString:@"PUT"]){
        
    }else if([method isEqualToString:@"DELETE"]){
        if([path hasPrefix:@"/files"]){

            NSString *filePath = [[path substringFromIndex:7] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *fileName = [filePath lastPathComponent];
            NSRange nameRange = [filePath rangeOfString:fileName];
            NSString *fileType = [filePath substringToIndex:nameRange.location - 1];
            NSError *error;
            BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,filePath] error:&error];
            if (delete && !error) {
                NSDictionary *userInfo = @{kFileName:fileName,kFileType:fileType};
                [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationFileDelete object:nil userInfo:userInfo];
                
                return [[EM_ChatHttpErrorResponse alloc]initWithErrorCode:200 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_delete_success"]];
            }else{
                return [[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_delete_failure"],error]];
            }
        }
    }else if([method isEqualToString:@"HEAD"]){
        
    }
    return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength{
    HTTPLogTrace();
    NSString* boundary = [request headerField:@"boundary"];
    parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];
    parser.delegate = self;
}

- (void)processBodyData:(NSData *)postDataChunk{
    HTTPLogTrace();
    [parser appendData:postDataChunk];
}

#pragma mark - MultipartFormDataParserDelegate
- (void)processStartOfPartWithHeader:(MultipartMessageHeader *)header{
    NSDictionary *headers = [request allHeaderFields];
    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
    
    NSString *fileName = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    if (!fileName || fileName.length == 0) {
        return;
    }
    
    //获取文件大小
    long long fileSize  = [[headers objectForKey:@"Content-Length"] longLongValue];
    if (fileSize > 1024 * 1024 * 10) {
        [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_big"]] forKey:fileName];
        return;
    }
    
    NSString *fileType = [headers objectForKey:@"filetype"];
    NSString* uploadDirPath = [NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,fileType];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",uploadDirPath,fileName];
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        storeFile = nil;
        [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_exist"]] forKey:fileName];
    }else {
        HTTPLogVerbose(@"Saving file to %@", filePath);
        
        if([[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
            storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
            [self postNotificationUpload:fileName state:kFileUploadStart];
        }else{
            HTTPLogError(@"Could not create file at path: %@", filePath);
            [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_failure"]] forKey:fileName];
        }
    }
}

- (void)processContent:(NSData *)data WithHeader:(MultipartMessageHeader *)header{
    if(storeFile) {
        [storeFile writeData:data];
        MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
        NSString *fileName = [[disposition.params objectForKey:@"filename"] lastPathComponent];
        [self postNotificationUpload:fileName state:kFileUploadProcess];
    }
}

- (void)processEndOfPartWithHeader:(MultipartMessageHeader *)header{
    if (storeFile) {
        [storeFile closeFile];
        MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
        NSString *fileName = [[disposition.params objectForKey:@"filename"] lastPathComponent];
        [self postNotificationUpload:fileName state:kFileUploadComplete];
        [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:200 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_success"]] forKey:fileName];
        
    }
    storeFile = nil;
}

- (void)processPreambleData:(NSData *)data{
    
}

- (void)processEpilogueData:(NSData *)data{
    
}

- (void)postNotificationUpload:(NSString *)fileName state:(NSString *)state{
    NSDictionary *headers = [request allHeaderFields];
    NSString *fileType = [headers objectForKey:@"filetype"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",kChatFileFolderPath,fileType,fileName];
    long long fileSize = [[headers objectForKey:@"Content-Length"] longLongValue];
    
    NSDictionary *userInfo = @{
                               kFileName:fileName,
                               kFileType:fileType,
                               kFilePath:filePath,
                               kFileAttributes:[[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil],
                               kFileState:state,
                               kFileSize:@(fileSize)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationFileUpload object:nil userInfo:userInfo];
}

@end