//
//  HDMainViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMainViewController.h"
#import "HDLocalDataManager.h"
#import "HDMainTitleItem.h"
#import "HDIconEntity.h"
#import "UIButton+WebCache.h"
#import <WebKit/WebKit.h>
#import "HDQRViewController.h"
#import "HDMainDetailViewController.h"
#import "HDMainHeaderView.h"
#import "HDMainItemSelectView.h"
#import "HDMainHeaderEntity.h"
#import "HDLoginManager.h"
#import "HDUserEntity.h"
#import "HDGetIntervalMessageManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JWCacheURLProtocol.h"
#import "HDMainNoDataView.h"
#import "HDMainTitleEntity.h"
#import "AppDelegate.h"

@interface HDMainViewController () <HDMainHeaderViewDelegate, HDMainItemSelectViewDelegate, UIWebViewDelegate, HDMainNoDataViewDelegate>

@property (nonatomic, strong) UIWebView                 *webView;
@property (nonatomic, strong) UIView                    *titleView;
@property (nonatomic, strong) HDMainHeaderView          *headerView;
@property (nonatomic, strong) HDMainItemSelectView      *selectView;
@property (nonatomic, assign) BOOL                      isShowSelectView;
@property (nonatomic, strong) NSMutableArray            *buttonArray;
@property (nonatomic, strong) NSArray                   *mainTitleArray;
@property (nonatomic, strong) NSString                  *nextWebString;
@property (nonatomic, strong) HDMainNoDataView          *noDataView;

@end

@implementation HDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self registerNotification];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.headerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectView hide];
    [self.headerView removeFromSuperview];
}

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupHeaderView];
    [self setupTitleView];
    [self setupButtons];
    [self setupWebView];
    [self setupSelectView];
    ShowLoading(@"数据加载中...");
}

- (void)setupNavigationBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupHeaderView
{
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"HDMainHeaderView" owner:nil options:nil][0];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.headerView.delegate = self;
}

- (void)setupTitleView
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height =  width / 4.0  + 20;
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.titleView.backgroundColor = ColorFromRGB(0x00A0E9);
    [self.view addSubview:self.titleView];
}

- (void)setupButtons
{
    self.buttonArray = [NSMutableArray array];
    NSInteger count = self.mainTitleArray.count;
    if (count <= 0) {
        return;
    }
    CGFloat width = [[UIScreen mainScreen] bounds].size.width / count;
    CGFloat height =  self.titleView.frame.size.height;
    for (int i = 0; i < count; i ++) {
        HDMainTitleItem *btn = [[HDMainTitleItem alloc] initWithFrame:CGRectZero];
        btn.frame = CGRectMake(i*width, 0, width, height);
        [btn addTarget:self action:@selector(respondsToselectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        HDMainTitleEntity *tilteEntity = self.mainTitleArray[i];
        [btn setTitle:tilteEntity.name];
        [btn setWebImageWithURL:tilteEntity.imageURL];
        [btn setBageValue:tilteEntity.number.integerValue];
        [self.titleView addSubview:btn];
        [self.buttonArray addObject:btn];
    }
}

- (void)setupWebView
{
    [JWCacheURLProtocol startListeningNetWorking];
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.titleView.frame) - 50 - 62);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"setHeadTitle"] = ^(NSString *string) {
        self.nextWebString = string;
    };
    
    [self loadWebRequest];
}

- (void)setupSelectView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64);
    NSArray *mainHeader = [HDLocalDataManager getMainHeaderArray];
    self.selectView = [[HDMainItemSelectView alloc] initWithFrame:rect dataArray:mainHeader];
    self.selectView.delegate = self;
}

- (void)setupNoDataView
{
    self.noDataView = [[HDMainNoDataView alloc] initWithFrame:self.webView.frame];
    self.noDataView.delegate = self;
}

