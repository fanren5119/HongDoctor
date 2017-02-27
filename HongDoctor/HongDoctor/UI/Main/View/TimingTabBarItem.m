//
//  TimingTabBarItem.m
//  Test
//
//  Created by wanglei on 2017/1/8.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "TimingTabBarItem.h"
#import "UIImageView+WebCache.h"

@interface TimingTabBarItem ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *bageLabel;
@property (nonatomic, strong) UIImage     *image;
@property (nonatomic, strong) UIImage     *selectImage;
@property (nonatomic, strong) UIColor     *color;
@property (nonatomic, strong) UIColor     *selectColor;

@property (nonatomic, strong) NSString    *imageURL;
@property (nonatomic, strong) NSString    *selectImageURL;

@end

@implementation TimingTabBarItem

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
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:10.0];
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
    self.imageView.frame = CGRectMake((self.frame.size.width - 25) / 2, (self.frame.size.height - 41)/2, 25, 25);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 3, self.frame.size.width, 13);
    CGFloat width = 20;
    self.bageLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) - width/2 + 2, self.imageView.frame.origin.y - width/2 + 5, width, width);
}


#pragma mark - public

- (void)setImage:(UIImage *)image selectImage:(UIImage *)selectImage
{
    self.image = image;
    self.selectImage = selectImage;
    self.imageView.image = image;
}

- (void)setwebImage:(NSString *)imageURL selectImage:(NSString *)selectImageURL
{
    self.imageURL = imageURL;
    self.selectImageURL = selectImageURL;
    NSURL *url = [NSURL URLWithString:imageURL];
    [self.imageView sd_setImageWithURL:url];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color selectColor:(UIColor *)selectColor
{
    self.titleLabel.textColor = color;
    self.color = color;
    self.selectColor = selectColor;
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

#pragma mark - action

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        if (self.image != nil) {
            self.imageView.image = self.selectImage;
        } else {
            NSURL *url = [NSURL URLWithString:self.selectImageURL];
            [self.imageView sd_setImageWithURL:url];
        }
        self.titleLabel.textColor = self.selectColor;
    } else {
        if (self.image != nil) {
            self.imageView.image = self.image;
        } else {
            NSURL *url = [NSURL URLWithString:self.imageURL];
            [self.imageView sd_setImageWithURL:url];
        }
        self.titleLabel.textColor = self.color;
    }
}

@end
