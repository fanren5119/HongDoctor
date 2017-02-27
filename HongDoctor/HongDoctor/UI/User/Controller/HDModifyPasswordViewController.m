//
//  HDModifyPasswordViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDModifyPasswordViewController.h"
#import "HDLocalDataManager.h"
#import "HDModifyUserEntity.h"
#import "HDUserEntity.h"
#import "HDUserManager.h"

@interface HDModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *modifyPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;


@end

@implementation HDModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigation];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"修改密码";
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)respondsToSureButton:(id)sender
{
    NSString *localPsw = [HDLocalDataManager getLoginPassword];
    NSString *oldPsw = [self.oldPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *nPsw = [self.modifyPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *surePsw = [self.surePasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (oldPsw == nil || oldPsw.length <= 0) {
        [self showAlert:@"请输入密码"];
        return;
    }
    
    if (nPsw == nil || oldPsw.length <= 0) {
        [self showAlert:@"请输入新密码"];
        return;
    }
    
    if (![nPsw isEqualToString:surePsw]) {
        [self showAlert:@"两次密码不一致"];
        return;
    }
    
    if (![oldPsw isEqualToString:localPsw]) {
        [self showAlert:@"请输入正确的原密码"];
        return;
    }
    
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    HDModifyUserEntity *entity = [[HDModifyUserEntity alloc] init];
    entity.userGuid = userEntity.userGuid;
    entity.password = nPsw;
    entity.type = ModifyPsw;
    ShowLoading(@"数据加载中");
    [HDUserManager requestToModifyUser:entity completeBlock:^(BOOL succeed, NSString *content) {
        RemoveLoading;
        if (succeed) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowLoading(@"密码修改失败，请重试");
        }
    }];
}

- (void)showAlert:(NSString *)message
{
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:message viewController:self];
    RIButtonItem *okItme = [RIButtonItem itemWithLabel:@"确定"];
    [alert addButton:okItme type:RIButtonItemType_Other];
    [alert show];
}


@end
