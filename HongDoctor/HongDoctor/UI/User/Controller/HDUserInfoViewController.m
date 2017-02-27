//
//  HDUserInfoViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserInfoViewController.h"
#import "HDUserInfoHeadCell.h"
#import "HDUserInfoGradeCell.h"
#import "HDUserInfoNormalCell.h"
#import "HDUserInfoCanEditCell.h"
#import "HDUserInfoQRCell.h"
#import "HDUserInfoCellModel.h"
#import "HDUserEntity.h"

#import "HDModifyNameViewController.h"
#import "HDModifySexViewController.h"
#import "HDModifyPhoneViewController.h"
#import "TimingImagePickerManager.h"
#import "HDUserQRViewController.h"

@interface HDUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;

@end

@implementation HDUserInfoViewController

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
        case UserInfoSexCell:
        case UserInfoPhoneCell:
        {
            HDUserInfoCanEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDUserInfoCanEditCell" forIndexPath:indexPath];
            [cell resetCellWithModel:model];
            return cell;
        }
            break;
        case UserInfoNumberCell:
        case UserInfoCompanyCell:
        case UserInfoTrueNameCell:
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
            HDUserInfoQRCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HDUserInfoQRCell" forIndexPath:indexPath];
            [cell resetCellWithModel:model];
            return cell;
        }
        default:
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDUserInfoCellModel *model = self.dataSourceArray[indexPath.row];
    switch (model.cellType) {
        case UserInfoHeadCell:
        {
            TimingImagePickerManager *manager = [TimingImagePickerManager shareManager];
            manager.success = ^ (NSString *imageId) {
                model.content = imageId;
                [self.tableView reloadData];
            };
            [manager imagePickerPresentFromViewController:self];
        }
            break;
        case UserInfoNickNameCell:
        {
            HDModifyNameViewController *modifyNameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDModifyNameViewController"];
            modifyNameVC.backItemTitle = @"详细资料";
            [self.navigationController pushViewController:modifyNameVC animated:YES];
        }
            break;
        case UserInfoSexCell:
        {
            HDModifySexViewController *modifySexVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDModifySexViewController"];
            modifySexVC.backItemTitle = @"详细资料";
            [self.navigationController pushViewController:modifySexVC animated:YES];
        }
            break;
        case UserInfoPhoneCell:
        {
            HDModifyPhoneViewController *modifyPhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDModifyPhoneViewController"];
            modifyPhoneVC.backItemTitle = @"详细资料";
            [self.navigationController pushViewController:modifyPhoneVC animated:YES];
        }
            break;
        case UserInfoQRCode:
        {
            HDUserQRViewController *qrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserQRViewController"];
            qrVC.qrImageURL = model.content;
            [self.navigationController pushViewController:qrVC animated:YES];
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
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    HDUserInfoCellModel *headModel = [[HDUserInfoCellModel alloc] init];
    headModel.cellType = UserInfoHeadCell;
    headModel.title = @"头像";
    headModel.content = userEntity.userHeadURL;
    [self.dataSourceArray addObject:headModel];
    
    HDUserInfoCellModel *nickNameModel = [[HDUserInfoCellModel alloc] init];
    nickNameModel.cellType = UserInfoNickNameCell;
    nickNameModel.title = @"昵称";
    nickNameModel.content = userEntity.nickname;
    [self.dataSourceArray addObject:nickNameModel];
    
    HDUserInfoCellModel *trueNameModel = [[HDUserInfoCellModel alloc] init];
    trueNameModel.cellType = UserInfoNickNameCell;
    trueNameModel.title = @"真是姓名";
    trueNameModel.content = userEntity.userName;
    [self.dataSourceArray addObject:trueNameModel];
    
    HDUserInfoCellModel *numModel = [[HDUserInfoCellModel alloc] init];
    numModel.cellType = UserInfoNumberCell;
    numModel.title = @"账号";
    numModel.content = [HDLocalDataManager getLoginNumber];
    [self.dataSourceArray addObject:numModel];
    
    HDUserInfoCellModel *qrModel = [[HDUserInfoCellModel alloc] init];
    qrModel.cellType = UserInfoQRCode;
    qrModel.title = @"二维码";
    qrModel.content = userEntity.qrImageURL;
    [self.dataSourceArray addObject:qrModel];
    
    HDUserInfoCellModel *sexModel = [[HDUserInfoCellModel alloc] init];
    sexModel.cellType = UserInfoSexCell;
    sexModel.title = @"性别";
    if ([userEntity.sex isEqualToString:@"1"]) {
        sexModel.content = @"男";
    } else {
        sexModel.content = @"女";
    }
    [self.dataSourceArray addObject:sexModel];
    
    NSInteger grade = [userEntity.userGrade integerValue];
    if (grade > 0) {
        HDUserInfoCellModel *gradeModel = [[HDUserInfoCellModel alloc] init];
        gradeModel.cellType = UserInfoGradeCell;
        gradeModel.title = @"专家星级";
        gradeModel.content = userEntity.userGrade;
        [self.dataSourceArray addObject:gradeModel];
    }
    
    
    HDUserInfoCellModel *phoneModel = [[HDUserInfoCellModel alloc] init];
    phoneModel.cellType = UserInfoPhoneCell;
    phoneModel.title = @"手机号码";
    phoneModel.content = userEntity.phone;
    [self.dataSourceArray addObject:phoneModel];
    
    HDUserInfoCellModel *companyModel = [[HDUserInfoCellModel alloc] init];
    companyModel.cellType = UserInfoCompanyCell;
    companyModel.title = @"公司";
    companyModel.content = userEntity.orgname;
    [self.dataSourceArray addObject:companyModel];

    [self.tableView reloadData];
}

@end
