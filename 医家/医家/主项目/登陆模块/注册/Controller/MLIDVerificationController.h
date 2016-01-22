//
//  MLIDVerificationController.h
//  医家
//
//  Created by 洛耳 on 16/1/22.
//  Copyright © 2016年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLIDVerificationController : UIViewController
/**
 *  注册的手机号
 */
@property (nonatomic , copy)NSString *shouji;
/**
 *  注册的密码(MD5加密)
 */
@property (nonatomic , copy)NSString *mima;
@end
