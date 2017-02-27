//
//  UIImage+DrawImage.m
//  RideSharing
//
//  Created by azurewu on 14/12/15.
//  Copyright (c) 2014年 yipinapp. All rights reserved.
//

#import "UIImage+DrawImage.h"

@implementation UIImage (DrawImage)

+ (UIImage *)imageWithSize:(CGSize)size andColor:(UIColor *)color;
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
