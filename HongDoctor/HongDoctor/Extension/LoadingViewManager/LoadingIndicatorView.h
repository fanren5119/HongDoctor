//
//  LoadingIndicatorView.h
//  LoadingTest
//
//  Created by wanglei on 15/11/5.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoadingIndicatorType) {
    LoadingIndicatorType_Activity   = 0,
    LoadingIndicatorType_Ring       = 1
};


@interface LoadingIndicatorView : UIView

+ (LoadingIndicatorView *)viewWithType:(LoadingIndicatorType)type;

- (void)startAnimating;

@end
