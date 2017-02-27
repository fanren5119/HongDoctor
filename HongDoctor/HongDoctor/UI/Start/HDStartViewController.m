//
//  HDStartViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDStartViewController.h"
#import "HDStartManager.h"
#import "HDLocalDataManager.h"
#import "HDStartEntity.h"
#import "UIImageView+WebCache.h"
#import "HDLoginViewController.h"
#import "AppDelegate.h"
#import "HDAutoServerManager.h"

@interface HDStartViewController ()

@property (nonatomic, strong) HDStartEntity *entity;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation HDStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI
{
    NSString *imageURL = [HDLocalDataManager getStartImageURL];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

- (void)loadData
{
    NSInteger startInterval = [HDLocalDataManager getStartInterval];
    [HDStartManager requsetToStart:^(HDStartEntity *entity, BOOL successed) {
        if (successed) {
            if (entity == nil) {
                NSString *tokenId = [HDLocalDataManager getTokenId];
                if (tokenId == nil) {
                    [self performSelector:@selector(goLogin) withObject:nil afterDelay:startInterval];
                } else {
                    [self performSelector:@selector(goMain) withObject:nil afterDelay:startInterval];
                }
            } else {
                self.entity = entity;
                [HDLocalDataManager saveStartTitle:entity.title];
                [HDLocalDataManager saveStartImageURL:entity.imageURL];
                [HDLocalDataManager saveStartFailURL:entity.failURL];
                [HDLocalDataManager saveRegisterURL:entity.registerURL];
                [HDLocalDataManager saveFindPasswordURL:entity.findPasswordURL];
                [[HDDownloadImageManager shareManager] addDownloadUrl:entity.failURL];
                
                [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:entity.imageURL]];
                [self performSelector:@selector(changeVC) withObject:nil afterDelay: 0];
            }
        } else {
            [self performSelector:@selector(goLogin) withObject:nil afterDelay:startInterval];
            ShowText(@"请求失败，请检查网络连接状态", 2);
        }
    }];
}

- (void)goLogin
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goLoginVC];
}

- (void)goMain
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goMainVC];
}

- (void)changeVC
{
    NSString *tokenId = [HDLocalDataManager getTokenId];
    if ([tokenId isEqualToString:@""]) {
        [self goLogin];
        return;
    }
    [[HDAutoServerManager shareManager] autoLogin:^(BOOL succeed, NSString *message) {
        if (succeed) {
            [self goMain];
        } else {
            [self goLogin];
            ShowText(@"网络连接失败，请检查网络状态", 2);
        }
    }];
}

@end
