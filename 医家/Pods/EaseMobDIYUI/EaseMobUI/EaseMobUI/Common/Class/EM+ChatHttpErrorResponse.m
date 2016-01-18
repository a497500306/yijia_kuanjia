//
//  EM+ChatHttpErrorResponse.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/19.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatHttpErrorResponse.h"

@interface EM_ChatHttpErrorResponse()

@property (nonatomic, strong) NSData *errorMsg;

@end

@implementation EM_ChatHttpErrorResponse{
    NSMutableDictionary *header;
}

- (instancetype)initWithErrorCode:(int)httpErrorCode errorMessage:(NSString *)msg{
    self = [super initWithErrorCode:httpErrorCode];
    if (self) {
        _errorMessage = msg;
        if (_errorMessage) {
            _errorMsg = [_errorMessage dataUsingEncoding:NSUTF8StringEncoding];
        }
        header = [[NSMutableDictionary alloc]init];
        [header setObject:@"text/*;charset=utf-8" forKey:@"Content-Type"];
    }
    return self;
}

- (void)setHeaderField:(id)value key:(NSString *)key{
    if (value && key) {
        [header setObject:value forKey:key];
    }
}

- (NSData*) readDataOfLength:(NSUInteger)length {
    return _errorMsg;
}

- (BOOL)isChunked{
    return YES;
}

- (NSDictionary *)httpHeaders{
    return header;
}

@end