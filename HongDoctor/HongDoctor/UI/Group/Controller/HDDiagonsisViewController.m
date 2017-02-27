//
//  HDDiagonsisViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDDiagonsisViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GWEncodeHelper.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "JWCacheURLProtocol.h"
#import "HDMainNoDataView.h"
#import "HDDiagonsisEntity.h"
#import "HDDiagonsisBottomEntity.h"
#import "TimingTabBarItem.h"
#import "HDMessageViewController.h"
#import "HDChatGroupEntity.h"
#import "HDCoreDataManager.h"

@interface HDDiagonsisViewController ()<UIWebViewDelegate, HDMainNoDataViewDelegate>

@property (nonatomic, strong) UIWebView             *webView;
@property (nonatomic, strong) NSString              *backPage;
@property (nonatomic, strong) HLBarButtonItem       *backItem;
@property (nonatomic, strong) JSContext             *context;
@property (nonatomic, strong) NSString              *nextWebString;
@property (nonatomic, strong) HDMainNoDataView      *noDataView;
@property (nonatomic, strong) UIView                *bottomView;
@property (nonatomic, strong) TimingTabBarItem      *selectButton;
@property (nonatomic, strong) NSMutableArray        *buttonArray;

@end

@implementation HDDiagonsisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:self.entity.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupWebView];
    [self setupNoDataView];
    [self setupBottomView];
    [self setupLineView];
    [self setupBottomItems];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = self.entity.title;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backItem = [[HLBarButtonItem alloc] initWithTitle:@"群详情" image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (void)setupWebView
{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)setupNoDataView
{
    self.noDataView = [[HDMainNoDataView alloc] initWithFrame:self.webView.frame];
    self.noDataView.delegate = self;
}

- (void)setupBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 - 64, self.view.frame.size.width, 50)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
}

- (void)setupLineView
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = ColorFromRGB(0xdddddd);
    [self.bottomView addSubview:lineView];
}

- (void)setupBottomItems
{
    int viewCount = (int)self.entity.bottomArray.count;
    double _width = [[UIScreen mainScreen] bounds].size.width / viewCount;
    double _height = 50;
    
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < viewCount; i++) {
        TimingTabBarItem *btn = [[TimingTabBarItem alloc] initWithFrame:CGRectZero];
        btn.frame = CGRectMake(i*_width, 0, _width, _height);
        [btn addTarget:self action:@selector(respondsToselectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        HDDiagonsisBottomEntity *entity = self.entity.bottomArray[i];
        [btn setTitle:entity.name];
        [btn setTitleColor:ColorFromRGB(0x999999) selectColor:ColorFromRGB(0x00A0E9)];
        [btn setwebImage:entity.imageURL selectImage:entity.selectImageURL];
        if (i == 0) {
            self.selectButton = btn;
            btn.selected = YES;
        }
        else {
            btn.selected = NO;
        }
        [self.bottomView addSubview:btn];
        [self.buttonArray addObject:btn];
    }
}


#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)respondsToselectedTab:(TimingTabBarItem *)button
{
    if (self.selectButton == button) {
        return;
    }
    
    button.selected = YES;
    self.selectButton.selected = NO;
    self.selectButton = button;
    
    HDDiagonsisBottomEntity *entity = self.entity.bottomArray[button.tag];
    if ([entity.type integerValue] == 0) {
        NSURL *webURL = [NSURL URLWithString:entity.remark];
        [self.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
    } else {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[HDMessageViewController class]]) {
                [self.navigationController popToViewController:vc animated:NO];
                return;
            }
        }
        
        HDChatGroupEntity *groupEntity = [HDCoreDataManager getChatGroupWithGuid:entity.remark];
        HDMessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
        messageVC.hidesBottomBarWhenPushed = YES;
        messageVC.groupGuid = groupEntity.groupGuid;
        messageVC.groupName = groupEntity.groupdName;
        messageVC.groupProperty = groupEntity.groupProperty;
        messageVC.isPopToGroupVC = YES;
        messageVC.groupMemberCount = [groupEntity.groupMemberCount integerValue];
        [self.navigationController pushViewController:messageVC animated:NO];
    }
}


#pragma -mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    ShowLoading(@"数据加载中");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    RemoveLoading;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    RemoveLoading;
    ShowText(@"网络请求失败，请稍后重试", 2);
}

#pragma -mark noDataView

- (void)didSelectButtonToRefresh
{
    [self.noDataView removeFromSuperview];
    NSURL *url = [NSURL URLWithString:self.entity.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


@end
