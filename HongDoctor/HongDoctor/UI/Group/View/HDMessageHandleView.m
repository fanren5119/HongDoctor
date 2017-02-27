//
//  HDMessageHandleView.m
//  WebViewCacheTest
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDMessageHandleView.h"

@interface HDMessageHandleView ()

@property (nonatomic, strong) NSArray           *itemTypes;
@property (nonatomic, strong) NSMutableArray    *buttonArray;
@property (nonatomic, strong) NSMutableArray    *lineViewArray;

@end

@implementation HDMessageHandleView

- (id)initWithFrame:(CGRect)frame itemTypes:(NSArray *)itemTypes
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.itemTypes = itemTypes;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createButtons];
    [self createLineViews];
}

- (void)createButtons
{
    NSArray *titles = @[@"复制", @"转发", @"删除"];
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < self.itemTypes.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        HandleItemType type = [self.itemTypes[i] integerValue];
        [button setTitle:titles[type] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
}

- (void)createLineViews
{
    self.lineViewArray = [NSMutableArray array];
    if (self.itemTypes.count <= 1) {
        return;
    }
    for (int i = 0; i < self.itemTypes.count - 1; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        [self.lineViewArray addObject:lineView];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (self.itemTypes.count > 1) {
        width = (width - self.itemTypes.count + 1) / self.itemTypes.count;
    }
    for (UIButton *button in self.buttonArray) {
        CGFloat x = button.tag * (width + 1);
        button.frame = CGRectMake(x, 0, width, height);
    }
    for (int i = 0; i < self.lineViewArray.count; i ++) {
        UIView *lineView = self.lineViewArray[i];
        lineView.frame = CGRectMake(width + i * (width + 1), 0, 1, height);
    }
}


#pragma -mark responds

- (void)respondsToButton:(UIButton *)button
{
    HandleItemType type = [self.itemTypes[button.tag] integerValue];
    if ([self.delegate respondsToSelector:@selector(didSelectItemWithType:)]) {
        [self.delegate didSelectItemWithType:type];
    }
}


@end
