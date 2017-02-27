//
//  LoadingIndicatorView.m
//  LoadingTest
//
//  Created by wanglei on 15/11/5.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "LoadingIndicatorView.h"
#import "LoadingIndicatorActivityView.h"
#import "LoadingIndicatorRingView.h"

@implementation LoadingIndicatorView

+ (LoadingIndicatorView *)viewWithType:(LoadingIndicatorType)type
{
    switch (type) {
        case LoadingIndicatorType_Activity:
        {
            return [[LoadingIndicatorActivityView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        }
            break;
        case LoadingIndicatorType_Ring:
        {
            return [[LoadingIndicatorRingView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        }
            break;
        default:
            break;
    }
}

- (void)startAnimating
{
    
}

@end
