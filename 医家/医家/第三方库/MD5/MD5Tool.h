//
//  MD5Helper.h
//  OauthTool
//
//  Created by simon on 12-3-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Tool : NSObject
+ (NSString *)md5:(NSString *)str;
+ (NSString*)md5FromData:(NSString*)path;
@end