- (void)loadWebRequest
{
    NSString *mainURLString = [HDLocalDataManager getMainURLString];
    NSURL *url = [NSURL URLWithString:mainURLString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToBageNumChange:) name:@"HDMainBageNumChange" object:nil];
}


#pragma -mark responds

- (void)selectorToBageNumChange:(NSNotification *)not
{
    NSArray *array = [not.userInfo objectForKey:@"numbers"];
    if (array.count >= 4) {
        NSArray *bageArray = [array subarrayWithRange:NSMakeRange(0, 4)];
        
        for (HDMainTitleItem *titleItem in self.buttonArray) {
            if (titleItem.tag < bageArray.count) {
                NSInteger bage = [bageArray[titleItem.tag] integerValue];
                [titleItem setBageValue:bage];
            }
        }
    }
}

- (void)respondsToselectedTab:(HDMainTitleItem *)button
{
    [self.view endEditing:YES];
    
    HDMainTitleEntity *titleEntity = self.mainTitleArray[button.tag];
    NSInteger isRransferNative = [titleEntity.isRransferNative integerValue];
    NSInteger nativeFunc = [titleEntity.nativeFunc integerValue];
    if (nativeFunc == 1 && isRransferNative == 1) {
        HDQRViewController *qrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDQRViewController"];
        qrVC.urlString = titleEntity.url;
        qrVC.backItemTitle = @"业务";
        qrVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrVC animated:YES];
    } else {
        HDMainDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMainDetailViewController"];
        detailVC.url = titleEntity.url;
        detailVC.detailTitle = titleEntity.name;
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.isPopToRoot = YES;
        detailVC.backTitle = @"业务";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma -mark WebView Delegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *mainURLString = [HDLocalDataManager getMainURLString];
    NSString *urlString = [request.URL absoluteString];
    if ([mainURLString isEqualToString:urlString]) {
        return YES;
    }
    NSArray *array = [self.nextWebString componentsSeparatedByString:@","];
    HDMainDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMainDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    if (array.count > 0) {
        detailVC.detailTitle = array[0];
    }
    detailVC.url = urlString;
    detailVC.backTitle = @"业务";
    detailVC.isPopToRoot = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    RemoveLoading;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    RemoveLoading;
    ShowText(@"网络请求失败，请稍后重试", 2);
    [self.view addSubview:self.noDataView];
}


#pragma -mark headerView delegate

- (void)didSelectHeadImageView
{
    [self.view endEditing:YES];
}
- (void)didSelectToSearchWithText:(NSString *)text
{
    [self.view endEditing:YES];
    NSString *searchURLString = [HDLocalDataManager getSearchUrlString];
    searchURLString = [searchURLString stringByAppendingString:text];
    HDMainDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMainDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.url = searchURLString;
    detailVC.detailTitle = @"搜索";
    detailVC.isPopToRoot = YES;
    detailVC.backTitle = @"业务";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didSelectToAddButton
{
    [self.view endEditing:YES];
    if (self.isShowSelectView) {
        [self.selectView hide];
    } else {
        [self.view addSubview:self.selectView];
        self.isShowSelectView = YES;
    }

}

#pragma -mark noDataView delegate

- (void)didSelectButtonToRefresh
{
    [self.noDataView removeFromSuperview];
    [self loadWebRequest];
}

#pragma -mark selectView delegate

- (void)didSelectWithEntity:(HDMainHeaderEntity *)entity
{
    HDMainDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMainDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.url = entity.accessURL;
    detailVC.detailTitle = entity.title;
    detailVC.isPopToRoot = YES;
    detailVC.backTitle = @"业务";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didClickToHideView
{
    self.isShowSelectView = NO;
}


#pragma -mark loadData

- (void)loadData
{

}

- (NSArray *)mainTitleArray
{
    if (_mainTitleArray == nil) {
        _mainTitleArray = [HDLocalDataManager getMainTitleArray];
    }
    return _mainTitleArray;
}

@end
