//
//  HDModifyPhoneViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDModifyPhoneViewController.h"
#import "HDUserEntity.h"
#import "HDLocalDataManager.h"
#import "HDUserManager.h"
#import "HDModifyUserEntity.h"

@interface HDModifyPhoneViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) HDUserEntity       *userEntity;

@end

@implementation HDModifyPhoneViewController

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
    self.navigationItem.title = @"修改手机号";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(responsToSureBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupTextField
{
    self.userEntity = [HDLocalDataManager getUserEntity];
    self.phoneTextField.text = self.userEntity.phone;
    self.phoneTextField.delegate = self;
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

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)responsToSureBarButtonItem
{
    
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.userEntity.phone isEqualToString:phone]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    HDModifyUserEntity *userEntity = [[HDModifyUserEntity alloc] init];
    userEntity.userGuid = self.userEntity.userGuid;
    userEntity.phone = phone;
    userEntity.type = ModifyPhone;
    ShowLoading(@"数据加载中");
    [HDUserManager requestToModifyUser:userEntity completeBlock:^(BOOL succeed, NSString *content) {
        RemoveLoading;
        if (succeed) {
            self.userEntity.phone = phone;
            NSString *string = [self.userEntity deserializer];
            [HDLocalDataManager saveUserWithString:string];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowText(@"修改用户信息失败", 1);
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self responsToSureBarButtonItem];
    return YES;
}

@end
