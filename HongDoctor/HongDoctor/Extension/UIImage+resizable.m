//
//  UIImage+resizable.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/16.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "UIImage+resizable.h"

@implementation UIImage (resizable)

- (UIImage *)resizableImage
{
    CGFloat top = self.size.height / 2 - 1;
    CGFloat left = self.size.width / 2 - 1;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left) resizingMode:UIImageResizingModeStretch];
}

@end
