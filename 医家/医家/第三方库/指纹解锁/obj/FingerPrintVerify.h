//
//  FingerPrintVerify.h
//  demo
//
//  Created by shaw on 15/5/8.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FingerPrintVerify : NSObject
/**
 *  判断是否是Model
 */
@property (nonatomic)BOOL isNAV;

//指纹验证
-(void)verifyFingerprint;

@end
