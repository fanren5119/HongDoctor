//
//  HDMainDetailViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMainDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GWEncodeHelper.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "JWCacheURLProtocol.h"
#import "HDMainNoDataView.h"

@interface HDMainDetailViewController () <UIWebViewDelegate, HDMainNoDataViewDelegate>

@property (nonatomic, strong) UIWebView             *webView;
@property (nonatomic, strong) NSString              *backPage;
@property (nonatomic, strong) HLBarButtonItem       *backItem;
@property (nonatomic, strong) JSContext             *context;
@property (nonatomic, strong) NSString              *nextWebString;
@property (nonatomic, strong) HDMainNoDataView      *noDataView;

@end

@implementation HDMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.detailTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupBackItem];
    [self setupWebView];
    [self setupNoDataView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setupBackItem
{
    self.backItem = [[HLBarButtonItem alloc] initWithTitle:self.backTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (void)setupWebView
{
    [JWCacheURLProtocol startListeningNetWorking];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __weak HDMainDetailViewController *detailVC = (HDMainDetailViewController *)self;
    self.context[@"setHeadTitle"] = ^(NSString *string) {
        NSLog(@"===%@", string);
        detailVC.nextWebString = string;
    };
}

- (void)setupNoDataView
{
    self.noDataView = [[HDMainNoDataView alloc] initWithFrame:self.webView.frame];
    self.noDataView.delegate = self;
}


#pragma -mark responds

- (void)respondsToBackItem
{
    if (self.isPopToRoot) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}


#pragma -mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [request.URL absoluteString];
    if ([self.url isEqualToString:urlString]) {
        return YES;
    }
    if ([urlString isEqualToString:@"about:blank"]) {
        return NO;
    }
    NSArray *array = [self.nextWebString componentsSeparatedByString:@","];
    HDMainDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDMainDetailViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    if (array.count > 0) {
        detailVC.detailTitle = array[0];
        detailVC.backTitle = self.detailTitle;
    } else {
        detailVC.detailTitle = self.detailTitle;
        detailVC.backTitle = self.backTitle;
    }
    detailVC.url = urlString;
    if (array.count > 1) {
        NSInteger num = [array[1] integerValue];
        detailVC.isPopToRoot = (num == 0);
    } else {
        detailVC.isPopToRoot = YES;
    }

    [self.navigationController pushViewController:detailVC animated:NO];
    return NO;
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
    [self.view addSubview:self.noDataView];
}

#pragma -mark noDataView

- (void)didSelectButtonToRefresh
{
    [self.noDataView removeFromSuperview];
    NSURL *url = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
