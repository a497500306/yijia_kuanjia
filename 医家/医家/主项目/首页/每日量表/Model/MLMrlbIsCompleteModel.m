//
//  MLMrlbIsCompleteModel.m
//  医家
//
//  Created by 洛耳 on 16/1/20.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import "MLMrlbIsCompleteModel.h"

@implementation MLMrlbIsCompleteModel
+(NSDictionary *)statementForNSArrayProperties{
    return @{@"completes":NSStringFromClass([NSString class]),@"textIDs":NSStringFromClass([NSString class])};
}

@end
