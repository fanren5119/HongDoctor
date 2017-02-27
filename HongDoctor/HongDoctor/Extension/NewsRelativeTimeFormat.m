//
//  NewsRelativeTimeFormat.m
//  testTime
//
//  Created by 孙俊 on 13-11-25.
//  Copyright (c) 2013年 YiPin. All rights reserved.
//

#define SimplifiedChinese_just          @"刚刚"
#define SimplifiedChinese_hoursAgo      @"%d小时前"
#define SimplifiedChinese_minutesAgo    @"%d分钟前"
#define SimplifiedChinese_yyyyMMdd      @"yyyy年M月d日"
#define SimplifiedChinese_MMddHHmm      @"M月d日 HH:mm"
#define simplifiedChinese_yesterday     @"昨天 HH:mm"
#import "NewsRelativeTimeFormat.h"


@implementation NewsRelativeTimeFormat

+ (NSString *)FromNowdateStringWithDate:(NSDate *)targetDate
{
    if (targetDate == nil)
    {
        return @"";
    }
    NewsRelativeTimeFormat *newsRelativeTimeFormat = [[NewsRelativeTimeFormat alloc] init];
    
    NSString *yesterday = simplifiedChinese_yesterday;
    NSString *today = @"HH:mm";
//    NSString *hoursAgo = SimplifiedChinese_hoursAgo;
//    NSString *minutesAgo = SimplifiedChinese_minutesAgo;
//    NSString *just = SimplifiedChinese_just;
    NSString *yyyyMMdd = SimplifiedChinese_yyyyMMdd;
    NSString *MMddHHmm = SimplifiedChinese_MMddHHmm;
    
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSInteger nowDay = [nowComponents day];
    NSInteger nowMonth= [nowComponents month];
    NSInteger nowYear= [nowComponents year];
    
    NSDateComponents *targetComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:targetDate];
    
    NSInteger targetDay = [targetComponents day];
    NSInteger targetMonth = [targetComponents month];
    NSInteger targetYear = [targetComponents year];
//    NSInteger targetHour = [targetComponents hour];
    
    int secondsDiff = [targetDate timeIntervalSinceNow] * -1;
    int minutesDiff = secondsDiff / 60;
    int hoursDiff = minutesDiff / 60;
    
    if (secondsDiff < 0)
    {
        if (nowYear == targetYear)
        {
            NSString *dateString = [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:MMddHHmm];
            return dateString;
        }
        else
        {
            NSString *dateString = [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:yyyyMMdd];
            return dateString;
        }
        
    }
    
    NSDate * yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:yesterdayDate];
    
    NSInteger yesterdayDay = [yesterdayComponents day];
    NSInteger yesterdayMonth= [yesterdayComponents month];
    NSInteger yesterdayYear= [yesterdayComponents year];
    
    if ((yesterdayYear == targetYear) && (yesterdayMonth == targetMonth) && (yesterdayDay == targetDay))
    {
        NSString *dateString = nil;
        
        if ([yesterday isEqualToString:@"yesterday"]) {
            
            NSString *timeString = [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:@"HH:mm"];
            dateString = [NSString stringWithFormat:@"yesterday%@", timeString];
            
        }else {
            
            dateString = [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:yesterday];
        }
        return dateString;
    }
    
    if (nowYear == targetYear)
    {
        if ((nowMonth == targetMonth) && (nowDay == targetDay))
        {
            return [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:today];
//            if (hoursDiff >= 1) {
//                
//                return [NSString stringWithFormat:hoursAgo, hoursDiff];
//            }
//            
//            if (minutesDiff >= 1) {
//                
//                return [NSString stringWithFormat:minutesAgo, minutesDiff];
//            }
//            
//            return just;
        }
        else
        {
            NSString *dateString = [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:MMddHHmm];
            return dateString;
        }
    }
    else
    {
        NSString *dateString = [newsRelativeTimeFormat dateStringWithDate:targetDate Formate:yyyyMMdd];
        return dateString;
    }
    
    return nil;
}

- (NSString *)dateStringWithDate:(NSDate *)date Formate:(NSString *)formateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formateString;
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

@end
