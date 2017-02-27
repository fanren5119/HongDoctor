//
//  HDMessageOtherOptionView.m
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageOtherOptionView.h"

@interface HDMessageOtherOptionView ()

@property (nonatomic, weak)     id target;
@property (nonatomic, assign)   SEL action;

@end

@implementation HDMessageOtherOptionView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CALayer *buttonLayer = [CALayer layer];
    buttonLayer.backgroundColor = [UIColor clearColor].CGColor;
    buttonLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.width);
    buttonLayer.cornerRadius = 5;
    buttonLayer.masksToBounds = YES;
    buttonLayer.borderColor = [UIColor lightGrayColor].CGColor;
    buttonLayer.borderWidth = 1;
    buttonLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:self.imageName].CGImage);
    [self.layer addSublayer:buttonLayer];
    
    
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.backgroundColor = [UIColor clearColor].CGColor;
    titleLayer.frame = CGRectMake(0, rect.size.height - 20, rect.size.width, 20);
    titleLayer.string = self.name;
    titleLayer.fontSize = 14;
    titleLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    [self.layer addSublayer:titleLayer];
}

- (void)setName:(NSString *)name
{
    _name = name;
    [self setNeedsDisplay];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self setNeedsDisplay];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(didSelectOptionView:)]) {
        [self.delegate didSelectOptionView:self];
    }
}

@end
