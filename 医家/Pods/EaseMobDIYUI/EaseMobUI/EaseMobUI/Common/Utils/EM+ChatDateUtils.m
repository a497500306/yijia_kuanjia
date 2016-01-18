//
//  EM+ChatDateUtils.m
//  EaseMobUI
//
//  Created by 袁静 on 15/7/27.
//  Copyright (c) 2015年 yjing. All rights reserved.
//

#import "EM+ChatDateUtils.h"
#import "EM+ChatResourcesUtils.h"

@implementation EM_ChatDateUtils

+ (NSString *)stringFormatterMessageDateFromTimeInterval:(double)timeInterval{
    return [self stringFormatterMessageDateFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

+ (NSString *)stringFormatterMessageDateFromDate:(NSDate *)date{
    NSString *dateString;

    NSDate *currentDate = [NSDate date];//date必然小于currentDate
    
    NSDateComponents *currentComponents = [self dateComponentsFromDate:currentDate];
    NSDateComponents *dateComponents = [self dateComponentsFromDate:date];
    
    if(currentComponents.year > dateComponents.year){
        dateString = [self dateConvertToString:date formatter:@"yyyy-MM-dd HH:mm"];
    }else{
        //currentComponents.year 必然等于 dateComponents.year
        
        if(currentComponents.month > dateComponents.month){
            dateString = [self dateConvertToString:date formatter:@"MM-dd HH:mm"];
        }else{
            //currentComponents.month 必然等于 dateComponents.month
            NSInteger currentDay = currentComponents.day;
            NSInteger day = dateComponents.day;
            if(currentDay - day <= 7){
                if (currentDay - day == 0) {
                    dateString = [self dateConvertToString:date formatter:@"HH:mm"];
                }else if (currentDay - day == 1) {
                    dateString = [NSString stringWithFormat:@"%@ %@",[EM_ChatResourcesUtils stringWithName:@"common.yesterday"],[self dateConvertToString:date formatter:@"HH:mm"]];
                }else if(currentDay - day == 2){
                    dateString = [NSString stringWithFormat:@"%@ %@",[EM_ChatResourcesUtils stringWithName:@"common.theDayBeforeYesterday"],[self dateConvertToString:date formatter:@"HH:mm"]];
                }else{
                    dateString = [NSString stringWithFormat:@"%@ %@",[self weekStringForDayFromDate:date],[self dateConvertToString:date formatter:@"HH:mm"]];
                }
            }else{
                dateString = [self dateConvertToString:date formatter:@"MM-dd HH:mm"];
            }
        }
    }
    
    return dateString;
}

+ (NSDate *)stringConvertToDate:(NSString *)dateString formatter:(NSString *)formatter{
    if (!dateString) {return nil;}
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale systemLocale]];
    }
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)dateConvertToString:(NSDate *)date formatter:(NSString *)formatter{
    if (!date) {return nil;}
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale systemLocale]];
    }
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit;
    return [calendar components:unitFlags fromDate:date];
}

+ (NSInteger)getYearFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].year;
}

+ (NSInteger)getMonthFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].month;
}

+ (NSInteger)getDayFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].day;
}

+ (NSInteger)getHourFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].hour;
}

+ (NSInteger)getMinuteFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].minute;
}

+ (NSInteger)getSecondFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].second;
}

+ (NSInteger)getWeekOfYearFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].weekOfYear;
}

+ (NSInteger)getWeekOfMonthFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].weekOfMonth;
}

+ (NSInteger)getDayOfWeekFromDate:(NSDate *)date{
    return [self dateComponentsFromDate:date].weekday;
}

+ (NSString *)weekStringForDayFromDate:(NSDate *)date{
    NSInteger week = [self getDayOfWeekFromDate:date];
    NSString * weekStr;
    if(week == 1){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.sunday"];
    }else if (week == 2){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.monday"];
    }else if (week == 3){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.tuesday"];
    }else if (week == 4){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.wednesday"];
    }else if (week == 5){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.thursday"];
    }else if (week == 6){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.friday"];
    }else if (week == 7){
        weekStr = [EM_ChatResourcesUtils stringWithName:@"common.saturday"];
    }
    
    return weekStr;
}

+ (BOOL)isDateInCurrentWeek:(NSDate *)date {
    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    
    BOOL success = [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
    if(!success){return NO;}
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs = [start timeIntervalSinceReferenceDate];
    
    return dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs + extends);
}

@end