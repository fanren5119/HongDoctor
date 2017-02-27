//
//  MyTabBar.m
//  Test
//
//  Created by wanglei on 15/7/6.
//  Copyright (c) 2015年 wanglei. All rights reserved.
//

#import "TimingTabBar.h"
#import "TimingTabBarItem.h"
#import "HDIconEntity.h"
#import "UIButton+WebCache.h"

@interface TimingTabBar ()

@property (nonatomic, strong) TimingTabBarItem  *selectButton;
@property (nonatomic, strong) NSArray           *titleArray;
@property (nonatomic, strong) NSArray           *highlightImagesArray;
@property (nonatomic, strong) NSMutableArray    *buttonArray;
@end

@implementation TimingTabBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self customTabBar];
    }
    return self;
}

- (void)customTabBar
{
    int viewCount = 4;
    double _width = [[UIScreen mainScreen] bounds].size.width / viewCount;
    double _height = 50;
    
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < viewCount; i++) {
        TimingTabBarItem *btn = [[TimingTabBarItem alloc] initWithFrame:CGRectZero];
        btn.frame = CGRectMake(i*_width, 0, _width, _height);
        [btn addTarget:self action:@selector(respondsToselectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setTitle:self.titleArray[i]];
        [btn setTitleColor:ColorFromRGB(0x999999) selectColor:ColorFromRGB(0x00A0E9)];
        UIImage *image = [UIImage imageNamed:self.imageArray[i]];
        UIImage *selectImage = [UIImage imageNamed:self.selectImageArray[i]];
        [btn setImage:image selectImage:selectImage];
        [btn setBageValue:0];
        if (i == 0) {
            self.selectButton = btn;
            btn.selected = YES;
        }
        else {
            btn.selected = NO;
        }
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
    }
}

- (void)resetTabBarWithBageArray:(NSArray *)bageArray
{
    for (int i = 0; i < self.buttonArray.count; i++) {
        TimingTabBarItem *btn = self.buttonArray[i];
        if (bageArray.count > i) {
            [btn setBageValue:[bageArray[i] integerValue]];
        }
    }
}

- (void)respondsToselectedTab:(TimingTabBarItem *)button
{
    if (self.selectButton == button) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(respondsToSelectIndex:)]) {
        [self.delegate respondsToSelectIndex:button.tag];
    }
    
    button.selected = YES;
    self.selectButton.selected = NO;
    self.selectButton = button;
}


#pragma -mark LoadData

- (NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = @[@"业务",
                        @"信息",
                        @"通讯录",
                        @"我"];
    }
    return _titleArray;
}

- (NSArray *)imageArray
{
    return @[@"Main_business.png",
             @"Main_message.png",
             @"Main_addressbook.png",
             @"Main_user.png"];
}

- (NSArray *)selectImageArray
{
    return @[@"Main_business_select.png",
             @"Main_message_select.png",
             @"Main_addressbook_select.png",
             @"Main_user_select.png"];
}

@end
