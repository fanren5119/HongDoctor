//
//  TimingTabBarItem.h
//  Test
//
//  Created by wanglei on 2017/1/8.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimingTabBarItem : UIControl

- (void)setImage:(UIImage *)image selectImage:(UIImage *)selectImage;
- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color selectColor:(UIColor *)selectColor;
- (void)setBageValue:(NSInteger)bageValue;

- (void)setwebImage:(NSString *)imageURL selectImage:(NSString *)selectImageURL;

@end
