//
//  HDGoupMembersViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupMembersViewController.h"
#import "HDCreateGroupViewController.h"
#import "HDGroupNameViewController.h"
#import "HDContractDetailViewController.h"
#import "HDUserQRViewController.h"
#import "HDUserInfoViewController.h"
#import "HDEditPostViewController.h"
#import "HDDiagonsisViewController.h"

#import "HDCoreDataManager.h"
#import "HDGroupMemberCell.h"
#import "HDGroupMemberQRCell.h"
#import "HDGroupMemberCellModel.h"
#import "HDGroupMemberNormalCell.h"
#import "HDGroupMemberNormalCellModel.h"
#import "HDGroupManager.h"
#import "HDChatGroupEntity.h"
#import "HDMemberEntity.h"
#import "HDGroupMemberFootCell.h"
#import "HDUserEntity.h"
#import <Realm/Realm.h>
#import "HDMessageManager.h"
#import "HDMainNoDataView.h"

@interface HDGroupMembersViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HDGroupMemberFootCellDelegate, HDMainNoDataViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) HDMainNoDataView        *noDataView;
@property (nonatomic, strong) NSArray                 *memberIDArray;
@property (nonatomic, strong) NSMutableArray          *membersDataArray;
@property (nonatomic, strong) NSMutableArray          *normalDataArray;
@property (nonatomic, strong) NSMutableArray          *footDataArray;

@end

@implementation HDGroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self registerNotification];
    [self loadData];
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupNoDataView];
}

- (void)setupNavigation
{
    self.navigationItem.title = self.groupName;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToGroupNameChange:) name:@"HDGroupNameChangeNotification" object:nil];
}

- (void)setupNoDataView
{
    self.noDataView = [[HDMainNoDataView alloc] initWithFrame:self.view.frame];
    self.noDataView.delegate = self;
}


#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectorToGroupNameChange:(NSNotification *)not
{
    NSString *groupName = [not.userInfo objectForKey:@"groupName"];
    self.navigationItem.title = groupName;
}

#pragma -mark collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.membersDataArray.count;
    }
    if (section == 1) {
        return self.normalDataArray.count;
    }
    return self.footDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HDGroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDGroupMemberCell" forIndexPath:indexPath];
        [cell resetCellWithModel:self.membersDataArray[indexPath.row]];
        return cell;
    } else if (indexPath.section == 1) {
        
        HDGroupMemberNormalCellModel *model = self.normalDataArray[indexPath.row];
        switch (model.cellType) {
            case GroupQRCell:
            {
                HDGroupMemberQRCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDGroupMemberQRCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                return cell;
            }
                break;
            case GroupNameCell:
            case MemberCountCell:
            case GroupOwnerCell:
            case GroupPostCell:
            case GroupSynchronize:
            case GroupDiagnosisCell:
            case GroupClearCell:
            {
                HDGroupMemberNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDGroupMemberNormalCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                return cell;
            }
                break;
            default:
                break;
        }

    } else {
        HDGroupMemberFootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDGroupMemberFootCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat width = (self.view.frame.size.width) / 5.0;
        return CGSizeMake(width, width + 20);
    } else {
        return CGSizeMake(self.view.frame.size.width, 44);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 30) ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, section == 2 ? 30 : 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HDGroupMemberCellModel *model = self.membersDataArray[indexPath.row];
        if (model.type == AddMemberCell) {
            [self addNewMember];
        } else if (model.type == NormalMemberCell) {
            [self goToMemberDetailWithModel:model];
        }
    } else if (indexPath.section == 1) {
        HDGroupMemberNormalCellModel *model = self.normalDataArray[indexPath.row];
        switch (model.cellType) {
            case GroupNameCell:
                [self modifyGroupName: model];
                break;
            case GroupSynchronize:
                [self synchronizeMessages];
                break;
            case GroupQRCell:
                [self scanGroupQR:model.content];
                break;
            case GroupPostCell:
                [self sendGroupPost:model];
                break;
            case GroupDiagnosisCell:
                [self diagnosisGroup];
                break;
            case GroupClearCell:
                [self clearHistoryData];
                break;
            default:
                break;
        }
    }
}

- (void)goToMemberDetailWithModel:(HDGroupMemberCellModel *)cellModel
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    if ([userEntity.userGuid isEqualToString:cellModel.memberId]) {
        HDUserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserInfoViewController"];
        userInfoVC.backItemTitle = @"群消息";
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else {
        HDContractDetailViewController *contractDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDContractDetailViewController"];
        contractDetailVC.contractGuid = cellModel.memberId;
        contractDetailVC.backItemTitle = @"群信息";
        [self.navigationController pushViewController:contractDetailVC animated:YES];
    }
}

