//
//  HDContactsViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContactsViewController.h"
#import "HDCoreDataManager.h"
#import "HDMemberEntity.h"
#import "HDContractEntity.h"
#import "HDContractCell.h"
#import "HDContractDepartmentCell.h"
#import "HDMemberDepartmentEntity.h"
#import "HDContractEntityTransform.h"
#import "HDContractHeaderView.h"
#import "HDCreateGroupViewController.h"
#import "HDContractSeachViewController.h"
#import "HLBarButtonItem.h"
#import "HDUserEntity.h"
#import "HDUserInfoViewController.h"
#import "HDContractDetailViewController.h"
#import <Realm/Realm.h>
#import "HDContractManager.h"

@interface HDContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (nonatomic, assign) BOOL                      isLocal;
@property (nonatomic, assign) BOOL                      isShowSelectView;
@property (nonatomic, strong) UIView                    *customTitleView;

@property (nonatomic, strong) NSArray                   *localDepartmentArray;
@property (nonatomic, strong) NSDictionary              *localContentDictionary;

@property (nonatomic, strong) NSArray                   *remotDepartmentArray;
@property (nonatomic, strong) NSDictionary              *remotContentDictionary;
@property (nonatomic, strong) NSMutableArray            *dataSourceArray;

@end

@implementation HDContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self registerNotification];
    [self loadLocalContract];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.customTitleView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTitleView removeFromSuperview];
}


- (void)setupUI
{
    [self setupNavigator];
    [self setupRightItem];
}

- (void)setupNavigator
{
    [self setupTitleView];
    [self setupTableView];
}

- (void)setupTitleView
{
    self.customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"本地", @"云端"]];
    segment.frame = CGRectMake(0, 0, 100, 30);
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(respondsToSegmentValueChange:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    [self.customTitleView addSubview:segment];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 50, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = @"通讯录";
    titleLabel.textColor = [UIColor whiteColor];
    [self.customTitleView addSubview:titleLabel];
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    self.customTitleView.center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
}

- (void)setupRightItem
{
    UIBarButtonItem *searchItem = [[HLBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Main_search"] target:self action:@selector(respondsToSearhButton)];
    self.navigationItem.rightBarButtonItem = searchItem;
}


- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDContractCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDContractCell"];
    
    UINib *departmentNib = [UINib nibWithNibName:@"HDContractDepartmentCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:departmentNib forCellReuseIdentifier:@"HDContractDepartmentCell"];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToSynchContractNotification) name:@"HDSynchContractNotification" object:nil];
}

#pragma -mark responds

- (void)respondsToSearhButton
{
    HDContractSeachViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDContractSeachViewController"];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.backItemTitle = @"通讯录";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)respondsToAddButton
{
    HDCreateGroupViewController *createGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDCreateGroupViewController"];
    createGroupVC.isCreateGroup = YES;
    createGroupVC.hidesBottomBarWhenPushed = YES;
    createGroupVC.backItemTitle = @"通讯录";
    [self.navigationController pushViewController:createGroupVC animated:YES];
}

- (void)respondsToRefreshItem
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    [HDContractManager requestRefreshContract:userEntity.userGuid completeBlock:^(BOOL succeed) {
        if (succeed) {
            [self selectorToSynchContractNotification];
        }
    }];
}

- (void)respondsToSegmentValueChange:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.isLocal = YES;
        [self loadLocalContract];
    } else {
        self.isLocal = NO;
        [self loadRemotContract];
    }
}

- (void)selectorToSynchContractNotification
{
    if (self.isLocal) {
        [self loadLocalContract];
    } else {
        [self loadRemotContract];
    }
}

