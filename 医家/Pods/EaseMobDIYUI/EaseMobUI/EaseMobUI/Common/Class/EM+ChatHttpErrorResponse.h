//
//  EM+ChatHttpErrorResponse.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/19.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "HTTPErrorResponse.h"

@interface EM_ChatHttpErrorResponse : HTTPErrorResponse

@property (nonatomic, copy, readonly) NSString *errorMessage;

- (instancetype)initWithErrorCode:(int)httpErrorCode errorMessage:(NSString *)msg;
- (void)setHeaderField:(id)value key:(NSString *)key;

@end