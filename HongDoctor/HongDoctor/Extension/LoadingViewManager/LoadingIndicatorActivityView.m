//
//  LoadingIndicatorActivityView.m
//  LoadingTest
//
//  Created by wanglei on 15/11/6.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "LoadingIndicatorActivityView.h"

@interface LoadingIndicatorActivityView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation LoadingIndicatorActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:self.indicatorView];
}

- (void)startAnimating
{
    [self.indicatorView startAnimating];
}

@end
