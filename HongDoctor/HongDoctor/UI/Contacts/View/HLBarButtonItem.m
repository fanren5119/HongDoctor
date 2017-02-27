//
//  HLBarButtonItem.m
//  HLKitchen
//
//  Created by wanglei on 15/4/29.
//  Copyright (c) 2015年 yipinapp. All rights reserved.
//

#import "HLBarButtonItem.h"

@interface HLBarButtonItem ()

@property (nonatomic, strong) UIButton  *imageButton;
@property (nonatomic, assign) id        buttonTarget;
@property (nonatomic, assign) SEL       buttonAction;

@end

@implementation HLBarButtonItem

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIView *view = [[UIView alloc] init];
    self = [super initWithCustomView:view];
    if (self) {
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat rightOffset = (image.size.height - 44)/2.0;
        CGFloat topOffset = 0;
        self.imageButton.frame = CGRectMake(0, 0, 20, 20);
        self.imageButton.contentEdgeInsets = UIEdgeInsetsMake(topOffset, 0, 0, rightOffset);
        self.imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.imageButton setImage:image forState:UIControlStateNormal];
        [self.imageButton addTarget:self action:@selector(respondsToBarBuutonItem) forControlEvents:UIControlEventTouchUpInside];
        self.customView = self.imageButton;
        
        self.buttonTarget = target;
        self.buttonAction = action;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIView *view = [[UIView alloc] init];
    self = [super initWithCustomView:view];
    if (self) {
        
        CGFloat rightOffset = -7;
        CGFloat topOffset = 0;
        
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageButton.frame = CGRectMake(0, 0, 30, 18);
        self.imageButton.backgroundColor = [UIColor clearColor];
        self.imageButton.titleEdgeInsets = UIEdgeInsetsMake(topOffset, 0, 0, rightOffset);
        self.imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.imageButton setTitle:title forState:UIControlStateNormal];
        self.imageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self.imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.imageButton addTarget:self action:@selector(respondsToBarBuutonItem) forControlEvents:UIControlEventTouchUpInside];
        self.customView = self.imageButton;
        
        self.buttonTarget = target;
        self.buttonAction = action;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    UIView *view = [[UIView alloc] init];
    self = [super initWithCustomView:view];
    if (self) {
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat rightOffset = (image.size.height - 44)/2.0;
        CGFloat topOffset = 0;
        self.imageButton.frame = CGRectMake(0, 0, 50, 20);
        self.imageButton.contentEdgeInsets = UIEdgeInsetsMake(topOffset, 0, 0, rightOffset);
        self.imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.imageButton setTitle:title forState:UIControlStateNormal];
        self.imageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self.imageButton setImage:image forState:UIControlStateNormal];
        [self.imageButton addTarget:self action:@selector(respondsToBarBuutonItem) forControlEvents:UIControlEventTouchUpInside];
        self.customView = self.imageButton;
        
        self.buttonTarget = target;
        self.buttonAction = action;
    }
    return self;
}


- (void)respondsToBarBuutonItem
{
    if ([self.buttonTarget respondsToSelector:self.buttonAction]) {
        [self.buttonTarget performSelector:self.buttonAction withObject:nil];
    }
}

- (void)setItemTitle:(NSString *)title
{
    if (self.imageButton != nil) {
        [self.imageButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setTitleImage:(UIImage *)image
{
    if (self.imageButton != nil) {
        [self.imageButton setImage:image forState:UIControlStateNormal];
    }
}

@end
