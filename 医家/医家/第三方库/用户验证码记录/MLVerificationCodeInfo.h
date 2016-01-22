//
//  MLVerificationCodeInfo.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/8/3.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MLVerificationCodeInfo : NSObject
singleton_interface(MLVerificationCodeInfo);
/*
 *  注册验证码
 */
@property (nonatomic ,assign) NSInteger zhucheYanzhenma;
/*
 *  找回密码验证码
 */
@property (nonatomic ,assign) NSInteger zhaohuiYanzhenma;
@end
