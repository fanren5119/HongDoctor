//
//  HDVideoTransform.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/27.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDVideoTransform : NSObject

+ (void)tranformMov:(NSURL *)movPath toMp4:(NSString *)mp4Path completeBlock:(void (^) (BOOL succeed))completeBlock;

@end
