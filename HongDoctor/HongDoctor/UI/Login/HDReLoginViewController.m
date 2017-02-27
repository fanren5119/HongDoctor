
//
//  HDReLoginViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDReLoginViewController.h"
#import "HDLoginManager.h"
#import "HDGetIntervalMessageManager.h"
#import "AppDelegate.h"
#import "HDAutoServerManager.h"

@interface HDReLoginViewController ()

@end

@implementation HDReLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)respondsToReLoginButton:(id)sender
{
    [self.view removeFromSuperview];
    NSString *phone = [HDLocalDataManager getLoginNumber];
    NSString *password = [HDLocalDataManager getLoginPassword];
    [HDLoginManager requestLoginWithPhone:phone password:password completeBlock:^(BOOL succeed, NSString *message) {
        if (succeed) {
            [[HDAutoServerManager shareManager] autoGetBeginData:nil];
        } else {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app goLoginVC];
        }
    }];
}

- (IBAction)respondsToLoginButton:(id)sender
{
    [self.view removeFromSuperview];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goLoginVC];
}

- (IBAction)respondsToLogoutButton:(id)sender
{
    exit(0);
}

@end