#pragma -mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDContractBaseEntity *entity = self.dataSourceArray[indexPath.row];
    if (entity.cellType == ContractCell) {
        HDContractCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDContractCell" forIndexPath:indexPath];
        [cell resetCellWithEntity:entity];
        return cell;
    } else {
        HDContractDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDContractDepartmentCell"];
        [cell resetCellWithEntity:entity];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDContractBaseEntity *entity = self.dataSourceArray[indexPath.row];
    if (entity.cellType == ContractCell) {
        return 64;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HDContractBaseEntity *entity = self.dataSourceArray[indexPath.row];
    if (entity.cellType == ContractCell) {
        [self didSelectMemberCell:(HDContractEntity *)entity];
    } else {
        if (entity.isSelect) {
            [self deleteSubDataWithEntity: entity];
        } else {
            HDMemberDepartmentEntity *departmentEntity = (HDMemberDepartmentEntity *)entity;
            [self addMemberDataWithEntity:departmentEntity];
            [self addSubDataWithEntity:departmentEntity];
        }
        entity.isSelect = !entity.isSelect;
        [self.tableView reloadData];
    }
}

- (void)didSelectMemberCell:(HDContractEntity *)contract
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    if ([userEntity.userGuid isEqualToString:contract.contractId]) {
        HDUserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserInfoViewController"];
        userInfoVC.backItemTitle = @"通讯录";
        userInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else {
        HDContractDetailViewController *contractDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDContractDetailViewController"];
        contractDetailVC.contractGuid = contract.contractId;
        contractDetailVC.hidesBottomBarWhenPushed = YES;
        contractDetailVC.backItemTitle = @"通讯录";
        [self.navigationController pushViewController:contractDetailVC animated:YES];
    }
}

- (void)deleteSubDataWithEntity:(HDContractBaseEntity *)entity
{
    if (entity.cellType == ContractCell) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (HDContractBaseEntity *department in self.dataSourceArray) {
        if ([department.parentOrganization isEqualToString:entity.organization]) {
            department.isSelect = NO;
            [array addObject:department];
        }
    }
    
    for (HDContractBaseEntity *department in array) {
        [self deleteSubDataWithEntity:department];
    }
    
    [self.dataSourceArray removeObjectsInArray:array];
}

- (void)addSubDataWithEntity:(HDMemberDepartmentEntity *)entity
{
    NSMutableArray *array = [NSMutableArray array];
    for (HDMemberDepartmentEntity *department in self.currentDepartments) {
        if ([department.parentOrganization isEqualToString:entity.organization]) {
            [array addObject:department];
        }
    }
    
    NSInteger index = [self.dataSourceArray indexOfObject:entity];
    for (int i = 0; i < array.count; i ++) {
        HDMemberDepartmentEntity *entity = array[array.count - 1 - i];
        [self.dataSourceArray insertObject:entity atIndex:index + 1];
    }
}


- (void)addMemberDataWithEntity:(HDMemberDepartmentEntity *)entity
{
    NSArray *array = self.currentContentDict[entity.organization];
    NSInteger index = [self.dataSourceArray indexOfObject:entity];
    for (int i = 0; i < array.count; i ++) {
        HDMemberDepartmentEntity *entity = array[array.count - 1 - i];
        [self.dataSourceArray insertObject:entity atIndex:index + 1];
    }
}

- (NSArray *)currentDepartments
{
    return self.isLocal ? self.localDepartmentArray : self.remotDepartmentArray;
}

- (NSDictionary *)currentContentDict
{
    return self.isLocal ? self.localContentDictionary: self.remotContentDictionary;
}


#pragma -mark LoadData

- (void)loadLocalContract
{
    self.isLocal = YES;
    RLMResults *contracts = [HDCoreDataManager getLocalAddressBooks];
    [HDContractEntityTransform transforLocalMembers:contracts completeBlock:^(NSArray *departments, NSDictionary *contentDict) {
        self.localContentDictionary = contentDict;
        self.localDepartmentArray = departments;
        [self loadDataSourceWithArray:departments];
    }];
}

- (void)loadRemotContract
{
    RLMResults *contracts = [HDCoreDataManager getRemotAddressBooks];
    [HDContractEntityTransform transforRemoteMembers:contracts completeBlock:^(NSArray *departments, NSDictionary *contentDict) {
        self.remotContentDictionary = contentDict;
        self.remotDepartmentArray = departments;
        [self loadDataSourceWithArray:departments];
    }];
}

- (void)loadDataSourceWithArray:(NSArray *)departmentArray
{
    self.dataSourceArray = [NSMutableArray array];
    for (HDMemberDepartmentEntity *entity in departmentArray) {
        if (entity.parentOrganization == nil) {
            [self.dataSourceArray addObject:entity];
        }
    }
    [self.tableView reloadData];
}

@end
