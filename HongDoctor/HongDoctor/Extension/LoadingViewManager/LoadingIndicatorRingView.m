//
//  LoadingIndicatorRingView.m
//  LoadingTest
//
//  Created by wanglei on 15/11/6.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#define  D_Ring_lineWidth   4

#import "LoadingIndicatorRingView.h"

@interface LoadingIndicatorRingView ()

@property (nonatomic, strong) CALayer       *animationLayer;
@property (nonatomic, assign) CGFloat       radius;

@end

@implementation LoadingIndicatorRingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.radius = MAX(frame.size.width, frame.size.height);
        [self createSubLayers];
    }
    return self;
}

- (void)createSubLayers
{
    [self createAnimationLayer];
    [self createAnimationSubLayers];
}

- (void)createAnimationLayer
{
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(0, 0, self.radius, self.radius);
    self.animationLayer.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    [self.layer addSublayer:self.animationLayer];
}

- (void)createAnimationSubLayers
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, self.radius, self.radius);
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.opacity = 1;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = D_Ring_lineWidth;
    [self.animationLayer addSublayer:shapeLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius / 2.0, self.radius / 2.0) radius:(self.radius - 2 * D_Ring_lineWidth) / 2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    shapeLayer.path = path.CGPath;
    
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.frame = CGRectMake(0, 0, self.radius, self.radius);
    
    UIColor *firstColor = ColorFromRGB(0xda4542);
    UIColor *secondColor = ColorFromRGB(0xcd5056);
    UIColor *thirdColor = ColorFromRGB(0xf7c1c1);
    
    [gradLayer setColors:@[(id)firstColor.CGColor,(id)secondColor.CGColor, (id)thirdColor.CGColor]];
    [gradLayer setStartPoint:CGPointMake(0, 0)];
    [gradLayer setEndPoint:CGPointMake(1, 1)];
    [self.animationLayer addSublayer:gradLayer];
    
    [gradLayer setMask:shapeLayer];
}

- (void)createAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 1.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.animationLayer addAnimation:animation forKey:@"ratationAnimation"];
}


#pragma -mark Public

- (void)startAnimating
{
    [self createAnimation];
}


@end
