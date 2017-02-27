//
//  HDGroupViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupViewController.h"
#import "HDGroupCell.h"
#import "HDMessageViewController.h"
#import "HDCoreDataManager.h"
#import "HDChatGroupEntity.h"
#import "HDGroupCellModel.h"
#import "HDGroupSearchViewController.h"
#import <Realm/Realm.h>
#import "HDContractItemSelectView.h"
#import "HDCreateGroupViewController.h"

@interface HDGroupViewController () <UITableViewDelegate, UITableViewDataSource, HDContractItemSelectViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;
@property (nonatomic, strong) HDContractItemSelectView *selectView;

@end

@implementation HDGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self registerNotification];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectView hide];
}

#pragma -mark SetupUI

- (void)setupUI
{
    [self setupNavigation];
    [self setupTableView];
}


- (void)setupNavigation
{
    self.navigationItem.title = @"消息";
    
    HLBarButtonItem *searchItem = [[HLBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Main_add"] target:self action:@selector(respondsToAddItem)];
    
    HLBarButtonItem *addItem = [[HLBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Main_search"] target:self action:@selector(respondsToSearchItem)];
    self.navigationItem.rightBarButtonItems = @[addItem, searchItem];
}

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDGroupCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDGroupCell"];
}


- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToGroupDataChangeNotification) name:@"HDGroupDataChange" object:nil];
}

#pragma -mark responds

- (void)respondsToAddItem
{
    [self didSelectWithIndex:0];
}

- (void)respondsToSearchItem
{
    [self didSelectWithIndex:1];
//    if (self.selectView == nil) {
//        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50);
//        self.selectView = [[HDContractItemSelectView alloc] initWithFrame:frame titles:@[@"创建群", @"搜索"]];
//        self.selectView.delegate = self;
//    }
//    [self.view addSubview:self.selectView];
}

- (void)respondsToGroupDataChangeNotification
{
    [self loadData];
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
    
    entity.msgUnReadCount = @"0";
    [self.tableView reloadData];
    [HDCoreDataManager modifyGroup:entity.groupGuid unReadCount:0];
    
    HDMessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
    messageVC.hidesBottomBarWhenPushed = YES;
    messageVC.groupGuid = entity.groupGuid;
    messageVC.groupName = entity.groupdName;
    messageVC.groupProperty = entity.groupProperty;
    messageVC.isPopToGroupVC = YES;
    messageVC.groupMemberCount = [entity.groupMemberCount integerValue];
    [self.navigationController pushViewController:messageVC animated:YES];
}


- (void)didSelectWithIndex:(NSInteger)index
{
    if (index == 0) {
        
        HDCreateGroupViewController *createGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDCreateGroupViewController"];
        createGroupVC.isCreateGroup = YES;
        createGroupVC.hidesBottomBarWhenPushed = YES;
        createGroupVC.backItemTitle = @"消息";
        [self.navigationController pushViewController:createGroupVC animated:YES];
        
    } else {
        HDGroupSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDGroupSearchViewController"];
        searchVC.hidesBottomBarWhenPushed = YES;
        searchVC.backItemTitle = @"消息";
        [self.navigationController pushViewController:searchVC animated:YES];

    }
}
- (void)didClickToHideView
{
    
}


#pragma -mark LoadData

- (void)loadData
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    RLMResults *groupsArray = [HDCoreDataManager getChatGroups];
    for (int i = 0; i < groupsArray.count ; i ++) {
        HDChatGroupEntity *obj = [groupsArray objectAtIndex:i];
        HDGroupCellModel *model = [[HDGroupCellModel alloc] init];
        model.groupGuid = obj.groupGuid;
        model.groupdName = obj.groupdName;
        NSDate *date = [NSDate dateFromString:obj.groupNewDate withFormat:@"yyyy-MM-dd HH:mm:ss:S"];
        model.groupNewDate = [NewsRelativeTimeFormat FromNowdateStringWithDate:date];
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
