//
//  HDGetIntervalMessageManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGetIntervalMessageManager.h"
#import "HDMessageManager.h"
#import "HDUserEntity.h"
#import "HDLoginManager.h"
#import "AppDelegate.h"

#define  TimerInterval      2
static HDGetIntervalMessageManager *manager = nil;

@interface HDGetIntervalMessageManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *userGuid;

@end

@implementation HDGetIntervalMessageManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HDGetIntervalMessageManager alloc] init];
    });
    return manager;
}

- (void)startGetMessage
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopGetMessage
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)respondsToTimer
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    [HDLoginManager requestGetIntervalBeginData:userEntity.userGuid completeBlock:^(BOOL succeed, NSArray *iconsArray) {
        if (succeed == NO && iconsArray.count == 0) {
            [self stopGetMessage];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HDAccessTokenExpixred" object:nil];
        } else {
        }
    }];
}


- (NSString *)userGuid
{
    if (_userGuid == nil) {
        HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
        _userGuid = userEntity.userGuid;
    }
    return _userGuid;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
