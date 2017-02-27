//
//  HDCreateSearchViewController.m
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDCreateSearchViewController.h"
#import "HDCreateGroupCell.h"
#import "HDContractEntity.h"
#import "HDCoreDataManager.h"
#import "HDMemberEntity.h"
#import "HDUserEntity.h"
#import "HDUserInfoViewController.h"
#import <Realm/Realm.h>

@interface HDCreateSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;
@property (nonatomic, strong) NSMutableArray     *currentSelectIds;

@end

@implementation HDCreateSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.currentSelectIds = [NSMutableArray arrayWithArray:self.selectContractIds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCreateGroupButtonItem)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDCreateGroupCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDCreateGroupCell"];
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

- (void)respondsToCreateGroupButtonItem
{
    if (self.searchContractHandler) {
        self.searchContractHandler(self.currentSelectIds);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDCreateGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDCreateGroupCell" forIndexPath:indexPath];
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
    HDContractEntity *entity = self.dataSourceArray[indexPath.row];
    [self resetDataWhenSelect:entity];
    [self resetRighItemWhenSelect];
}


- (void)resetDataWhenSelect:(HDContractEntity *)entity
{
    entity.isSelect = !entity.isSelect;
    [self.tableView reloadData];
    if (entity.isSelect) {
        [self.currentSelectIds addObject:entity.contractId];
    } else {
        if ([self.currentSelectIds containsObject:entity.contractId]) {
            [self.currentSelectIds removeObject:entity.contractId];
        }
    }
}

- (void)resetRighItemWhenSelect
{
    NSInteger selectCount = self.currentSelectIds.count;
    if (selectCount > 0) {
        NSString *title = [NSString stringWithFormat:@"确定(%ld)", (long)selectCount];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCreateGroupButtonItem)];
        self.navigationItem.rightBarButtonItem = barItem;
    } else {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCreateGroupButtonItem)];
        self.navigationItem.rightBarButtonItem = barItem;
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
    RLMResults *addressBooks = [HDCoreDataManager getAddressBooksWithName:name outMemberIds:self.outContractIds];
    self.dataSourceArray = [NSMutableArray array];
    for (int i = 0; i < addressBooks.count; i ++) {
        HDMemberEntity *obj = [addressBooks objectAtIndex:i];
        HDContractEntity *entity = [[HDContractEntity alloc] init];
        entity.headImageURL = obj.userHeadURL;
        entity.name = obj.userName;
        entity.contractId = obj.userGuid;
        entity.grade = obj.userGrade;
        entity.isSign = ![obj.isCompany boolValue];
        if ([self.currentSelectIds containsObject:entity.contractId]) {
            entity.isSelect = YES;
        } else {
            entity.isSelect = NO;
        }
        [self.dataSourceArray addObject:entity];
    }
    
    [self.tableView reloadData];
}


@end
