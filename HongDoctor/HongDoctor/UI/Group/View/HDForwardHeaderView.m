//
//  HDForwardHeaderView.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/24.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDForwardHeaderView.h"
#import "HDCreateGroupHeaderItemView.h"
#import "HDForwardHeaderModel.h"

@interface HDForwardHeaderView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray       *dataArray;

@end

@implementation HDForwardHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = NO;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)resetViewWithData:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    self.scrollView.contentSize = CGSizeMake(dataArray.count * 60, self.scrollView.frame.size.height);
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < dataArray.count; i ++) {
        HDForwardHeaderModel *entity = dataArray[i];
        CGRect frame = CGRectMake(i * 60, 0, 60, self.scrollView.frame.size.height);
        HDCreateGroupHeaderItemView *itemView = [[HDCreateGroupHeaderItemView alloc] initWithFrame:frame];
        itemView.tag = i;
        [itemView resetViewWithTitle:entity.name imageURL:entity.imageURL];
        [self.scrollView addSubview:itemView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture:)];
        [itemView addGestureRecognizer:tapGesture];
    }
}

- (void)respondsToTapGesture:(UITapGestureRecognizer *)tapGesture
{
    NSInteger tag = tapGesture.view.tag;
    if ([self.delegate respondsToSelector:@selector(didSelectItemWithModel:)]) {
        [self.delegate didSelectItemWithModel:self.dataArray[tag]];
    }
}

@end
