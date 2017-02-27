//
//  HDGroupSearchViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupSearchViewController.h"
#import "HDGroupCell.h"
#import "HDChatGroupEntity.h"
#import "HDMessageViewController.h"
#import "HDGroupCellModel.h"
#import "HDCoreDataManager.h"
#import <Realm/Realm.h>

@interface HDGroupSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;

@end

@implementation HDGroupSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma -mark SetupUI

- (void)setupUI
{
    [self setupNavigation];
    [self setupTableView];
}


- (void)setupNavigation
{
    self.navigationItem.title = @"搜索";
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDGroupCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDGroupCell"];
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDGroupCell" forIndexPath:indexPath];
    HDGroupCellModel *entity = self.dataSourceArray[indexPath.row];
    [cell resetCellWithEntity:entity];
    [cell hideLineView:indexPath.row == 0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HDGroupCellModel *entity = self.dataSourceArray[indexPath.row];
    HDMessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
    messageVC.hidesBottomBarWhenPushed = YES;
    messageVC.groupGuid = entity.groupGuid;
    messageVC.groupName = entity.groupdName;
    messageVC.isPopToGroupVC = NO;
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma -mark searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *name = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RLMResults *groupsArray = [HDCoreDataManager getChatGroupsWithGroupName:name];
    self.dataSourceArray = [NSMutableArray array];
    for (int i = 0; i < groupsArray.count; i ++) {
        HDChatGroupEntity *obj = [groupsArray objectAtIndex:i];
        HDGroupCellModel *model = [[HDGroupCellModel alloc] init];
        model.groupGuid = obj.groupGuid;
        model.groupdName = obj.groupdName;
        model.groupNewDate = obj.groupNewDate;
        model.groupHeaderURl = obj.groupHeaderURl;
        model.groupNewMessage = obj.groupNewMessage;
        model.groupNewMsgType = obj.groupMsgType;
        model.groupProperty = obj.groupProperty;
        model.msgProperty = obj.msgProperty;
        model.msgUnReadCount = obj.msgUnReadCount;
        model.groupMemberCount = obj.groupMemberCount;
        model.isExportGroup = ([obj.groupProperty integerValue] == 100);
        [self.dataSourceArray addObject:model];
    }
    [self.tableView reloadData];
}

@end
