//
//  HDContractManager.h
//  HongDoctor
//
//  Created by wanglei on 2017/2/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDResponseMemberEntity;

@interface HDContractManager : NSObject

+ (void)requestRefreshContract:(NSString *)userGuid completeBlock:(void (^) (BOOL succeed))completeBlock;

+ (void)requestGetMember:(NSString *)userGuid memberId:(NSString *)memberGuid completeBlock:(void (^) (BOOL succeed, HDResponseMemberEntity *entity))completeBlock;

@end
