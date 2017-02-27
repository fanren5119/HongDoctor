//
//  HDEditPostViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDEditPostViewController.h"
#import "HDModifyGroupEntity.h"
#import "HDUserEntity.h"
#import "HDGroupManager.h"
#import "HDCoreDataManager.h"

@interface HDEditPostViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HDEditPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"发布群公告";
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    if (self.canEdit) {
        HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)setupTextView
{
    self.textView.text = self.groupPost;
    self.textView.editable = self.canEdit;
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToRightBarButtonItem
{
    [self.view endEditing:YES];
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text == nil || text.length <= 0) {
        BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:@"请输入群公告" viewController:self];
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
    NSString *newPost = [text stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    entity.groupPost = newPost;
    entity.type = ModifyGroupPost;
    [HDGroupManager requestModifyGroup:entity completeBlock:^(BOOL succeed) {
        RemoveLoading;
        if (succeed) {
            [HDCoreDataManager modifyGroup:self.groupGuid groupName:text];
            if (self.modifyHandler) {
                self.modifyHandler(text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


@end