- (void)addNewMember
{
    HDCreateGroupViewController *createGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDCreateGroupViewController"];
    createGroupVC.groupGuid = self.groupGuid;
    createGroupVC.isCreateGroup = NO;
    createGroupVC.outMemberGuids = self.memberIDArray;
    createGroupVC.backItemTitle = @"群信息";
    [self.navigationController pushViewController:createGroupVC animated:YES];
}

- (void)modifyGroupName:(HDGroupMemberNormalCellModel *)model
{
    HDGroupNameViewController *groupNameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDGroupNameViewController"];
    groupNameVC.groupGuid = self.groupGuid;
    groupNameVC.groupName = self.groupName;
    groupNameVC.backItemTitle = @"群消息";
    groupNameVC.modifyHandler = ^(NSString *groupName) {
        model.content = groupName;
        [self.collectionView reloadData];
    };
    [self.navigationController pushViewController:groupNameVC animated:YES];
}

- (void)synchronizeMessages
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    ShowLoading(@"数据同步中");
    [HDMessageManager requestGetHistoryMessage:userEntity.userGuid groupGuid:self.groupGuid completeBlock:^(BOOL succeed) {
        RemoveLoading;
        if (succeed) {
            ShowText(@"数据同步成功", 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HDMessageChangeNotification" object:nil userInfo:@{@"groupGuid": self.groupGuid}];
        } else {
            ShowText(@"网络加载失败，请稍后重试", 1);
        }
    }];
}

- (void)scanGroupQR:(NSString *)qrImageURL
{
    HDUserQRViewController *qrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserQRViewController"];
    qrVC.qrImageURL = qrImageURL;
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)sendGroupPost:(HDGroupMemberNormalCellModel *)model
{
    HDEditPostViewController *editPostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDEditPostViewController"];
    editPostVC.groupGuid = self.groupGuid;
    editPostVC.backItemTitle = @"群消息";
    editPostVC.groupPost = model.content;
    editPostVC.canEdit = model.isCanSelect;
    editPostVC.modifyHandler = ^(NSString *groupPost) {
        model.content = groupPost;
        [self.collectionView reloadData];
    };
    [self.navigationController pushViewController:editPostVC animated:YES];
}

- (void)diagnosisGroup
{
    ShowLoading(@"数据加载中");
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    [HDGroupManager requestToDiagonsis:userEntity.userGuid groupGuid:self.groupGuid completeBlock:^(BOOL succeed, HDDiagonsisEntity *entity) {
        RemoveLoading;
        if (succeed) {
            HDDiagonsisViewController *diagonsisVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDDiagonsisViewController"];
            diagonsisVC.entity = entity;
            [self.navigationController pushViewController:diagonsisVC animated:YES];
        } else {
            ShowText(@"网络请求失败，请稍后重试", 2);
        }
    }];
}

- (void)clearHistoryData
{
    [HDCoreDataManager deleteChatMessage:self.groupGuid];
}

#pragma -mark cellDelegate

- (void)didClickToExistGroup
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    ShowLoading(@"数据加载中");
    [HDGroupManager quitGroup:userEntity.userGuid groupId:self.groupGuid completBlock:^(BOOL succeed) {
        RemoveLoading;
        if (succeed) {
            [HDCoreDataManager deleteGroup:self.groupGuid];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HDGroupDataChange" object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            ShowText(@"网络请求失败，请稍后重试", 2);
        }
    }];
}


#pragma -mark noDataView Delegate

- (void)didSelectButtonToRefresh
{
    [self.noDataView removeFromSuperview];
    [self loadData];
}

#pragma -mark

