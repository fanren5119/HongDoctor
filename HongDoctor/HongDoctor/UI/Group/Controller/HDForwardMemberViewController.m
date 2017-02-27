//
//  HDForwardMemberViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/24.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDForwardMemberViewController.h"
#import "HDCreateSearchViewController.h"
#import "HDCoreDataManager.h"
#import "HDMemberEntity.h"
#import "HDContractEntity.h"
#import "HDCreateGroupCell.h"
#import "HDContractDepartmentCell.h"
#import "HDMemberDepartmentEntity.h"
#import "HDContractEntityTransform.h"
#import "HDContractHeaderView.h"
#import "HDUserEntity.h"
#import "HDGroupManager.h"
#import "HDCreateGroupHeaderView.h"
#import "HDTabBarController.h"
#import "HDGroupViewController.h"
#import "HDMessageViewController.h"
#import "HDResponseChatGroupEntity.h"
#import <Realm/Realm.h>

@interface HDForwardMemberViewController ()<UITableViewDelegate, UITableViewDataSource, HDContractHeaderViewDelegate, HDCreateGroupHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL               isLocal;
@property (nonatomic, strong) UIView             *customTitleView;
@property (nonatomic, strong) HDCreateGroupHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray     *selectContracts;

@property (nonatomic, strong) NSArray                   *localDepartmentArray;
@property (nonatomic, strong) NSDictionary              *localContentDictionary;

@property (nonatomic, strong) NSArray                   *remotDepartmentArray;
@property (nonatomic, strong) NSDictionary              *remotContentDictionary;
@property (nonatomic, strong) NSMutableArray            *dataSourceArray;

@end

@implementation HDForwardMemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
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

#pragma -mark setupUI

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupTableView];
}

