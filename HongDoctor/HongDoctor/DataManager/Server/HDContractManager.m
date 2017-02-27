//
//  HDContractManager.m
//  HongDoctor
//
//  Created by wanglei on 2017/2/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDContractManager.h"
#import "HDHttpManager.h"
#import "HDCoreDataManager.h"
#import "HDResponseMemberEntity.h"

@implementation HDContractManager

+ (void)requestRefreshContract:(NSString *)userGuid completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseUrlStr = [HDLocalDataManager getBaseURLString];
    if (baseUrlStr.length <= 0) {
        completeBlock(NO);
    }
    NSString *urlString = [baseUrlStr stringByAppendingFormat:@"?type=1040&17Intellu=%@", userGuid];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        
        NSArray *array = [string componentsSeparatedByString:@"KHSEP3CLCSEP3HK"];
        if (array.count <= 0) {
            completeBlock(NO);
        }
        completeBlock(YES);
        if (array.count > 0) {
            NSArray *localEntitys = [HDResponseMemberEntity serializerWithString:array[0]];
            [HDCoreDataManager saveLocalAddressBooks:localEntitys];
        }
        
        if (array.count > 1) {
            NSArray *cloundEntitys = [HDResponseMemberEntity serializerWithString:array[1]];
            [HDCoreDataManager saveRemoteAddressBooks:cloundEntitys];
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO);
    }];
}

+ (void)requestGetMember:(NSString *)userGuid memberId:(NSString *)memberGuid completeBlock:(void (^) (BOOL succeed, HDResponseMemberEntity *entity))completeBlock
{
    NSString *baseUrlStr = [HDLocalDataManager getBaseURLString];
    if (baseUrlStr.length <= 0) {
        completeBlock(NO, nil);
    }
    NSString *urlString = [baseUrlStr stringByAppendingFormat:@"?type=1027&17Intellu=%@&17Intellg=%@", userGuid, memberGuid];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        
        HDResponseMemberEntity *entity = [HDResponseMemberEntity serializerEntityWithString:string];
        if (entity == nil) {
            completeBlock(NO, nil);
        } else {
            completeBlock(YES, entity);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    }];
}

@end
