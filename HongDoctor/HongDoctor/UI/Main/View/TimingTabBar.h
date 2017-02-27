//
//  MyTabBar.h
//  Test
//
//  Created by wanglei on 15/7/6.
//  Copyright (c) 2015年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TimingTabBarDelegate <NSObject>

- (void)respondsToSelectIndex:(NSInteger)index;


@end

@interface TimingTabBar : UIView

@property (nonatomic, weak) id <TimingTabBarDelegate> delegate;

- (void)resetTabBarWithBageArray:(NSArray *)bageArray;

@end
