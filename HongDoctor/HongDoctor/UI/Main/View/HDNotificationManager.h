//
//  HDNotificationManager.h
//  NotificationTest
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDNotificationManager : NSObject

+ (instancetype)shareManager;

- (void)sendLocationWithMessage:(NSString *)message groupGuid:(NSString *)groupGuid;

@end
