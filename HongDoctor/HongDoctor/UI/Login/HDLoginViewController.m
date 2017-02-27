//
//  HDLoginViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDLoginViewController.h"
#import "HDLoginManager.h"
#import "HDTabBarController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HDGetIntervalMessageManager.h"
#import "HDRegisterViewController.h"
#import "HDFindPasswordViewController.h"
#import "HDAutoServerManager.h"

@interface HDLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) NSString *headURL;

@end

@implementation HDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigation];
    [self setupHeadImageView];
    [self setupTextField];
    [self addGesture];
}


#pragma -mark setupUI

- (void)setupNavigation
{
    NSString *title = [HDLocalDataManager getStartTitle];
    self.navigationItem.title = title;
}

- (void)setupHeadImageView
{
    self.headURL = [HDLocalDataManager getLoginHeadURL];
    NSURL *url = [NSURL URLWithString:self.headURL];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
}

- (void)setupTextField
{
    NSString *phone = [HDLocalDataManager getLoginNumber];
    NSString *password = [HDLocalDataManager getLoginPassword];
    self.phoneTextField.text = phone;
    self.passwordTextField.text = password;
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    [self.view addGestureRecognizer:tapGesture];
}



#pragma -mark responds

- (void)respondsToTapGesture
{
    [self.view endEditing:YES];
}

- (IBAction)respondsToLoginButton:(id)sender
{
    NSCharacterSet *character = [NSCharacterSet whitespaceCharacterSet];
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:character];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:character];
    if (phone == nil || phone.length <= 0) {
        [self showAlert:@"请输入账号"];
        return;
    }
    
    if (password == nil || password.length <= 0) {
        [self showAlert:@"请输入密码"];
        return;
    }
    ShowLoading(@"登录中");
    
    [HDLoginManager requestLoginWithPhone:phone password:password completeBlock:^(BOOL succeed, NSString *message) {
        RemoveLoading;
        if (succeed) {
            [HDLocalDataManager saveLoginNumber:phone];
            [HDLocalDataManager saveLoginPassword:password];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app goMainVC];
            [[HDAutoServerManager shareManager] autoGetBeginData:nil];
        } else if ([message isEqualToString:@"error"]){
            ShowText(@"用户名或密码错误，请重试", 2);
        } else {
            ShowText(@"登录失败，请重新尝试", 2);
        }
    }];
}

- (IBAction)respondsToFindPasswordButton:(id)sender
{
    HDFindPasswordViewController *findPswVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDFindPasswordViewController"];
    [self.navigationController pushViewController:findPswVC animated:YES];
}

- (IBAction)respondsToRegisterButton:(id)sender
{
    HDRegisterViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDRegisterViewController"];
    registerVC.registerHandler = ^(NSString *phone) {
        self.phoneTextField.text = phone;
        self.passwordTextField.text = @"";
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}


#pragma -mark textField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        [self requestLoadHeadURL];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.view endEditing:YES];
        [self respondsToLoginButton:nil];
    }
    return YES;
}


#pragma -mark request

- (void)requestLoadHeadURL
{
    NSCharacterSet *character = [NSCharacterSet whitespaceCharacterSet];
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:character];
    if (phone == nil || phone.length <= 0) {
        return;
    }
    [HDLoginManager requestWithPhone:phone getLoginHead:^(NSString *headURL, BOOL succeed) {
        if (succeed) {
            if (![self.headURL isEqualToString:headURL]) {
                [HDLocalDataManager saveLoginHeadURL:headURL];                
                NSURL *url = [NSURL URLWithString:headURL];
                [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
            }
        }
    }];
}


#pragma -mark other

- (void)showAlert:(NSString *)message
{
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:message viewController:self];
    RIButtonItem *okItme = [RIButtonItem itemWithLabel:@"确定"];
    [alert addButton:okItme type:RIButtonItemType_Other];
    [alert show];
}
@end
