//
//  HDMainTitleItem.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMainTitleItem : UIControl

- (void)setImage:(UIImage *)image;
- (void)setWebImageWithURL:(NSString *)imageURL;
- (void)setTitle:(NSString *)title;
- (void)setBageValue:(NSInteger)bageValue;

@end
