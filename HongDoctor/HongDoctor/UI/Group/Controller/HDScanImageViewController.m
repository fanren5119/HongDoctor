//
//  HDScanImageViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/17.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDScanImageViewController.h"
#import "UIImageView+WebCache.h"

@interface HDScanImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView          *scrollView;

@end

@implementation HDScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigation];
    [self setupScrollView];
    [self setupContentImageView];
    [self addGesture];
}

- (void)setupNavigation
{
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu", (long)self.currentIndex + 1, (unsigned long)self.imageArray.count];
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:self.backItemTitle image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.imageArray.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0);
}

- (void)setupContentImageView
{
    for (int i = 0; i < self.imageArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
        [imageView addGestureRecognizer:tapGesture];
        
        NSURL *url = [NSURL URLWithString:self.imageArray[i]];
        
        [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        [self.scrollView addSubview:imageView];
    }
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)respondsToTapGesture
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = ceil(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)page + 1, (unsigned long)self.imageArray.count];
}

@end
