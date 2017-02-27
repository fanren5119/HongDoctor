//
//  HDContractItemSelectView.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContractItemSelectView.h"
#import "HDContractItemCell.h"

@interface HDContractItemSelectView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *titlesArray;

@end

@implementation HDContractItemSelectView

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        self.titlesArray = titles;
        [self createUI];
        [self addGesture];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    [self addSubview:self.tableView];
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = 44 * self.titlesArray.count;
    self.tableView.frame = CGRectMake(self.frame.size.width - 115, 0, 100, height);
}

#pragma -mark responds

- (void)respondsToTapGesture
{
    [self hide];
}

#pragma -mark tableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDContractItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HDContractItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell resetCellWithString:self.titlesArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectWithIndex:)]) {
        [self.delegate didSelectWithIndex:indexPath.row];
    }
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}


#pragma -mark publick

- (void)hide
{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(didClickToHideView)]) {
        [self.delegate didClickToHideView];
    }
}

@end
