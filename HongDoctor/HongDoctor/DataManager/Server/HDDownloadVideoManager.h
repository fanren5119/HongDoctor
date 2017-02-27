//
//  HDDownloadVideoManager.h
//  HongDoctor
//
//  Created by 王磊 on 2017/2/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDownloadVideoManager : NSObject

+ (instancetype)shareManager;

- (void)addDownloadUrl:(NSString *)url;

- (void)uploadVideoWithURL:(NSString *)url completeBlock:(void (^) (BOOL succeed, NSString *path))completeBlock;

@end
