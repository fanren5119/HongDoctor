//
//  HDNotificationManager.m
//  NotificationTest
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDNotificationManager.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "HDNotificationView.h"
#import "AppDelegate.h"
#import "HDMessageViewController.h"

static HDNotificationManager *manager = nil;

@interface HDNotificationManager () <UNUserNotificationCenterDelegate>

@end

@implementation HDNotificationManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HDNotificationManager alloc] init];
    });
    return manager;
}

- (void)sendLocationWithMessage:(NSString *)message groupGuid:(NSString *)groupGuid
{
    BOOL isOn = [HDLocalDataManager getNotificationSwitch];
    if (isOn == NO) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.integerValue >= 10) {
        [self ios10SendLocationWithMessage:message groupGuid:groupGuid];
    } else {
        [self ios9SendLocationWithMessage:message groupGuid:groupGuid];
    }
}

- (void)ios10SendLocationWithMessage:(NSString *)message groupGuid:(NSString *)groupGuid
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //请求获取通知权限（角标，声音，弹框）
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //获取用户是否同意开启通知
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
    }];
    //第二步：新建通知内容对象
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.body = message;
    content.userInfo = @{@"groupGuid": groupGuid};
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"caodi.m4a"];
    content.sound = sound;
    
    //第四步：创建UNNotificationRequest通知请求对象
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:nil];
    
    //第五步：将通知加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {

    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSString *groupGuid = notification.request.content.userInfo[@"groupGuid"];
    HDNotificationView *view = [[HDNotificationView alloc] initWithFrame:CGRectZero];
    [view setMessage:@"您有一条新信息请注意查收" groupGuid:groupGuid];
    [view show];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    UITabBarController *controller = (UITabBarController *)window.rootViewController;
    UINavigationController *nav = (UINavigationController *)controller.selectedViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HDMessageViewController *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
    [nav pushViewController:messageVC animated:YES];
}

- (void)ios9SendLocationWithMessage:(NSString *)message groupGuid:(NSString *)groupGuid
{
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNote.alertBody = message;
    localNote.hasAction = NO;
    localNote.soundName = @"buyao.wav";
    localNote.userInfo = @{@"groupGuid": groupGuid};
    localNote.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

@end