- (void)setupNavigationBar
{
    self.customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"本地", @"云端"]];
    segment.frame = CGRectMake(0, 0, 100, 30);
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(respondsToSegmentValueChange:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    [self.customTitleView addSubview:segment];
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    self.customTitleView.center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCreateGroupButtonItem)];
    UIBarButtonItem *searchItem = [[HLBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Main_search"] target:self action:@selector(respondsToSearhButton)];
    
    self.navigationItem.rightBarButtonItems = @[barItem, searchItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDCreateGroupCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDCreateGroupCell"];
    
    UINib *departmentNib = [UINib nibWithNibName:@"HDContractDepartmentCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:departmentNib forCellReuseIdentifier:@"HDContractDepartmentCell"];
}

#pragma -mark responds

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

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToSearhButton
{
    HDCreateSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDCreateSearchViewController"];
    NSMutableArray *memberIds = [NSMutableArray array];
    [self.selectContracts enumerateObjectsUsingBlock:^(HDContractEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [memberIds addObject:obj.contractId];
    }];
    searchVC.selectContractIds = memberIds;
    searchVC.searchContractHandler = ^(NSArray *contractId) {
        [self refreshDataSourceWithContractIds:contractId];
    };
    searchVC.backItemTitle = @"通讯录";
    searchVC.outContractIds = @[];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)refreshDataSourceWithContractIds:(NSArray *)contractId
{
    self.selectContracts = [NSMutableArray array];
    
    NSArray *localKeys = [self.localContentDictionary allKeys];
    for (NSString *key in localKeys) {
        NSArray *contractArray = self.localContentDictionary[key];
        for (HDContractEntity *contract in contractArray) {
            if ([contractId containsObject:contract.contractId]) {
                contract.isSelect = YES;
                [self.selectContracts addObject:contract];
            }
        }
    }
    
    NSArray *remoteKeys = [self.remotContentDictionary allKeys];
    for (NSString *key in remoteKeys) {
        NSArray *contractArray = self.remotContentDictionary[key];
        for (HDContractEntity *contract in contractArray) {
            if ([contractId containsObject:contract.contractId]) {
                contract.isSelect = YES;
                [self.selectContracts addObject:contract];
            }
        }
    }

    [self.tableView reloadData];
    [self resetRighItemWhenSelect];
}

- (void)respondsToCreateGroupButtonItem
{
    if (self.selectContracts.count <= 0) {
        return;
    }
    if (self.selectHandler) {
        self.selectHandler(self.selectContracts);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createGroupSuccess:(HDResponseChatGroupEntity *)entity
{
    [HDCoreDataManager saveChatGroup:entity];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDGroupDataChange" object:nil];
    HDMessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
    messageVC.hidesBottomBarWhenPushed = YES;
    messageVC.groupGuid = entity.groupGuid;
    messageVC.groupName = entity.groupdName;
    messageVC.groupProperty = entity.groupProperty;
    messageVC.isPopToGroupVC = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
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
        HDCreateGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDCreateGroupCell" forIndexPath:indexPath];
        [cell resetCellWithEntity:(HDContractEntity *)entity];
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
        [self resetDataWhenSelect:(HDContractEntity *)entity];
        [self resetRighItemWhenSelect];
        
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



#pragma -mark headerView delegate

- (NSArray *)currentDepartments
{
    return self.isLocal ? self.localDepartmentArray : self.remotDepartmentArray;
}

- (NSDictionary *)currentContentDict
{
    return self.isLocal ? self.localContentDictionary: self.remotContentDictionary;
}


#pragma -mark cellDelegate

- (void)resetDataWhenSelect:(HDContractEntity *)entity
{
    entity.isSelect = !entity.isSelect;
    [self.tableView reloadData];
    if (entity.isSelect) {
        [self.selectContracts addObject:entity];
    } else {
        for (HDContractEntity *contract in self.selectContracts) {
            if ([contract.contractId isEqualToString:entity.contractId]) {
                [self.selectContracts removeObject:contract];
                break;
            }
        }
    }
}

- (void)resetRighItemWhenSelect
{
    NSInteger selectCount = self.selectContracts.count;
    if (selectCount > 0) {
        NSString *title = [NSString stringWithFormat:@"确定(%ld)", (long)selectCount];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCreateGroupButtonItem)];
        self.navigationItem.rightBarButtonItem = barItem;
    } else {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCreateGroupButtonItem)];
        self.navigationItem.rightBarButtonItem = barItem;
    }
}

#pragma -mark headerView delegate

- (void)didSelectItemWithEntity:(HDContractEntity *)entity
{
    [self resetDataWhenSelect:entity];
    [self resetRighItemWhenSelect];
}

#pragma -mark loadData

- (void)loadLocalContract
{
    self.isLocal = YES;
    RLMResults *contracts = [HDCoreDataManager getLocalAddressBooks];
    [HDContractEntityTransform transforLocalMembers:contracts completeBlock:^(NSArray *departments, NSDictionary *contentDict) {
        self.localContentDictionary = contentDict;
        [self resetContentDictionary:contentDict];
        
        self.localDepartmentArray = departments;
        [self loadLocalContract];
    }];
}

- (void)loadRemotContract
{
    RLMResults *contracts = [HDCoreDataManager getRemotAddressBooks];
    [HDContractEntityTransform transforRemoteMembers:contracts completeBlock:^(NSArray *departments, NSDictionary *contentDict) {
        self.remotContentDictionary = contentDict;
        [self resetContentDictionary:contentDict];
        self.remotDepartmentArray = departments;
        [self loadLocalContract];
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
}

- (void)resetContentDictionary:(NSDictionary *)dict
{
    NSMutableArray *memberIds = [NSMutableArray array];
    [self.selectContracts enumerateObjectsUsingBlock:^(HDContractEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [memberIds addObject:obj.contractId];
    }];
    NSArray *localKeys = [dict allKeys];
    for (NSString *key in localKeys) {
        NSArray *contractArray = dict[key];
        for (HDContractEntity *contract in contractArray) {
            if ([memberIds containsObject:contract.contractId]) {
                contract.isSelect = YES;
            }
        }
    }
    [self.tableView reloadData];
}


- (NSMutableArray *)selectContracts
{
    if (_selectContracts == nil) {
        _selectContracts = [NSMutableArray array];
    }
    return _selectContracts;
}

@end
