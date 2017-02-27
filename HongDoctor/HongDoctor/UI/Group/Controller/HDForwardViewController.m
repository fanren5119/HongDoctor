//
//  HDForwardViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDForwardViewController.h"
#import "HDForwardGroupCell.h"
#import "HDGroupCellModel.h"
#import "HDMessageViewController.h"
#import "HDCoreDataManager.h"
#import "HDChatGroupEntity.h"
#import "HDForwardGroupCellModel.h"
#import "HDGroupSearchViewController.h"
#import <Realm/Realm.h>
#import "HDMessageManager.h"
#import "HDUserEntity.h"
#import "HDForwardHeaderView.h"
#import "HDForwardHeaderModel.h"
#import "HDForwardGroupNormalCell.h"
#import "HDForwardMemberViewController.h"
#import "HDContractEntity.h"

@interface HDForwardViewController () <UITableViewDelegate, UITableViewDataSource, HDForwardHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UIView         *topView;
@property (nonatomic, strong) HDForwardHeaderView   *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (nonatomic, strong) NSMutableArray        *dataSourceArray;
@property (nonatomic, strong) NSMutableArray        *selectDataArray;
@property (nonatomic, strong) NSMutableArray        *selectMemberArray;

@end

@implementation HDForwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self registerNotification];
    [self loadData];
}

#pragma -mark SetupUI

- (void)setupUI
{
    [self setupNavigation];
    [self setupTableView];
    [self setupHeaderView];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"转发";
    
    UIBarButtonItem *searchItem = [[HLBarButtonItem alloc] initWithTitle:@"确定" target:self action:@selector(respondsToOkItem)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:@"会话" image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"HDForwardGroupCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HDForwardGroupCell"];
    
    UINib *normalNib = [UINib nibWithNibName:@"HDForwardGroupNormalCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:normalNib forCellReuseIdentifier:@"HDForwardGroupNormalCell"];
}

- (void)setupHeaderView
{
    self.headerView = [[HDForwardHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.headerView.delegate = self;
    [self.topView addSubview:self.headerView];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToGroupDataChangeNotification) name:@"HDGroupDataChange" object:nil];
}

#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToOkItem
{
    NSMutableArray *selectGroupIds = [NSMutableArray array];
    for (HDForwardGroupCellModel *cellModel in self.selectDataArray) {
        [selectGroupIds addObject:cellModel.groupGuid];
    }
    NSMutableArray *selectContractIds = [NSMutableArray array];
    for (HDContractEntity *entity in self.selectMemberArray) {
        [selectContractIds addObject:entity.contractId];
    }
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    ShowLoading(@"数据加载中");
    [HDMessageManager requestForwardMessage:self.messageGuid userGuid:userEntity.userGuid  groupIds:selectGroupIds contactIds:selectContractIds completeBlock:^(BOOL succeed) {
        RemoveLoading;
        if (succeed) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)respondsToGroupDataChangeNotification
{
    [self loadData];
}


#pragma -mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HDForwardGroupNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDForwardGroupNormalCell" forIndexPath:indexPath];
        return cell;
    } else {
        HDForwardGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDForwardGroupCell" forIndexPath:indexPath];
        HDForwardGroupCellModel *entity = self.dataSourceArray[indexPath.row];
        [cell resetCellWithEntity:entity];
        [cell hideLineView:indexPath.row == 0];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        HDForwardMemberViewController *forwardMemberVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDForwardMemberViewController"];
        forwardMemberVC.selectHandler = ^(NSArray *memberArray) {
            self.selectMemberArray = memberArray.mutableCopy;
            [self resetRighItemWhenSelect];
            [self resetHeaderViewWhenSelect];
        };
        [self.navigationController pushViewController:forwardMemberVC animated:YES];
    } else {
        HDForwardGroupCellModel *entity = self.dataSourceArray[indexPath.row];
        
        [self resetDataWhenSelect:entity];
        [self resetRighItemWhenSelect];
        [self resetHeaderViewWhenSelect];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 15)];
    label.text = @"最近的聊天群";
    label.textColor = ColorFromRGB(0x313131);
    label.font = [UIFont systemFontOfSize:12.0];
    [view addSubview:label];
    return view;
}


#pragma -mark cellDelegate

- (void)resetDataWhenSelect:(HDForwardGroupCellModel *)entity
{
    entity.isSelect = !entity.isSelect;
    [self.tableView reloadData];
    if (entity.isSelect) {
        [self.selectDataArray addObject:entity];
    } else {
        for (HDForwardGroupCellModel *model in self.selectDataArray) {
            if ([model.groupGuid isEqualToString:entity.groupGuid]) {
                [self.selectDataArray removeObject:model];
                break;
            }
        }
    }
}

- (void)resetRighItemWhenSelect
{
    NSInteger selectCount = self.selectDataArray.count + self.selectMemberArray.count;
    
    if (selectCount > 0) {
        NSString *title = [NSString stringWithFormat:@"确定(%ld)", (long)selectCount];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(respondsToOkItem)];
        self.navigationItem.rightBarButtonItem = barItem;
    } else {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToOkItem)];
        self.navigationItem.rightBarButtonItem = barItem;
    }
}

- (void)resetHeaderViewWhenSelect
{
    NSInteger selectCount = self.selectDataArray.count + self.selectMemberArray.count;
    if (selectCount <= 0) {
        self.topViewHeight.constant = 0;
    } else {
        self.topViewHeight.constant = 80;
    }
    NSMutableArray *headerModelArray = [NSMutableArray array];
    [self.selectDataArray enumerateObjectsUsingBlock:^(HDForwardGroupCellModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDForwardHeaderModel *model = [[HDForwardHeaderModel alloc] init];
        model.name = obj.groupdName;
        model.guid = obj.groupGuid;
        model.imageURL = obj.groupHeaderURl;
        [headerModelArray addObject:model];
    }];
    [self.selectMemberArray enumerateObjectsUsingBlock:^(HDContractEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDForwardHeaderModel *model = [[HDForwardHeaderModel alloc] init];
        model.name = obj.name;
        model.guid = obj.contractId;
        model.imageURL = obj.headImageURL;
        [headerModelArray addObject:model];
    }];
    [self.headerView resetViewWithData:headerModelArray];
}


#pragma -mark headerView delegate

- (void)didSelectItemWithModel:(HDForwardHeaderModel *)model
{
    for (HDForwardGroupCellModel *entity in self.selectDataArray) {
        if ([entity.groupGuid isEqualToString:model.guid]) {
            [self resetDataWhenSelect:entity];
            [self resetRighItemWhenSelect];
            [self resetHeaderViewWhenSelect];
        }
    }
    for (HDContractEntity *entity in self.selectMemberArray) {
        if ([entity.contractId isEqualToString:model.guid]) {
            [self.selectMemberArray removeObject:entity];
            [self resetRighItemWhenSelect];
            [self resetHeaderViewWhenSelect];
        }
    }
}



#pragma -mark LoadData

- (void)loadData
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    RLMResults *groupsArray = [HDCoreDataManager getChatGroups];
    for (int i = 0; i < groupsArray.count ; i ++) {
        HDChatGroupEntity *obj = [groupsArray objectAtIndex:i];
        HDForwardGroupCellModel *model = [[HDForwardGroupCellModel alloc] init];
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
        model.isSelect = NO;
        [self.dataSourceArray addObject:model];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)selectDataArray
{
    if (_selectDataArray == nil) {
        _selectDataArray = [NSMutableArray array];
    }
    return _selectDataArray;
}

@end
