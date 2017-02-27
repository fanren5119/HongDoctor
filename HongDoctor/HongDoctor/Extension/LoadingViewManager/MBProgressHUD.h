//
//  MBProgressHUD.h
//  Version 0.5
//  Created by Matej Bukovinski on 2.4.09.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol   MBProgressHUDDelegate;
@class      LoadingIndicatorView;

typedef enum {
	MBProgressHUDModeIndeterminate,
	MBProgressHUDModeText
} MBProgressHUDMode;

@interface MBProgressHUD : UIView

- (id)initWithView:(UIView *)view HUDMode:(MBProgressHUDMode)mode indicatorView:(LoadingIndicatorView *)indicatorView;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@property (nonatomic, assign) MBProgressHUDMode mode;
@property (nonatomic, strong) NSString          *labelText;
@property (nonatomic, strong) UIColor           *color;
@property (nonatomic, strong) UIFont            *labelFont;
@property (nonatomic, assign) CGSize            minSize;

@end



