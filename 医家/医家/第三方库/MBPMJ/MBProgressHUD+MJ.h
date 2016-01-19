//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
/**
 *  显示正确
 *
 *  @param success 文字
 *  @param view    那个view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**
 *  显示错误
 *
 *  @param error 文字
 *  @param view  那个View
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  显示正确
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  显示错误
 */
+ (void)showError:(NSString *)error;
/**
 *  显示文字
 *
 *  @param message 加载的文字
 *
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**
 *  关闭HUD
 *
 *  @param view 那个View
 */
+ (void)hideHUDForView:(UIView *)view;
/**
 *  关闭HUD
 */
+ (void)hideHUD;

@end
