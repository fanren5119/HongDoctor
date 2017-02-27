//
//  HDContractDetailViewController.m
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDContractDetailViewController.h"
#import "HDUserInfoHeadCell.h"
#import "HDUserInfoGradeCell.h"
#import "HDUserInfoNormalCell.h"
#import "HDUserInfoCanEditCell.h"
#import "HDUserInfoCellModel.h"
#import "HDUserInfoQRCell.h"
#import "HDUserEntity.h"

#import "HDModifyNameViewController.h"
#import "HDModifySexViewController.h"
#import "HDModifyPhoneViewController.h"
#import "HDUserQRViewController.h"
#import "TimingImagePickerManager.h"
#import "HDCoreDataManager.h"
#import "HDMemberEntity.h"
#import "HDGroupManager.h"
#import "HDMessageViewController.h"
#import "HDResponseChatGroupEntity.h"
#import "HDContractManager.h"
#import "HDResponseMemberEntity.h"

@interface HDContractDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;

@end

@implementation HDContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"详细资料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTableView
{
    UINib *headerNib = [UINib nibWithNibName:@"HDUserInfoHeadCell" bundle:[NSBundle mainBundle]];
    UINib *gradeNib = [UINib nibWithNibName:@"HDUserInfoGradeCell" bundle:[NSBundle mainBundle]];
    UINib *normalNib = [UINib nibWithNibName:@"HDUserInfoNormalCell" bundle:[NSBundle mainBundle]];
    UINib *canEditNib = [UINib nibWithNibName:@"HDUserInfoCanEditCell" bundle:[NSBundle mainBundle]];
    UINib *qrNib = [UINib nibWithNibName:@"HDUserInfoQRCell" bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:headerNib forCellReuseIdentifier:@"HDUserInfoHeadCell"];
    [self.tableView registerNib:gradeNib forCellReuseIdentifier:@"HDUserInfoGradeCell"];
    [self.tableView registerNib:normalNib forCellReuseIdentifier:@"HDUserInfoNormalCell"];
    [self.tableView registerNib:canEditNib forCellReuseIdentifier:@"HDUserInfoCanEditCell"];
    [self.tableView registerNib:qrNib forCellReuseIdentifier:@"HDUserInfoQRCell"];
}


#pragma -mark responds

