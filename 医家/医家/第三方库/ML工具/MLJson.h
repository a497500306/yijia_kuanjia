//
//  MLJson.h
//  医家
//
//  Created by 洛耳 on 16/1/18.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLJson : NSObject
/**
 *  字典转josn
 */
+(NSString *)json:(NSDictionary *)dict;
/**
 *  草拟吗的swift
 */
+ (void)fuckSetIsAutoLoginEnabled;
+ (float)fuckSwiftStringToCGFloct:(NSString *)str;
@end
