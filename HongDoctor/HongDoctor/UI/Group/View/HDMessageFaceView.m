//
//  HDMessageFaceView.m
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageFaceView.h"
#import "HDMessagePageFaceView.h"

@interface HDMessageFaceView () <UIScrollViewDelegate, HDMessagePageFaceViewDelegate>

@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;

@end

@implementation HDMessageFaceView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadData];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createScrollView];
    [self createFaceViews];
    [self createPageControl];
}

- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.bounds;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
}

- (void)createFaceViews
{
    int sections = (int)self.dataSourceArray.count;
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    for (int i = 0; i < sections; i ++) {
        HDMessagePageFaceView *view = [[HDMessagePageFaceView alloc] initWithFrame:self.scrollView.bounds imageArray:self.dataSourceArray[i]];
        view.delegate = self;
        view.tag = i;
        view.frame = CGRectMake(i * width, 0, width, height);
        [self.scrollView addSubview:view];
    }
    
    self.scrollView.contentSize = CGSizeMake(sections * width, height);
}

- (void)createPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 20)];
    [self.pageControl addTarget:self action:@selector(respondsToPageControlChange) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = self.dataSourceArray.count;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
}


#pragma -mark responds

- (void)respondsToPageControlChange
{
    CGFloat x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}


#pragma -mark scrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = self.scrollView.contentOffset.x;
    self.pageControl.currentPage = ceil(x / self.scrollView.frame.size.width);
}

- (void)faceView:(HDMessagePageFaceView *)faceView didSelectIndex:(NSInteger)index
{
    NSInteger selectIndex = faceView.tag * 24 + index;
    
    if (index == 23) {
        if ([self.delegate respondsToSelector:@selector(didSelectDelete)]) {
            [self.delegate didSelectDelete];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectIndexFace:)]) {
        [self.delegate didSelectIndexFace:selectIndex];
    }
}

#pragma -mark loadData

- (void)loadData
{
    self.dataSourceArray = [NSMutableArray array];
    
    int allCount = 62;
    int count = 23;
    int sections = allCount / count + 1;
    for (int i = 0; i < sections; i ++) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < count; j ++) {
            int imageIndex = i * count + j;
            NSString *string = [NSString stringWithFormat:@"f_static_%d.png",imageIndex];
            [array addObject:string];
        }
        [array addObject:@"delete_emoji.png"];
        [self.dataSourceArray addObject:array];
    }
}

@end
