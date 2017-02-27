//
//  HDLoginDataSerializerManager.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDDataSerializerManager.h"
#import "HDLocalDataManager.h"
#import "HDUserEntity.h"
#import "HDResponseMemberEntity.h"
#import "HDResponseChatGroupEntity.h"
#import "HDCoreDataManager.h"
#import "HDIconEntity.h"
#import "HDResponseChatMessageEntity.h"
#import "HDNotificationEntity.h"
#import "HDNotificationManager.h"
#import "HDMainTitleEntity.h"

@implementation HDDataSerializerManager

+ (void)serializerWithLoginString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"KHSEP3CLCSEP3HK"];
    
    if (array.count > 0) {
        [HDLocalDataManager saveUserWithString:array[0]];
        HDUserEntity *userEntity = [HDUserEntity serializerWithString:array[0]];
        [[HDDownloadImageManager shareManager] addDownloadUrl:userEntity.userHeadURL];
        [[HDDownloadImageManager shareManager] addDownloadUrl:userEntity.qrImageURL];
    }
    
    if (array.count > 1) {
        NSArray *array2 = [array[1] componentsSeparatedByString:@"KHCLCHK"];
        if (array2.count > 0) {
            [HDLocalDataManager saveMainURLString:array2[0]];
        }
        if (array2.count > 1) {
            [HDLocalDataManager saveBaseURLString:array2[1]];
        }
        if (array2.count > 2) {
            [HDLocalDataManager saveSearchUrlString:array2[2]];
        }
    }
    if (array.count > 2) {
        [HDLocalDataManager saveMainHeader:array[2]];
    }
    if (array.count > 3) {
        NSLog(@"loginTokenId==%@", array[3]);
        [HDLocalDataManager saveTokenId:array[3]];
    }
    if (array.count > 4) {
        [HDMainTitleEntity serializerWithString:array[4]];
        [HDLocalDataManager saveMainTitle:array[4]];
    }
}

+ (void)serializerWithBeginString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"KHSEP3CLCSEP3HK"];
    if (array.count > 0) {
        NSArray *localEntitys = [HDResponseMemberEntity serializerWithString:array[0]];
        [HDCoreDataManager saveLocalAddressBooks:localEntitys];
    }
    
    if (array.count > 1) {
        NSArray *cloundEntitys = [HDResponseMemberEntity serializerWithString:array[1]];
        [HDCoreDataManager saveRemoteAddressBooks:cloundEntitys];
    }
    
    if (array.count > 2) {
        NSArray *noLocalEntitys = [HDResponseMemberEntity serializerWithString:array[2]];
        [HDCoreDataManager saveNoLocalAddressBooks:noLocalEntitys];
    }
    
    NSMutableArray *groupArray = [NSMutableArray array];
    for (int i = 3; i < array.count; i ++) {
        HDResponseChatGroupEntity *entity = [HDResponseChatGroupEntity serializerEntityWithString:array[i]];
        if (entity != nil) {
            [groupArray addObject:entity];
        }
    }
    [HDCoreDataManager saveChatGroups:groupArray];
    if (groupArray.count > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HDGroupDataChange" object:nil];
    }
}

+ (HDResponseChatGroupEntity *)serializerWithCreateGroupString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"KH666CLC666HK"];
    if (array.count <= 0) {
        return nil;
    }
    HDResponseChatGroupEntity *entity = [HDResponseChatGroupEntity serializerEntityWithString:array[0]];
    [HDCoreDataManager saveChatGroup:entity];
    if (array.count > 1) {
        NSArray *chatMessages = [HDResponseChatMessageEntity serializerWithString:array[1]];
        [HDCoreDataManager saveChatMessages:chatMessages groupGuid:entity.groupGuid];
    }
    return entity;
}

+ (NSArray *)serializerWithGroupIntervalString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"KHSEP3CLCSEP3HK"];
    NSMutableArray *groupArray = [NSMutableArray array];
    for (int i = 1; i < array.count; i ++) {
        HDResponseChatGroupEntity *entity = [HDResponseChatGroupEntity serializerEntityWithString:array[i]];
        if (entity != nil) {
            [groupArray addObject:entity];
        }
    }
    [HDCoreDataManager saveChatGroups:groupArray];
    if (groupArray.count > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HDGroupDataChange" object:nil];
    }
    
    if (array.count > 0) {
        NSArray *bageValueArray = [array[0] componentsSeparatedByString:@"="];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HDMainBageNumChange" object:nil userInfo:@{@"numbers": bageValueArray}];
    }
    return nil;
}

@end
