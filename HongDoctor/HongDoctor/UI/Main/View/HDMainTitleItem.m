//
//  HDMainTitleItem.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDMainTitleItem.h"
#import "UIImageView+WebCache.h"

@interface HDMainTitleItem ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *bageLabel;

@end

@implementation HDMainTitleItem

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
    [self createTitleLabel];
    [self createBageLabel];
}

- (void)createImageView
{
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
}

- (void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

- (void)createBageLabel
{
    self.bageLabel = [[UILabel alloc] init];
    self.bageLabel.textColor = [UIColor whiteColor];
    self.bageLabel.font = [UIFont systemFontOfSize:10];
    self.bageLabel.textAlignment = NSTextAlignmentCenter;
    self.bageLabel.backgroundColor = [UIColor redColor];
    self.bageLabel.layer.cornerRadius = 10;
    self.bageLabel.layer.masksToBounds = YES;
    [self addSubview:self.bageLabel];
    self.bageLabel.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 73)/2, 50, 50);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 3, self.frame.size.width, 20);
    CGFloat width = 20;
    self.bageLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) - width/2 + 2, self.imageView.frame.origin.y - width/2 + 5, width, width);
}


#pragma mark - public

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)setWebImageWithURL:(NSString *)imageURL
{
    NSURL *url = [NSURL URLWithString:imageURL];
    [self.imageView sd_setImageWithURL:url];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setBageValue:(NSInteger)bageValue
{
    if (bageValue > 0) {
        self.bageLabel.hidden = NO;
        if (bageValue < 100) {
            self.bageLabel.text = [NSString stringWithFormat:@"%ld", (long)bageValue];
        } else {
            self.bageLabel.text = @"99+";
        }
    } else {
        self.bageLabel.hidden = YES;
    }
}

@end
