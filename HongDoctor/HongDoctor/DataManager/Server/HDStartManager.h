//
//  HDStartManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDStartEntity;

@interface HDStartManager : NSObject

+ (void)requsetToStart:(void (^) (HDStartEntity *entity, BOOL successed))completeBlock;

@end
