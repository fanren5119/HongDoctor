//
//  HDSettingViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDSettingViewController.h"
#import "AppDelegate.h"
#import "HDLoginManager.h"
#import "HDUserEntity.h"
#import "HDRecordSettingView.h"
#import "HDCoreDataManager.h"
#import "HDGetIntervalMessageManager.h"

@interface HDSettingViewController () <HDRecordSettingViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel        *videoRecordLength;
@property (weak, nonatomic) IBOutlet UILabel        *audioRecordLength;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (nonatomic, strong) HDRecordSettingView   *settingView;
@property (nonatomic, strong) NSArray               *videoRecordLengthArray;
@property (nonatomic, strong) NSArray               *audioRecordLengthArray;
@property (nonatomic, assign) BOOL                  isSettingVideo;

@end

@implementation HDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupRecordView];
    [self setupNotificationSwitch];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"设置";
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupRecordView
{
    self.settingView = [[HDRecordSettingView alloc] initWithFrame:self.view.bounds];
    self.settingView.delegate = self;
}

- (void)setupNotificationSwitch
{
    BOOL isOn = [HDLocalDataManager getNotificationSwitch];
    [self.notificationSwitch setOn:isOn];
}


#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)respondsToLogoutButton:(id)sender
{
    [[HDGetIntervalMessageManager shareInstance] stopGetMessage];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app goLoginVC];
    [HDLocalDataManager saveTokenId:@""];
    [HDLocalDataManager saveUserWithString:@""];
}

- (IBAction)respondsToSetVideoRecordLength:(id)sender
{
    self.isSettingVideo = YES;
    [self.settingView showViewWithData:self.videoRecordLengthArray];
}

- (IBAction)respondsToSetAudioRecordLength:(id)sender
{
    self.isSettingVideo = NO;
    [self.settingView showViewWithData:self.audioRecordLengthArray];
}

- (IBAction)respondsToNotifcationSwitch:(UISwitch *)sender
{
    BOOL isOn = sender.isOn;
    [HDLocalDataManager saveNotificationSwitch:isOn];
}

- (IBAction)respondsToClearCacheButton:(id)sender
{
    [HDCoreDataManager clearCacheData];
}


#pragma -mark recordSetView delegate

- (void)didSelectItem:(NSInteger)index
{
    if (self.isSettingVideo) {
        NSNumber *length = self.videoRecordLengthArray[index];
        self.videoRecordLength.text = [NSString stringWithFormat:@"%@s",length];
        [HDLocalDataManager saveVideoRecordLength:length];
    } else {
        NSNumber *length = self.audioRecordLengthArray[index];
        self.audioRecordLength.text = [NSString stringWithFormat:@"%@s",length];
        [HDLocalDataManager saveAudioRecordLength:length];
    }
}


- (void)loadData
{
    self.videoRecordLengthArray = @[@(5), @(10), @(15)];
    self.audioRecordLengthArray = @[@(20), @(40), @(60)];
}

@end
