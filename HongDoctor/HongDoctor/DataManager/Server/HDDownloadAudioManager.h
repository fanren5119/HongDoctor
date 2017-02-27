//
//  HDDownloadAudioManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/23.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDownloadAudioManager : NSObject

+ (instancetype)shareManager;

- (void)addDownloadUrl:(NSString *)url;

- (void)uploadAudioWithURL:(NSString *)url completeBlock:(void (^) (NSString *path))completeBlock;

@end
