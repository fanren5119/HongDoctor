//
//  HDUserQRViewController.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDUserQRViewController.h"
#import "UIImageView+WebCache.h"

@interface HDUserQRViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation HDUserQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupContentImageView];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"二维码";
}

- (void)setupContentImageView
{
    NSURL *imageURL = [NSURL URLWithString:self.qrImageURL];
    UIImage *placeholderImage = [UIImage imageNamed:@"User_QR.png"];
    [self.contentImageView sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
}


@end
