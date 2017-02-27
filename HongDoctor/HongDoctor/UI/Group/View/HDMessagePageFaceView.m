//
//  HDMessagePageFaceView.m
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessagePageFaceView.h"

@implementation HDMessagePageFaceView

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        self.imageArray = imageArray;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    int row = ceil(self.imageArray.count / 8.0);
    int col = 8;
    CGFloat width = 30;
    CGFloat interval = ([[UIScreen mainScreen] bounds].size.width - 30 * 8)/9.0;
    for (int i = 0; i < row; i ++) {
        for (int j = 0; j < col; j ++) {

            CGFloat x = j * width + (j + 1) * interval;
            CGFloat y = i * width + (i + 1) * interval;
            int index = i * 8 + j;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(x, y, width, width);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if (index < self.imageArray.count) {
                imageView.image = [UIImage imageNamed:self.imageArray[index]];
            }
            [self addSubview:imageView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, width + interval, width + interval);
            button.center = imageView.center;
            button.tag = index;

            [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
}

- (void)respondsToButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(faceView:didSelectIndex:)]) {
        [self.delegate faceView:self didSelectIndex:button.tag];
    }
}

@end
