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
    if (self = [super initWithCustomView:nil]) {
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat rightOffset = (image.size.height - 44)/2.0;
        CGFloat topOffset = 0;
        self.imageButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
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
    if (self = [super initWithCustomView:nil]) {
        
        CGFloat rightOffset = -7;
        CGFloat topOffset = 0;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 18);
        button.backgroundColor = [UIColor clearColor];
        button.titleEdgeInsets = UIEdgeInsetsMake(topOffset, 0, 0, rightOffset);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(respondsToBarBuutonItem) forControlEvents:UIControlEventTouchUpInside];
        self.customView = button;
        
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

- (void)setTitleImage:(UIImage *)image
{
    if (self.imageButton != nil) {
        [self.imageButton setImage:image forState:UIControlStateNormal];
    }
}

@end
