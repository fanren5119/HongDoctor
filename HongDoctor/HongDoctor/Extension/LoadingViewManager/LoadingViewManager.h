//
//  TaskLoadingViewManager.h

//
//  Created by XiangqiTU on 4/22/13.
//  Copyright (c) 2013 Owen.Qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingViewManager : NSObject

+ (instancetype)sharedInstance;

- (void)showLoadingViewInView:(UIView *)view withText:(NSString *)text;
- (void)showHUDWithText:(NSString *)hudText inView:(UIView *)containerView duration:(float)duration;
- (void)removeLoadingView:(UIView *)view;


- (void)showLoadingViewInView:(UIView *)view;

@end

