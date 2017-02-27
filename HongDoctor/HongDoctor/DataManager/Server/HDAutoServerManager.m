//
//  HDAudoServerManager.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDAutoServerManager.h"
#import "HDLoginManager.h"
#import "AppDelegate.h"
#import "HDSendMsgResponseEntity.h"
#import "HDSendMessageEntity.h"
#import "HDMessageManager.h"
#import "HDUserEntity.h"
#import "HDLoginManager.h"
#import "HDGetIntervalMessageManager.h"

static HDAutoServerManager *manager = nil;

@implementation HDAutoServerManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HDAutoServerManager alloc] init];
    });
    return manager;
}

- (void)autoLogin:(void (^) (BOOL succeed, NSString *message))completeBlock
{
    NSString *phone = [HDLocalDataManager getLoginNumber];
    NSString *password = [HDLocalDataManager getLoginPassword];
    [HDLoginManager requestLoginWithPhone:phone password:password completeBlock:^(BOOL succeed, NSString *message) {
        if (succeed) {
            [self autoGetBeginData:nil];
            completeBlock(YES, nil);
        } else {
            completeBlock(NO, message);
        }
    }];
}

- (void)autoGetBeginData:(void (^) (BOOL succeed))completeBlock
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    [HDLoginManager requestGetBeginData:userEntity.userGuid completeBlock:^(BOOL success, NSString *message) {
        if (success) {
            [[HDGetIntervalMessageManager shareInstance] startGetMessage];
        } else if ([message isEqualToString:@"backLogin"]) {
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app goLoginVC];
            ShowText(@"密码错误，请重新登录", 2);
        } else {
            [self autoGetBeginData:completeBlock];
        }
    }];
}

- (void)autoSendText:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock
{
    [HDMessageManager requestSendMessage:entity completeBlock:completeBlock];
}

- (void)autoSendImage:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock
{
    [HDMessageManager requestSendImage:entity completeBlock:completeBlock];
}

- (void)autoSendAudio:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock
{
    [HDMessageManager requestSendAudio:entity completeBlock:completeBlock];
}

- (void)autoSendVideo:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock
{
    [HDMessageManager requestSendVideo:entity completeBlock:completeBlock];
}

- (void)autoSendLocation:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock
{
    [HDMessageManager requestSendLocation:entity completeBlock:completeBlock];
}

@end
