//
//  HDMessageOtherView.h
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMessageOtherViewDelegate;

@interface HDMessageOtherView : UIView

@property (nonatomic, weak) id <HDMessageOtherViewDelegate> delegate;

@end


@protocol HDMessageOtherViewDelegate <NSObject>

- (void)didSelectView:(HDMessageOtherView *)view optionIndex:(NSInteger)index;

@end


