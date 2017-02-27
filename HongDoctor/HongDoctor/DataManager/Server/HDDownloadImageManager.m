//
//  HDDownloadImageManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDDownloadImageManager.h"
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

static HDDownloadImageManager* __manager = nil;

@interface HDDownloadImageManager ()

@property (nonatomic, strong) NSMutableArray    *imageURLArray;
@property (nonatomic, strong) NSMutableArray    *reuserImageViews;
@property (nonatomic, strong) NSMutableArray    *imageViewArray;
@property (nonatomic, strong) NSTimer           *timer;

@end

@implementation HDDownloadImageManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[HDDownloadImageManager alloc] init];
    });
    return __manager;
}

- (void)addDownloadUrl:(NSString *)url
{
    if (url == nil) {
        return;
    }
    if ([self.imageURLArray containsObject:url]) {
        return;
    }
    [self.imageURLArray addObject:url];
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)respondsToTimer
{
    if (self.imageURLArray.count <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    NSString *firstURL = self.imageURLArray[0];
    [self.imageURLArray removeObjectAtIndex:0];
    [self downloadImageWithURL:firstURL];
}

- (void)downloadImageWithURL:(NSString *)urlString
{
    UIImageView *imageView = [self imageView];
    NSURL *url = [NSURL URLWithString:urlString];
    [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error == nil) {
        }
        [self.imageViewArray removeObject:imageView];
        [self.reuserImageViews addObject:imageView];
    }];
}

- (UIImageView *)imageView
{
    if (self.reuserImageViews.count > 0) {
        UIImageView *imageView = self.reuserImageViews[0];
        [self.reuserImageViews removeObjectAtIndex:0];
        return imageView;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.imageViewArray addObject:imageView];
    return imageView;
}



- (NSMutableArray *)imageURLArray
{
    if (_imageURLArray == nil) {
        _imageURLArray = [NSMutableArray array];
    }
    return _imageURLArray;
}

- (NSMutableArray *)reuserImageViews
{
    if (_reuserImageViews) {
        _reuserImageViews = [NSMutableArray array];
    }
    return _reuserImageViews;
}

- (NSMutableArray *)imageViewArray
{
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

@end
