//
//  HDContractHeaderView.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContractHeaderView.h"
#import "HDMemberDepartmentEntity.h"

@interface HDContractHeaderView ()

@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UIButton                  *button;
@property (nonatomic, strong) UIView                    *lineView;
@property (nonatomic, strong) UIImageView               *signImageView;
@property (nonatomic, strong) HDMemberDepartmentEntity  *entity;

@end

@implementation HDContractHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorFromRGB(0xe8e8e8);
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createLabel];
    [self createButton];
    [self createLineView];
    [self createSignImageView];
}

- (void)createLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = ColorFromRGB(0x313131);
    [self addSubview:self.titleLabel];
}

- (void)createButton
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(respondsToButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (void)createLineView
{
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ColorFromRGB(0xdddddd);
    [self addSubview:self.lineView];
}

- (void)createSignImageView
{
    self.signImageView = [[UIImageView alloc] init];
    [self addSubview:self.signImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 0, self.frame.size.width - 50, self.frame.size.height);
    self.button.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    
    self.signImageView.frame = CGRectMake(self.frame.size.width - 26, (self.frame.size.height - 6) / 2, 11, 6);
}


#pragma -mark responds

- (void)respondsToButton
{
    if ([self.delegate respondsToSelector:@selector(didSelectHeaderView:)]) {
        [self.delegate didSelectHeaderView:self.entity];
    }
}


- (void)resetViewWithEntity:(HDMemberDepartmentEntity *)entity
{
    self.entity = entity;
    NSString *name = entity.departmentName;
    if ([name isEqualToString:@"null"]) {
        self.titleLabel.text = @"其他";
    } else {
        self.titleLabel.text = entity.departmentName;
    }
    if (entity.isSelect) {
        self.signImageView.image = [UIImage imageNamed:@"Con_arrow_up"];
    } else {
        self.signImageView.image = [UIImage imageNamed:@"Con_arrow_down"];
    }
}

@end
