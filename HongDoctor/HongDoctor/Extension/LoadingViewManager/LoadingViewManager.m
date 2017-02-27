//
//  TaskLoadingViewManager.m

//
//  Created by XiangqiTU on 4/22/13.
//  Copyright (c) 2013 Owen.Qin. All rights reserved.
//

#import "LoadingViewManager.h"
#import "MBProgressHUD.h"
#import "LoadingIndicatorView.h"

static LoadingViewManager  *loadingViewManager = nil;

@interface LoadingViewManager ()

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation LoadingViewManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadingViewManager = [[LoadingViewManager alloc] init];
    });
    return loadingViewManager;
}


#pragma mark - public

- (void)showHUDWithText:(NSString*)hudText inView:(UIView *)containerView duration:(float)duration
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeHUDFromSuperView) object: nil];
    if (!self.HUD && containerView) {
        LoadingIndicatorView *indicatorView = [LoadingIndicatorView viewWithType:LoadingIndicatorType_Activity];
        self.HUD = [[MBProgressHUD alloc] initWithView:containerView HUDMode:MBProgressHUDModeText indicatorView:indicatorView];
    }
    _HUD.labelText = hudText;
    [containerView addSubview:_HUD];
    [_HUD show:YES];
    [self hideHUDAfterDelay:duration];
}

- (void)showLoadingViewInView:(UIView*)view withText:(NSString*)text
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(removeHUDFromSuperView) object: nil];
    if (!self.HUD && view) {
        LoadingIndicatorView *indicatorView = [LoadingIndicatorView viewWithType:LoadingIndicatorType_Activity];
        self.HUD = [[MBProgressHUD alloc] initWithView:view HUDMode:MBProgressHUDModeIndeterminate indicatorView:indicatorView];
    }
    _HUD.labelText = text;
    [view addSubview:_HUD];
    [_HUD show:YES];
}

- (void)removeLoadingView:(UIView*)view
{
    [self removeHUDFromSuperView];
}

- (void)hideHUDAfterDelay:(float)timeInterval
{
    if (!self.HUD) {
        return;
    }
    [self performSelector:@selector(removeHUDFromSuperView) withObject:nil afterDelay:timeInterval];
}

- (void)removeHUDFromSuperView
{
    [_HUD removeFromSuperview];
    _HUD = nil;
}


- (void)showLoadingViewInView:(UIView *)view
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(removeHUDFromSuperView) object: nil];
    if (!self.HUD && view) {
        LoadingIndicatorView *indicatorView = [LoadingIndicatorView viewWithType:LoadingIndicatorType_Ring];
        self.HUD = [[MBProgressHUD alloc] initWithView:view HUDMode:MBProgressHUDModeIndeterminate indicatorView:indicatorView];
        self.HUD.color = [UIColor clearColor];
    }
    [view addSubview:_HUD];
    [_HUD show:YES];
}


@end
