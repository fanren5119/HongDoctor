//
//  HDDownloadImageManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDownloadImageManager : NSObject

+ (instancetype)shareManager;

- (void)addDownloadUrl:(NSString *)url;

@end
