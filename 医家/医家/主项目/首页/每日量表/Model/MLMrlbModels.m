//
//  MLMrlbModels.m
//  医家
//
//  Created by 洛耳 on 16/1/15.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLMrlbModels.h"

@implementation MLMrlbModels
+(NSDictionary *)statementForNSArrayProperties{
    return @{@"option":NSStringFromClass([NSString class])};
}
@end
