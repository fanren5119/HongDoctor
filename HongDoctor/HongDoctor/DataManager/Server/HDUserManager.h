//
//  HDUserManager.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDModifyUserEntity;

@interface HDUserManager : NSObject

+ (void)requestToModifyUser:(HDModifyUserEntity *)entity completeBlock:(void (^) (BOOL succeed, NSString *content))completeBlock;

+ (void)requestToSendFeedBack:(NSString *)userGuid message:(NSString *)message images:(NSMutableArray *)imageNames completeBlock:(void (^) (BOOL succeed))completeBlock;

@end
