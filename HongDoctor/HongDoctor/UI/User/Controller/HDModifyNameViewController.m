//
//  HDModifyNameViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDModifyNameViewController.h"
#import "HDUserEntity.h"
#import "HDLocalDataManager.h"
#import "HDUserManager.h"
#import "HDModifyUserEntity.h"

@interface HDModifyNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) HDUserEntity       *userEntity;

@end

@implementation HDModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupTextField];
    [self addGesture];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"修改昵称";
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTextField
{
    self.userEntity = [HDLocalDataManager getUserEntity];
    self.nameTextField.text = self.userEntity.userName;
    self.nameTextField.delegate = self;
}


- (void)addGesture
{
    UITapGestureRecognizer *tagGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    [self.view addGestureRecognizer:tagGest];
}

- (void)respondsToTapGesture
{
    [self.view endEditing:YES];
}

- (void)responsToSureBarButtonItem
{
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.userEntity.userName isEqualToString:name]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    HDModifyUserEntity *userEntity = [[HDModifyUserEntity alloc] init];
    userEntity.userGuid = self.userEntity.userGuid;
    userEntity.userName = name;
    userEntity.type = ModifyName;
    ShowLoading(@"数据加载中");
    [HDUserManager requestToModifyUser:userEntity completeBlock:^(BOOL succeed, NSString *content) {
        RemoveLoading;
        if (succeed) {
            self.userEntity.userName = name;
            NSString *string = [self.userEntity deserializer];
            [HDLocalDataManager saveUserWithString:string];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowText(@"修改用户信息失败", 1);
        }
    }];
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self responsToSureBarButtonItem];
    return YES;
}

@end
