//
//  HDModifySexViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDModifySexViewController.h"
#import "HDUserEntity.h"
#import "HDLocalDataManager.h"
#import "HDUserManager.h"
#import "HDModifyUserEntity.h"

@interface HDModifySexViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *manSignImageView;
@property (weak, nonatomic) IBOutlet UIImageView *womanSignImageView;
@property (nonatomic, strong) HDUserEntity       *userEntity;
@property (nonatomic, strong) NSString           *sex;

@end

@implementation HDModifySexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupImageViews];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"修改性别";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(responsToSureBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupImageViews
{
    self.userEntity = [HDLocalDataManager getUserEntity];
    if ([self.userEntity.sex isEqualToString:@"1"]) {
        self.womanSignImageView.image = [UIImage imageNamed:@"User_sex_noSelect"];
        self.manSignImageView.image = [UIImage imageNamed:@"User_sex_select"];
    } else {
        self.manSignImageView.image = [UIImage imageNamed:@"User_sex_noSelect"];
        self.womanSignImageView.image = [UIImage imageNamed:@"User_sex_select"];
    }
}


#pragma -mark responds

- (IBAction)respondsToSelectManButton:(id)sender
{
    self.womanSignImageView.image = [UIImage imageNamed:@"User_sex_noSelect"];
    self.manSignImageView.image = [UIImage imageNamed:@"User_sex_select"];
    self.sex = @"1";
}

- (IBAction)respondsToSelectWomenButton:(id)sender
{
    self.manSignImageView.image = [UIImage imageNamed:@"User_sex_noSelect"];
    self.womanSignImageView.image = [UIImage imageNamed:@"User_sex_select"];
    self.sex = @"0";
}

- (void)responsToSureBarButtonItem
{
    if ([self.userEntity.sex isEqualToString:self.sex]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    HDModifyUserEntity *userEntity = [[HDModifyUserEntity alloc] init];
    userEntity.userGuid = self.userEntity.userGuid;
    userEntity.sex = self.sex;
    userEntity.type = ModifySex;
    ShowLoading(@"数据加载中");
    [HDUserManager requestToModifyUser:userEntity completeBlock:^(BOOL succeed, NSString *content) {
        RemoveLoading;
        if (succeed) {
            self.userEntity.sex = self.sex;
            NSString *string = [self.userEntity deserializer];
            [HDLocalDataManager saveUserWithString:string];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowText(@"用户信息修改失败", 1);
        }
    }];
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
