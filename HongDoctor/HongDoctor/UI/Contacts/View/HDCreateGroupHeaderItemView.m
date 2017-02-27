//
//  HDCreateGroupHeaderItemView.m
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDCreateGroupHeaderItemView.h"
#import "UIImageView+WebCache.h"

@interface HDCreateGroupHeaderItemView ()

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel     *titleLabel;

@end

@implementation HDCreateGroupHeaderItemView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createContentImageView];
    [self createTitleLabel];
}

- (void)createContentImageView
{
    self.contentImageView = [[UIImageView alloc] init];
    [self addSubview:self.contentImageView];
}

- (void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ColorFromRGB(0x313131);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentImageView.frame = CGRectMake(5, 6, 50, 50);
    self.titleLabel.frame = CGRectMake(0, 58, self.frame.size.width, 16);
}

- (void)resetViewWithTitle:(NSString *)title imageURL:(NSString *)imageURL
{
    NSURL *url = [NSURL URLWithString:imageURL];
    [self.contentImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    self.titleLabel.text = title;
}

@end
