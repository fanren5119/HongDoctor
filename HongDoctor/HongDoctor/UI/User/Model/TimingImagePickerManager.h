//
//  ZGImagePickerManager.h
//  ZiGe
//
//  Created by wanglei on 15/6/12.
//  Copyright (c) 2015年 Yipinapp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinistGetImage)(NSString *imageId) ;

@interface TimingImagePickerManager : NSObject

@property (nonatomic, strong) FinistGetImage success;


+ (instancetype)shareManager;

- (void)imagePickerPresentFromViewController:(UIViewController *)viewController ;

@end
