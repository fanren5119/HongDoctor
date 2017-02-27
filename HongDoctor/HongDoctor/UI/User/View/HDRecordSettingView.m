//
//  HDRecordSettingView.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDRecordSettingView.h"

@interface HDRecordSettingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *dataSourceArray;

@end

@implementation HDRecordSettingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self createUI];
        [self addGesture];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    [self addSubview:self.tableView];
}

- (void)addGesture
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:gesture];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, 250, 120);
    self.tableView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.separatorInset = UIEdgeInsetsMake(30, 0, 0, 0);
    }
    
    NSString *text = [NSString stringWithFormat:@"%@s", self.dataSourceArray[indexPath.row]];
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:indexPath.row];
    }
    [self hide];
}

- (void)showViewWithData:(NSArray *)data
{
    self.dataSourceArray = data;
    [self.tableView reloadData];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

@end
