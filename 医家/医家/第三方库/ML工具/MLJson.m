//
//  MLJson.m
//  医家
//
//  Created by 洛耳 on 16/1/18.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLJson.h"
#import "EaseMob.h"
#import "EMConversation.h"//会话对象

@implementation MLJson
+(NSString *)json:(NSDictionary *)dict{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (void)fuckSetIsAutoLoginEnabled {
    //Swift中chatManager是readonly，会让他的属性IsAutoLoginEnabled也变成readonly
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
}
@end
