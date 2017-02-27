//
//  HDNotificationView.m
//  NotificationTest
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDNotificationView.h"
#import "AppDelegate.h"
#import "HDMessageViewController.h"

@interface HDNotificationView ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) NSString    *groupGuid;

@end

@implementation HDNotificationView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSelf];
        [self createUI];
        [self addGesture];
    }
    return self;
}

- (void)setupSelf
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)createUI
{
    [self createHeadImageView];
    [self createTitleLabel];
    [self createContentLabel];
}

- (void)createHeadImageView
{
    self.headImageView = [[UIImageView alloc] init];
    [self addSubview:self.headImageView];
}

- (void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.text = @"一起";
    [self addSubview:self.titleLabel];
}

- (void)createContentLabel
{
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.contentLabel];
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    [self addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.headImageView.frame = CGRectMake(10, 5, 20, 20);
    self.titleLabel.frame = CGRectMake(40, 5, self.frame.size.width - 50, 20);
    self.contentLabel.frame = CGRectMake(10, self.frame.size.height - 35, self.frame.size.width - 30, 20);
}

- (void)setMessage:(NSString *)message groupGuid:(NSString *)groupGuid
{
    self.groupGuid = groupGuid;
    self.contentLabel.text = message;
}

#pragma -mark responds

- (void)respondsToTapGesture
{
    [self removeFromSuperview];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    UITabBarController *controller = (UITabBarController *)window.rootViewController;
    UINavigationController *nav = (UINavigationController *)controller.selectedViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HDMessageViewController *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"HDMessageViewController"];
    messageVC.groupGuid = self.groupGuid;
    [nav pushViewController:messageVC animated:YES];
}


- (void)show
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[HDNotificationView class]]) {
            return;
        }
    }
    
    [window addSubview:self];
    
    self.frame = CGRectMake(15, -60, window.frame.size.width - 30, 60);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(15, 20, window.frame.size.width - 30, 60);
    }];

    [self performSelector:@selector(hide) withObject:nil afterDelay:1];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -60;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
