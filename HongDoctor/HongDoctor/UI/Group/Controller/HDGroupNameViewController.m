//
//  HDGroupNameViewController.m
//  HongDoctor
//
//  Created by wanglei on 2017/1/13.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDGroupNameViewController.h"
#import "HDGroupManager.h"
#import "HDModifyGroupEntity.h"
#import "HDUserEntity.h"
#import "HDCoreDataManager.h"

@interface HDGroupNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation HDGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    
    self.textField.text = self.groupName;
    self.textField.delegate = self;
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"修改群名称";
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToRightBarButtonItem
{
    [self.view endEditing:YES];
    NSString *text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text == nil || text.length <= 0) {
        BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:@"请输入修改的群名称" viewController:self];
        RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定"];
        [alert addButton:okItem type:RIButtonItemType_Other];
        [alert show];
        return;
    }
    ShowLoading(@"数据加载中")
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    HDModifyGroupEntity *entity = [[HDModifyGroupEntity alloc] init];
    entity.userGuid = userEntity.userGuid;
    entity.groupGuid = self.groupGuid;
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *newName = [text stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    entity.groupName = newName;
    entity.type = ModifyGroupName;
    [HDGroupManager requestModifyGroup:entity completeBlock:^(BOOL succeed) {
        RemoveLoading;
        if (succeed) {
            [HDCoreDataManager modifyGroup:self.groupGuid groupName:text];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HDGroupNameChangeNotification" object:nil userInfo:@{@"groupName": text}];
            if (self.modifyHandler) {
                self.modifyHandler(text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self respondsToRightBarButtonItem];
    return YES;
}

@end
