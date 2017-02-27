//
//  HDGroupManager.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupManager.h"
#import "HDHttpManager.h"
#import "HDLocalDataManager.h"
#import "HDDataSerializerManager.h"
#import "HDResponseChatGroupEntity.h"
#import "HDModifyGroupEntity.h"
#import "HDDiagonsisEntity.h"

@implementation HDGroupManager

+ (void)createGroup:(NSString *)userId memberGuids:(NSArray *)memberGuids groupId:(NSString *)groupId completeBlock:(void (^) (BOOL succeed, HDResponseChatGroupEntity *entity))completeBlock
{
    NSString *memberStr = [memberGuids componentsJoinedByString:@","];
    NSString *baseUrlStr = [HDLocalDataManager getBaseURLString];
    if (baseUrlStr.length <= 0) {
        completeBlock(NO, nil);
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1012&17Intellu=%@&17Intellus=%@&17Intellg=%@", baseUrlStr, userId, memberStr, groupId];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        HDResponseChatGroupEntity *entity = [HDDataSerializerManager serializerWithCreateGroupString:string];
        if (entity == nil) {
            completeBlock(NO, nil);
        } else {
            completeBlock(YES, entity);
        }
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    }];
}

+ (void)quitGroup:(NSString *)userId groupId:(NSString *)groupId completBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baserURLStr = [HDLocalDataManager getBaseURLString];
    if (baserURLStr.length <= 0) {
        completeBlock(NO);
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1017&17Intellu=%@&17Intellg=%@", baserURLStr, userId, groupId];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        if ([string isEqualToString:@"success"]) {
            completeBlock(YES);
        } else {
            completeBlock(NO);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO);
    }];
}

+ (void)requestGetGroupMember:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed, NSArray *membersArray))completeBlock
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO, nil);
    }
    NSString *urlString = [baseURLStr stringByAppendingFormat:@"?type=1026&17Intellg=%@", groupGuid];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        NSArray *array = [string componentsSeparatedByString:@"KHCLCHK"];
        completeBlock(YES, array);
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    }];
}


+ (void)requestModifyGroup:(HDModifyGroupEntity *)entity completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO);
    }
    NSString *urlString = [baseURLStr stringByAppendingString:@"?type=1022"];
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:nil filename:@"" success:^(NSString *string) {
        if ([string isEqualToString:@"success"]) {
            completeBlock(YES);
        } else {
            completeBlock(NO);
        }
    } fail:^(NSString *message) {
        completeBlock(NO);
    } isFile:NO];
}

+ (void)requestToDiagonsis:(NSString *)userGuid groupGuid:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed, HDDiagonsisEntity *entity))completeBlock;
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO, nil);
    }
    NSString *urlString = [baseURLStr stringByAppendingFormat:@"?type=1029&17Intellu=%@&17Intellg=%@", userGuid, groupGuid];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        HDDiagonsisEntity *entity = [HDDiagonsisEntity serializerEntityWithString:string];
        if (entity != nil) {
            completeBlock(YES, entity);
        } else {
            completeBlock(NO, nil);
        }
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    }];
}

@end
