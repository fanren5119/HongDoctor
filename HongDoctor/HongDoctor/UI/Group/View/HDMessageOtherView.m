//
//  HDMessageOtherView.m
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageOtherView.h"
#import "HDMessageOtherOptionView.h"

@interface HDMessageOtherView () <HDMessageOtherOptionViewDelegate>

@end

@implementation HDMessageOtherView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat interval = self.frame.size.width / 13.0;
    CGFloat width = interval * 2;
    CGFloat height = width + 15;
    CGFloat vInterval = (self.frame.size.height - height) / 2;
    for (int i = 0; i < self.titleArray.count; i ++) {
        HDMessageOtherOptionView *optionView = [[HDMessageOtherOptionView alloc] init];
        optionView.frame = CGRectMake(i * width + (i + 1) * interval, vInterval, width, width + 20);
        optionView.name = self.titleArray[i];
        optionView.imageName = self.imageArray[i];
        optionView.backgroundColor = [UIColor clearColor];
        optionView.tag = i;
        optionView.delegate = self;
        [self addSubview:optionView];
    }
}

- (void)didSelectOptionView:(HDMessageOtherOptionView *)optionView
{
    if ([self.delegate respondsToSelector:@selector(didSelectView:optionIndex:)]) {
        [self.delegate didSelectView:self optionIndex:optionView.tag];
    }
}

- (NSArray *)titleArray
{
    return @[@"拍照", @"相册", @"拍摄", @"位置"];
}

- (NSArray *)imageArray
{
    return @[@"Message_camera.png", @"Message_picture.png", @"Message_video.png", @"Message_picture.png"];
}

@end
