//
//  EM+ChatDateUtils.h
//  EaseMobUI
//
//  Created by 袁静 on 15/7/27.
//  Copyright (c) 2015年 yjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EM_ChatDateUtils : NSObject

+ (NSString *)stringFormatterMessageDateFromTimeInterval:(double)timeInterval;

+ (NSString *)stringFormatterMessageDateFromDate:(NSDate *)ndate;

+ (NSDate *)stringConvertToDate:(NSString *)dateString formatter:(NSString *)formatter;

+ (NSString *)dateConvertToString:(NSDate *)date formatter:(NSString *)formatter;

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

+ (NSInteger)getYearFromDate:(NSDate *)date;

+ (NSInteger)getMonthFromDate:(NSDate *)date;

+ (NSInteger)getDayFromDate:(NSDate *)date;

+ (NSInteger)getHourFromDate:(NSDate *)date;

+ (NSInteger)getMinuteFromDate:(NSDate *)date;

+ (NSInteger)getSecondFromDate:(NSDate *)date;

+ (NSInteger)getWeekOfYearFromDate:(NSDate *)date;

+ (NSInteger)getWeekOfMonthFromDate:(NSDate *)date;

+ (NSString *)weekStringForDayFromDate:(NSDate *)date;

+ (BOOL)isDateInCurrentWeek:(NSDate *)date;

@end