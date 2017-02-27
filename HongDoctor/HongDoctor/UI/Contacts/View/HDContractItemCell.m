//
//  HDContractItemCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContractItemCell.h"

@interface HDContractItemCell ()

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIView    *lineView;

@end

@implementation HDContractItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

#pragma -mark createUI

- (void)createUI
{
    [self createLabel];
    [self createLineView];
}

- (void)createLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
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
    self.titleLabel.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height);
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)resetCellWithString:(NSString *)string
{
    self.titleLabel.text = string;
}

- (void)hideLineView:(BOOL)hide
{
    self.lineView.hidden = hide;
}

@end
