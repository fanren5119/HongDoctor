//
//  NewsRelativeTimeFormat.h
//  testTime
//
//  Created by 孙俊 on 13-11-25.
//  Copyright (c) 2013年 YiPin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsRelativeTimeFormat : NSObject

+ (NSString *)FromNowdateStringWithDate:(NSDate *)targetDate;

@end
