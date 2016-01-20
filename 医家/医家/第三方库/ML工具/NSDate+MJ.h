//
//  NSDate+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MJ)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;
/**
 *  是否大于今天
 */
- (BOOL)isDayujintian;
/**
 *  是否大于本月
 */
- (BOOL)isDayubenyue;
/**
 *  是否为本月
 *
 *  @return 哪一个月
 */
- (NSString *)nayiyue;
/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;
/**
 *  返回本月1日
 */
-(NSString *)fanghui1ri;
/**
 *  返回本月最后一日
 */
-(NSString *)zuihou1ri;
/**
 *  string转date
 */
-(NSDate *)strZhuangDate:(NSString *)str;
/**
 *  date转str
 */
-(NSString *)dateZhuangStr;
/**
 *  取出年
 */
-(NSInteger )quchunian;
@end
