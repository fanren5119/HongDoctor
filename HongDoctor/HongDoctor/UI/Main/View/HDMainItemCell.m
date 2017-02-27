//
//  HDMainItemCell.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/10.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDMainItemCell.h"
#import "HDMainHeaderEntity.h"
#import "UIImageView+WebCache.h"

@interface HDMainItemCell ()

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIView    *lineView;

@end

@implementation HDMainItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

#pragma -mark createUI

- (void)createUI
{
    [self createImageView];
    [self createLabel];
    [self createLineView];
}

- (void)createImageView
{
    self.contentImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.contentImageView];
}

- (void)createLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ColorFromRGB(0x313131);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.titleLabel];
}

- (void)createLineView
{
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ColorFromRGB(0xdddddd);
    [self.contentView addSubview:self.lineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentImageView.frame = CGRectMake(5, (self.frame.size.height - 20)/2, 20, 20);
    self.titleLabel.frame = CGRectMake(35, 0, self.frame.size.width - 35, self.frame.size.height);
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)resetCellWithEntity:(HDMainHeaderEntity *)entity
{
    self.titleLabel.text = entity.title;
    NSURL *url = [NSURL URLWithString:entity.iconURL];
    [self.contentImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
}

- (void)hideLineView:(BOOL)hide
{
    self.lineView.hidden = hide;
}

@end
