//
//  CALayer+HDLayer.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "CALayer+HDLayer.h"

@implementation CALayer (HDLayer)

- (void)setBorderUIColor:(UIColor *)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
