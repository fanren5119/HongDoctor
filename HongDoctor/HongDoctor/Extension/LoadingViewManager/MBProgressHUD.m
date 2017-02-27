//
// MBProgressHUD.m
// Version 0.5
// Created by Matej Bukovinski on 2.4.09.
//

#import "MBProgressHUD.h"
#import "LoadingIndicatorView.h"

static const CGFloat kPadding       = 4.f;
static const CGFloat kLabelFontSize = 14.f;
static const CGFloat spaceMargin    = 20.f;

@interface MBProgressHUD ()

@property (nonatomic, strong) LoadingIndicatorView  *indicator;
@property (nonatomic, assign) CGSize                size;
@property (nonatomic, strong) UILabel               *label;
@property (nonatomic, assign) CGAffineTransform     rotationTransform;

@end


@implementation MBProgressHUD

- (id)initWithView:(UIView *)view HUDMode:(MBProgressHUDMode)mode indicatorView:(LoadingIndicatorView *)indicatorView
{
    self = [super init];
    if (self) {
        self.mode = mode;
        self.indicator = indicatorView;
        [self loadDefaultData];
        [self createUI];
        [self registerNotification];
        if ([view isKindOfClass:[UIWindow class]]) {
            [self setTransformForCurrentOrientation:NO];
        }
    }
	return self;
}


#pragma -mark LoadData

- (void)loadDefaultData
{
    self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
    self.minSize = CGSizeZero;
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0f;
    
    self.rotationTransform = CGAffineTransformIdentity;
}


#pragma -mark CreateUI

- (void)createUI
{
    [self createLabel];
    [self updateIndicators];
}

- (void)createLabel
{
	self.label = [[UILabel alloc] initWithFrame:self.bounds];
	self.label.adjustsFontSizeToFitWidth = NO;
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.opaque = NO;
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textColor = [UIColor whiteColor];
	self.label.font = self.labelFont;
	self.label.text = self.labelText;
    self.label.numberOfLines = 0;
	[self addSubview:self.label];
}

- (void)updateIndicators
{
	if (self.mode == MBProgressHUDModeIndeterminate) {
        [self.indicator removeFromSuperview];
		[self.indicator startAnimating];
        [self addSubview:self.indicator];
	} else if (self.mode == MBProgressHUDModeText) {
		[self.indicator removeFromSuperview];
		self.indicator = nil;
	}
}


#pragma mark - Notifications

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToDeviceOrientationChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
	// Entirely cover the parent view
	UIView *parent = self.superview;
	if (parent) {
		self.frame = parent.bounds;
	}
	CGRect bounds = self.bounds;
	
	// Determine the total widt and height needed
	CGFloat maxWidth = bounds.size.width - 4 * spaceMargin;
	CGSize totalSize = CGSizeZero;
	
	CGRect indicatorF = self.indicator.bounds;
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, indicatorF.size.width);
	totalSize.height += indicatorF.size.height;
	
    CGSize labelSize = [self.label.text sizeWithFont:self.label.font constrainedToSize: CGSizeMake(maxWidth, CGFLOAT_MAX)];
	labelSize.width = MIN(labelSize.width, maxWidth);
	totalSize.width = MAX(totalSize.width, labelSize.width);
	totalSize.height += labelSize.height;
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		totalSize.height += kPadding;
	}
    
	totalSize.width += 2 * spaceMargin;
	totalSize.height += 2 * spaceMargin;
	
	// Position elements
	CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + spaceMargin;
	CGFloat xPos = 0;
	indicatorF.origin.y = yPos;
	indicatorF.origin.x = roundf((bounds.size.width - indicatorF.size.width) / 2) + xPos;
	self.indicator.frame = indicatorF;
	yPos += indicatorF.size.height;
	
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		yPos += kPadding;
	}
	CGRect labelF;
	labelF.origin.y = yPos;
	labelF.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
	labelF.size = labelSize;
	self.label.frame = labelF;
	yPos += labelF.size.height;

	if (totalSize.width < self.minSize.width) {
		totalSize.width = self.minSize.width;
	} 
	if (totalSize.height < self.minSize.height) {
		totalSize.height = self.minSize.height;
	}
	
	self.size = totalSize;
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    if (self.color) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, 0.8);
    }
	
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(roundf((allRect.size.width - self.size.width) / 2),
								roundf((allRect.size.height - self.size.height) / 2), self.size.width, self.size.height);
	float radius = 10.0f;
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);
	UIGraphicsPopContext();
}



#pragma -mark Selector To Notificaiton

- (void)selectorToDeviceOrientationChangeNotification:(NSNotification *)notification
{
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated
{
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; } 
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; } 
		else { radians = 0; }
	}
	self.rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:self.rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}


#pragma -mark Public

- (void)show:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hide:(BOOL)animated
{
    [self hide:animated afterDelay:0];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(selectorToHide:) withObject:@(animated) afterDelay:delay];
}

- (void)selectorToHide:(NSNumber *)animated
{
    if (self.alpha > 0) {
        return;
    }
    if (animated.boolValue) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        }];
    }
    else {
        self.alpha = 0.0f;
    }
}


#pragma -mark Set function

- (void)setLabelText:(NSString *)labelText
{
    _labelText = labelText;
    self.label.text = labelText;
    [self setNeedsDisplay];
}

- (void)setMode:(MBProgressHUDMode)mode
{
    _mode = mode;
    [self updateIndicators];
    [self setNeedsDisplay];
}


#pragma -mark Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
