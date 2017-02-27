//
//  HDFindPasswordViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDFindPasswordViewController.h"
#import "JWCacheURLProtocol.h"

@interface HDFindPasswordViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *backPage;
@property (nonatomic, strong) HLBarButtonItem *backItem;
@property (nonatomic, strong) NSString *reigsterURL;

@end

@implementation HDFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"忘记密码";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupBackItem];
    [self setupWebView];
}

- (void)setupBackItem
{
    self.backItem = [[HLBarButtonItem alloc] initWithTitle:@"登录" image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (void)setupWebView
{
    [JWCacheURLProtocol startListeningNetWorking];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *reigsterURL = [HDLocalDataManager getFindPasswordURL];
    NSURL *url = [NSURL URLWithString:reigsterURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *mainURLString = [HDLocalDataManager getFindPasswordURL];
    NSString *urlString = [request.URL absoluteString];
    if ([mainURLString isEqualToString:urlString]) {
        return YES;
    }
    NSArray *paramterArray = [urlString componentsSeparatedByString:@":"];
    if (paramterArray.count > 1 && [paramterArray[0] isEqualToString:@"backlogin"]) {
        NSArray *array = [paramterArray[1] componentsSeparatedByString:@"KHCLCHK"];
        if (array.count <= 0) {
            return NO;
        }
        [self performSelector:@selector(selectorToFindPswSuccess) withObject:nil afterDelay:1.5];
    }
    return NO;
}

- (void)selectorToFindPswSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [JWCacheURLProtocol cancelListeningNetWorking];
}


@end