- (void)loadData
{
    ShowLoading(@"数据加载中");
    [HDGroupManager requestGetGroupMember:self.groupGuid completeBlock:^(BOOL succeed, NSArray *memberIDsArray) {
        RemoveLoading;
        if (succeed == NO) {
            ShowText(@"网络请求失败，请稍后重试", 2);
            [self.view addSubview:self.noDataView];
            return ;
        }
        
        self.memberIDArray = memberIDsArray;
        RLMResults *memberArray = [HDCoreDataManager getAddressBooksWithIds:self.memberIDArray];
        self.membersDataArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < memberArray.count; i ++) {
            HDMemberEntity *obj = [memberArray objectAtIndex:i];
            HDGroupMemberCellModel *model = [[HDGroupMemberCellModel alloc] init];
            model.memberId = obj.userGuid;
            model.memberName = obj.userName;
            model.memberHeadURL = obj.userHeadURL;
            model.type = NormalMemberCell;
            model.isCompany = [obj.isCompany boolValue];
            [self.membersDataArray addObject:model];
        }
        HDGroupMemberCellModel *model = [[HDGroupMemberCellModel alloc] init];
        model.type = AddMemberCell;
        [self.membersDataArray addObject:model];
        
        NSInteger remainder = self.membersDataArray.count%5;
        if (remainder != 0) {
            for (int i = 0; i < 5 - remainder; i ++) {
                HDGroupMemberCellModel *model = [[HDGroupMemberCellModel alloc] init];
                model.type = EmptyCell;
                [self.membersDataArray addObject:model];
            }
        }
        [self loadNormalData];
        [self.collectionView reloadData];
    }];
}

- (void)loadNormalData
{
    HDChatGroupEntity *chatGroupEntity = [HDCoreDataManager getChatGroupWithGuid:self.groupGuid];
    HDGroupMemberNormalCellModel *countModel = [[HDGroupMemberNormalCellModel alloc] init];
    countModel.cellType = MemberCountCell;
    countModel.title = @"成员数量";
    countModel.content = [NSString stringWithFormat:@"%lu人", self.memberIDArray.count];
    countModel.isHideLine = YES;
    
    HDGroupMemberNormalCellModel *ownerModel = [[HDGroupMemberNormalCellModel alloc] init];
    ownerModel.cellType = GroupOwnerCell;
    ownerModel.title = @"群主";
    ownerModel.content = chatGroupEntity.groupOwnerName;
    
    HDGroupMemberNormalCellModel *nameModel = [[HDGroupMemberNormalCellModel alloc] init];
    nameModel.cellType = GroupNameCell;
    nameModel.title = @"群名称";
    nameModel.content = chatGroupEntity.groupdName;
    nameModel.isCanSelect = YES;
    
    HDGroupMemberNormalCellModel *qrModel = [[HDGroupMemberNormalCellModel alloc] init];
    qrModel.cellType = GroupQRCell;
    qrModel.title = @"群二维码";
    qrModel.content = chatGroupEntity.groupQRImageURL;
    
    HDGroupMemberNormalCellModel *postModel = [[HDGroupMemberNormalCellModel alloc] init];
    postModel.cellType = GroupPostCell;
    postModel.title = @"群公告";
    if (chatGroupEntity.groupPost.length > 0 && ![chatGroupEntity.groupPost isEqualToString:@"null"]) {
        postModel.content = chatGroupEntity.groupPost;
    } else {
        postModel.content = @"";
    }
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    postModel.isCanSelect = [chatGroupEntity.groupOwnerId isEqualToString:userEntity.userGuid];
    
    HDGroupMemberNormalCellModel *synchronizeModel = [[HDGroupMemberNormalCellModel alloc] init];
    synchronizeModel.cellType = GroupSynchronize;
    synchronizeModel.title = @"同步聊天记录";
    synchronizeModel.isCanSelect = NO;

    self.normalDataArray = [NSMutableArray arrayWithCapacity:4];
    [self.normalDataArray addObject:countModel];
    [self.normalDataArray addObject:ownerModel];
    [self.normalDataArray addObject:nameModel];
    [self.normalDataArray addObject:qrModel];
    [self.normalDataArray addObject:postModel];
    [self.normalDataArray addObject:synchronizeModel];
    
    if ([chatGroupEntity.groupProperty integerValue] == 100) {
        HDGroupMemberNormalCellModel *diagnosisModel = [[HDGroupMemberNormalCellModel alloc] init];
        diagnosisModel.cellType = GroupDiagnosisCell;
        diagnosisModel.title = @"诊断";
        diagnosisModel.isCanSelect = YES;
        [self.normalDataArray addObject:diagnosisModel];
    }
    
//    HDGroupMemberNormalCellModel *clearModel = [[HDGroupMemberNormalCellModel alloc] init];
//    clearModel.cellType = GroupClearCell;
//    clearModel.title = @"删除历史数据";
//    clearModel.isCanSelect = NO;
//    [self.normalDataArray addObject:clearModel];
    
    if ([chatGroupEntity.groupOwnerId isEqualToString:userEntity.userGuid]) {
        self.footDataArray = [NSMutableArray array];
    } else {
        self.footDataArray = [NSMutableArray arrayWithObjects:@"", nil];
    }
    [self.collectionView reloadData];
}

@end
