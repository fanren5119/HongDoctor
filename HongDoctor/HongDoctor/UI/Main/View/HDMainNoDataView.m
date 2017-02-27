//
//  HDMainNoDataView.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/13.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDMainNoDataView.h"

@interface HDMainNoDataView ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIButton    *button;

@end

@implementation HDMainNoDataView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createImageView];
    [self createButton];
}

- (void)createImageView
{
    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.image = [UIImage imageNamed:@"noData.png"];
    [self addSubview:self.mainImageView];
}

- (void)createButton
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor clearColor];
    [self.button addTarget:self action:@selector(respondsToRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mainImageView.frame = CGRectMake(0, 0, 144, 144);
    self.mainImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.button.frame = self.bounds;
}

- (void)respondsToRefreshButton
{
    if ([self.delegate respondsToSelector:@selector(didSelectButtonToRefresh)]) {
        [self.delegate didSelectButtonToRefresh];
    }
}

@end
