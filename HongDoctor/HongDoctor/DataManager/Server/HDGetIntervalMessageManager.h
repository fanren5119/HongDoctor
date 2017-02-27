//
//  HDGetIntervalMessageManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDGetIntervalMessageManager : NSObject

+ (instancetype)shareInstance;

- (void)startGetMessage;
- (void)stopGetMessage;

@end
