//
//  HLBarButtonItem.h
//  HLKitchen
//
//  Created by wanglei on 15/4/29.
//  Copyright (c) 2015年 yipinapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLBarButtonItem : UIBarButtonItem

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setTitleImage:(UIImage *)image;

@end
