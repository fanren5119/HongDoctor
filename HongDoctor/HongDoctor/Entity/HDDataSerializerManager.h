//
//  HDLoginDataSerializerManager.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDResponseChatGroupEntity;

@interface HDDataSerializerManager : NSObject

+ (void)serializerWithLoginString:(NSString *)string;

+ (void)serializerWithBeginString:(NSString *)string;

+ (HDResponseChatGroupEntity *)serializerWithCreateGroupString:(NSString *)string;

+ (NSArray *)serializerWithGroupIntervalString:(NSString *)string;

@end
