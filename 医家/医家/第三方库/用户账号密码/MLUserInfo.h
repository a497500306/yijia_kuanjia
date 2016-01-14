//
//  MLUserInfo.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/9.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MLUserInfo : NSObject

singleton_interface(MLUserInfo);
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user;//用户名
/**
 *  token
 */
@property (nonatomic, copy) NSString *token;//用户
/**
 *  密码
 */
@property (nonatomic, copy) NSString *pwd;//密码
/**
 *  是否开启指纹解锁
 */
@property (nonatomic, copy) NSString *zwjs;//指纹解锁
/**
 *  字体大小
 */
@property (nonatomic, copy) NSString *ztdx;//字体大小

/**
 *  登录的状态 NO:登录/YES:注销
 */
@property (nonatomic, assign) BOOL  loginStatus;


@property (nonatomic, copy) NSString *registerUser;//注册的用户名
@property (nonatomic, copy) NSString *registerPwd;//注册的密码


/**
 *  从沙盒里获取用户数据
 */
-(void)loadUserInfoFromSanbox;

/**
 *  保存用户数据到沙盒
 
 */
-(void)saveUserInfoToSanbox;

/**
 *  UTF8
 */
+(NSURL *)UTF8:(NSString *)str;
@end