- (IBAction)respondsToCreateMessageButton:(id)sender
{
    ShowLoading(@"数据加载中");
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    [HDGroupManager createGroup:userEntity.userGuid memberGuids:@[self.contractGuid] groupId:@"" completeBlock:^(BOOL succeed, HDResponseChatGroupEntity *entity) {
        RemoveLoading;
        if (succeed) {
            [HDCoreDataManager saveChatGroup:entity];
            HDMessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
            messageVC.hidesBottomBarWhenPushed = YES;
            messageVC.groupGuid = entity.groupGuid;
            messageVC.groupName = entity.groupdName;
            messageVC.groupProperty = entity.groupProperty;
            messageVC.isPopToGroupVC = YES;
            [self.navigationController pushViewController:messageVC animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HDGroupDataChange" object:nil];
        }
    }];
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDUserInfoCellModel *model = self.dataSourceArray[indexPath.row];
    switch (model.cellType) {
        case UserInfoHeadCell:
        {
            HDUserInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserInfoHeadCell" forIndexPath:indexPath];
            [cell resetCellWithModel:model];
            return cell;
        }
            break;
        case UserInfoNickNameCell:
        case UserInfoTrueNameCell:
        case UserInfoSexCell:
        case UserInfoPhoneCell:
        case UserInfoNumberCell:
        case UserInfoCompanyCell:
        {
            HDUserInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserInfoNormalCell" forIndexPath:indexPath];
            [cell resetCellWithModel:model];
            return cell;
        }
            break;
        case UserInfoGradeCell:
        {
            HDUserInfoGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserInfoGradeCell" forIndexPath:indexPath];
            [cell resetCellWithModel:model];
            return cell;
        }
            break;
        case UserInfoQRCode:
        {
            HDUserInfoQRCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserInfoQRCell" forIndexPath:indexPath];
            [cell resetCellWithModel:model];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDUserInfoCellModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == UserInfoHeadCell) {
        return 70;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDUserInfoCellModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == UserInfoQRCode) {
        HDUserQRViewController *qrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserQRViewController"];
        qrVC.qrImageURL = model.content;
        [self.navigationController pushViewController:qrVC animated:YES];
    }
}


#pragma -mark loadData

- (void)loadData
{
    HDMemberEntity *entity = [HDCoreDataManager getAddressBookWithId:self.contractGuid];
    if (entity != nil) {
        [self loadDataSourceWithEntity:entity];
    } else {
        ShowLoading(@"数据加载中。。。");
    }
    
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    [HDContractManager requestGetMember:userEntity.userGuid memberId:self.contractGuid completeBlock:^(BOOL succeed, HDResponseMemberEntity *member) {
        RemoveLoading;
        if (succeed) {
            [self loadDataSourceWithEntity:member];
        }
    }];
}

- (void)loadDataSourceWithEntity:(NSObject *)entity
{
    self.dataSourceArray = [NSMutableArray array];
    HDUserInfoCellModel *headModel = [[HDUserInfoCellModel alloc] init];
    headModel.cellType = UserInfoHeadCell;
    headModel.title = @"头像";
    headModel.content = [entity valueForKey:@"userHeadURL"];
    [self.dataSourceArray addObject:headModel];
    
    HDUserInfoCellModel *nickNameModel = [[HDUserInfoCellModel alloc] init];
    nickNameModel.cellType = UserInfoNickNameCell;
    nickNameModel.title = @"昵称";
    nickNameModel.content = [entity valueForKey:@"nickname"];
    [self.dataSourceArray addObject:nickNameModel];
    
    HDUserInfoCellModel *nameModel = [[HDUserInfoCellModel alloc] init];
    nameModel.cellType = UserInfoTrueNameCell;
    nameModel.title = @"真实名字";
    nameModel.content = [entity valueForKey:@"userName"];
    [self.dataSourceArray addObject:nameModel];
    
    HDUserInfoCellModel *numModel = [[HDUserInfoCellModel alloc] init];
    numModel.cellType = UserInfoNumberCell;
    numModel.title = @"账号";
    numModel.content = [entity valueForKey:@"number"];
    [self.dataSourceArray addObject:numModel];
    
    HDUserInfoCellModel *qrModel = [[HDUserInfoCellModel alloc] init];
    qrModel.cellType = UserInfoQRCode;
    qrModel.title = @"二维码";
    qrModel.content = [entity valueForKey:@"qrImageURL"];
    [self.dataSourceArray addObject:qrModel];
    
    HDUserInfoCellModel *sexModel = [[HDUserInfoCellModel alloc] init];
    sexModel.cellType = UserInfoSexCell;
    sexModel.title = @"性别";
    if ([[entity valueForKey:@"sex"] isEqualToString:@"1"]) {
        sexModel.content = @"男";
    } else {
        sexModel.content = @"女";
    }
    [self.dataSourceArray addObject:sexModel];
    
    NSInteger grade = [[entity valueForKey:@"userGrade"] integerValue];
    if (grade > 0) {
        HDUserInfoCellModel *gradeModel = [[HDUserInfoCellModel alloc] init];
        gradeModel.cellType = UserInfoGradeCell;
        gradeModel.title = @"专家星级";
        gradeModel.content = [entity valueForKey:@"userGrade"];
        [self.dataSourceArray addObject:gradeModel];
    }
    
    
    HDUserInfoCellModel *phoneModel = [[HDUserInfoCellModel alloc] init];
    phoneModel.cellType = UserInfoPhoneCell;
    phoneModel.title = @"手机号码";
    phoneModel.content = [entity valueForKey:@"phone"];
    [self.dataSourceArray addObject:phoneModel];

    [self.tableView reloadData];
}

@end
