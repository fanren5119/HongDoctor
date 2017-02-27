//
//  HDUserViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserViewController.h"
#import "HDUserCellModel.h"
#import "HDUserNormalCell.h"
#import "HDUserHeaderCell.h"
#import "HDUserEntity.h"
#import "HDSettingViewController.h"
#import "HDModifyPasswordViewController.h"
#import "HDUserInfoViewController.h"
#import "HDLocationViewController.h"
#import "HDFeedBackViewController.h"
#import "HDContractManager.h"

@interface HDUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray     *dataSourceArray;

@end

@implementation HDUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"我";
}


#pragma -mark tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataSourceArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataSourceArray[indexPath.section];
    HDUserCellModel *model = array[indexPath.row];
    switch (model.type) {
        case UserHead:
        {
            HDUserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserHeaderCell" forIndexPath:indexPath];
            [cell resetCellWithEntity:model];
            return cell;
        }
            break;
        case UserModifyPsw:
        case UserSetting:
        case UserFeedback:
        case UserSynchContract:
        {
            HDUserNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserNormalCell" forIndexPath:indexPath];
            [cell resetCellWithEntity:model];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataSourceArray[indexPath.section];
    HDUserCellModel *model = array[indexPath.row];
    if (model.type == UserHead) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *array = self.dataSourceArray[indexPath.section];
    HDUserCellModel *model = array[indexPath.row];
    switch (model.type) {
        case UserHead:
        {
            HDUserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserInfoViewController"];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            userInfoVC.backItemTitle = @"我的";
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
            break;
        case UserModifyPsw:
        {
            HDModifyPasswordViewController *modifyPswVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDModifyPasswordViewController"];
            modifyPswVC.hidesBottomBarWhenPushed = YES;
            modifyPswVC.backItemTitle = @"我的";
            [self.navigationController pushViewController:modifyPswVC animated:YES];
        }
            break;
        case UserSetting:
        {
            HDSettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDSettingViewController"];
            settingVC.hidesBottomBarWhenPushed = YES;
            settingVC.backItemTitle = @"我的";
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case UserFeedback:
        {
            HDFeedBackViewController *feedbackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDFeedBackViewController"];
            feedbackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case UserSynchContract:
        {
            HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
            ShowLoading(@"数据加载中...");
            [HDContractManager requestRefreshContract:userEntity.userGuid completeBlock:^(BOOL succeed) {
                RemoveLoading;
                if (succeed) {
                    ShowText(@"通讯录同步成功", 2);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDSynchContractNotification" object:nil];
                } else {
                    ShowText(@"网络请求失败，请稍后重试", 2);
                }
            }];
        }
            break;
        default:
            break;
    }
}


#pragma -mark loadData

- (void)loadData
{
    self.dataSourceArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HDUserCellData" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    for (NSArray *dicArray in array) {
        NSArray *entityArray = [HDUserCellModel serializerWithArray:dicArray];
        [self.dataSourceArray addObject:entityArray];
    }
    
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    
    HDUserCellModel *userHead = self.dataSourceArray[0][0];
    userHead.headImage = userEntity.userHeadURL;
    userHead.title = userEntity.userName;
    
    [self.tableView reloadData];
}
@end
