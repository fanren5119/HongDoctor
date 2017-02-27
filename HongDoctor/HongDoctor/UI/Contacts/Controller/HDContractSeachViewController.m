//
//  HDContractSeachViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContractSeachViewController.h"
#import "HDContractCell.h"
#import "HDContractEntity.h"
#import "HDCoreDataManager.h"
#import "HDMemberEntity.h"
#import "HDUserEntity.h"
#import "HDContractDetailViewController.h"
#import "HDUserInfoViewController.h"
#import <Realm/Realm.h>

@interface HDContractSeachViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;

@end

@implementation HDContractSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    [self setupNavigator];
    [self setupTableView];
}

- (void)setupNavigator
{
    self.navigationItem.title = @"搜索";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDContractCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDContractCell"];
}

- (void)addGesture
{
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTagGesture)];
    [self.tableView addGestureRecognizer:tagGesture];
}


#pragma -mark responds

- (void)respondsToTagGesture
{
    [self.view endEditing:YES];
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDContractCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDContractCell" forIndexPath:indexPath];
    [cell resetCellWithEntity:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HDContractEntity *contract = self.dataSourceArray[indexPath.row];
    
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    if ([userEntity.userGuid isEqualToString:contract.contractId]) {
        HDUserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserInfoViewController"];
        userInfoVC.hidesBottomBarWhenPushed = YES;
        userInfoVC.backItemTitle = @"搜索";
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else {
        HDContractDetailViewController *contractDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDContractDetailViewController"];
        contractDetailVC.contractGuid = contract.contractId;
        contractDetailVC.hidesBottomBarWhenPushed = YES;
        contractDetailVC.backItemTitle = @"搜索";
        [self.navigationController pushViewController:contractDetailVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma -mark searchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *name = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RLMResults *addressBooks = [HDCoreDataManager getAddressBooksWithName:name outMemberIds:@[]];
    self.dataSourceArray = [NSMutableArray array];
    for (int i = 0; i < addressBooks.count; i ++) {
        HDMemberEntity *obj = [addressBooks objectAtIndex:i];
        HDContractEntity *entity = [[HDContractEntity alloc] init];
        entity.headImageURL = obj.userHeadURL;
        entity.name = obj.userName;
        entity.contractId = obj.userGuid;
        entity.grade = obj.userGrade;
        entity.isSign = ![obj.isCompany boolValue];
        [self.dataSourceArray addObject:entity];
    }
    [self.tableView reloadData];
}

@end
