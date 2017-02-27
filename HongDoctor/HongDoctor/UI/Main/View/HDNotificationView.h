//
//  HDNotificationView.h
//  NotificationTest
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDNotificationView : UIView

- (void)setMessage:(NSString *)message groupGuid:(NSString *)groupGuid;
- (void)show;

@end
