//
//  HDTabBarController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDTabBarController.h"
#import "TimingTabBar.h"

@interface HDTabBarController () <TimingTabBarDelegate>

@property (nonatomic, strong) TimingTabBar *myTabBar;

@end

@implementation HDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToBageNumChange:) name:@"HDMainBageNumChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)customTabBar
{
    self.myTabBar = [[TimingTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.myTabBar.delegate = self;
    self.myTabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:self.myTabBar];
    self.tabBar.backgroundColor = [UIColor redColor];
    [self.tabBar bringSubviewToFront:self.myTabBar];
}

- (void)respondsToSelectIndex:(NSInteger)index
{
    self.selectedIndex = index;
}

- (void)selectorToBageNumChange:(NSNotification *)not
{
    NSArray *array = [not.userInfo objectForKey:@"numbers"];
    if (array.count >= 8) {
        NSArray *bageArray = [array subarrayWithRange:NSMakeRange(4, 4)];
        [self.myTabBar resetTabBarWithBageArray:bageArray];
    }
}


@end
