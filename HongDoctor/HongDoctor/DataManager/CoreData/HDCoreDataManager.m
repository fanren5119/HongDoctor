//
//  HDCoreDataManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDCoreDataManager.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import "AppDelegate.h"

#import "HDResponseMemberEntity.h"
#import "HDResponseChatGroupEntity.h"
#import "HDResponseChatMessageEntity.h"
#import "HDSendMessageEntity.h"
#import "HDUserEntity.h"

#import "HDMemberEntity.h"
#import "HDChatMessageEntity.h"
#import "HDChatGroupEntity.h"

#define CountSeparator @"KH666CLC666HK"
#define Separator @"KHCLCHK"

@implementation HDCoreDataManager


#pragma -mark members

+ (void)saveLocalAddressBooks:(NSArray *)memberArray
{
    NSArray *orderArray = [self orderMemberArray:memberArray];
    [orderArray enumerateObjectsUsingBlock:^(HDResponseMemberEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveAddressBook:obj memberType:LocalMember];
    }];
}
+ (void)saveRemoteAddressBooks:(NSArray *)memberArray
{
    NSArray *orderArray = [self orderMemberArray:memberArray];
    [orderArray enumerateObjectsUsingBlock:^(HDResponseMemberEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveAddressBook:obj memberType:RemoteMember];
    }];
}
+ (void)saveNoLocalAddressBooks:(NSArray *)memberArray
{
    NSArray *orderArray = [self orderMemberArray:memberArray];
    [orderArray enumerateObjectsUsingBlock:^(HDResponseMemberEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveAddressBook:obj memberType:NoLocalMember];
    }];
}

+ (NSArray *)orderMemberArray:(NSArray *)memberArray
{
    return [memberArray sortedArrayUsingComparator:^NSComparisonResult(HDResponseMemberEntity *obj1, HDResponseMemberEntity *obj2) {
        NSString *charactor1 = obj1.nickname.hdfirstCharacter;
        NSString *charactor2 = obj2.nickname.hdfirstCharacter;
        return [charactor1 compare:charactor2];
    }].copy;
}

+ (void)saveAddressBook:(HDResponseMemberEntity *)member memberType:(MemberType)type
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        HDMemberEntity *entity = [[HDMemberEntity alloc] init];
        entity.isCompany = member.isCompany;
        entity.isOnLine = member.isOnLine;
        entity.orgguid = member.orgguid;
        entity.orgid = member.orgid;
        entity.orgname = member.orgname;
        entity.phone = member.phone;
        entity.sex = member.sex;
        entity.userDepartment = member.userDepartment;
        entity.userGrade = member.userGrade;
        entity.userGuid = member.userGuid;
        entity.userHeadURL = member.userHeadURL;
        entity.userId = member.userId;
        entity.userName = member.userName;
        entity.qrImageURL = member.qrImageURL;
        entity.number = member.number;
        entity.nickname = member.nickname;
        entity.organization = member.organization;
        entity.sorting = member.sorting;
        entity.type = type;
        [HDMemberEntity createOrUpdateInDefaultRealmWithValue:entity];
    }];
}

+ (RLMResults *)getLocalAddressBooks
{
    RLMResults *result = [HDMemberEntity objectsWhere:@"type=0"];
    return result;
}
+ (RLMResults *)getRemotAddressBooks
{
    RLMResults *result = [HDMemberEntity objectsWhere:@"type=1"];
    return result;
}

+ (RLMResults *)getLocalAddressBooksWithOutIds:(NSArray *)memberIds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=0 AND NOT(userGuid In %@)", memberIds];
    RLMResults *result = [HDMemberEntity objectsWithPredicate:predicate];
    return result;
}

+ (RLMResults *)getRemotAddressBooksWithOutIds:(NSArray *)memberIds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=1 AND NOT(userGuid In %@)", memberIds];
    RLMResults *result = [HDMemberEntity objectsWithPredicate:predicate];
    return result;
}

+ (RLMResults *)getAddressBooksWithName:(NSString *)name outMemberIds:(NSArray *)outMemberIds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName CONTAINS %@ AND NOT(userGuid In %@)", name, outMemberIds];
    RLMResults *result = [HDMemberEntity objectsWithPredicate:predicate];
    return result;
}

+ (RLMResults *)getAddressBooksWithIds:(NSArray *)idsArray
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userGuid in %@", idsArray];
    RLMResults *result = [HDMemberEntity objectsWithPredicate:predicate];
    return result;
}

+ (HDMemberEntity *)getAddressBookWithId:(NSString *)memberId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userGuid = %@", memberId];
    RLMResults *result = [HDMemberEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        return [result objectAtIndex:0];
    }
    return nil;
}

#pragma -mark chatGroups

+ (void)saveChatGroups:(NSArray *)groupArray
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDChatGroupsChangesNotification" object:nil userInfo:nil];
    [groupArray enumerateObjectsUsingBlock:^(HDResponseChatGroupEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveChatGroup:obj];
    }];
}

+ (void)saveChatGroup:(HDResponseChatGroupEntity *)groupInfo
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        HDChatGroupEntity *entity = [[HDChatGroupEntity alloc] init];
        entity.msgUnReadCount = groupInfo.msgUnReadCount;
        entity.groupOwnerName = groupInfo.groupOwnerName;
        entity.groupdName = groupInfo.groupdName;
        entity.groupGuid = groupInfo.groupGuid;
        entity.groupHeaderURl = groupInfo.groupHeaderURl;
        entity.groupMemberCount = groupInfo.groupMemberCount;
        entity.groupMsgType = groupInfo.groupMsgType;
        entity.groupNewDate = groupInfo.groupNewDate;
        entity.groupNewMessage = groupInfo.groupNewMessage;
        entity.groupOwnerId = groupInfo.groupOwnerId;
        entity.groupPost = groupInfo.groupPost;
        entity.groupProperty = groupInfo.groupProperty;
        entity.msgProperty = groupInfo.msgProperty;
        entity.groupQRImageURL = groupInfo.groupQRImageURL;
        [HDChatGroupEntity createOrUpdateInDefaultRealmWithValue:entity];
    }];
}

+ (RLMResults *)getChatGroups
{
    return [HDChatGroupEntity allObjects];
}

+ (RLMResults *)getChatGroupsWithGroupName:(NSString *)name
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupdName CONTAINS %@", name];
    return [HDChatGroupEntity objectsWithPredicate:predicate];
}

+ (HDChatGroupEntity *)getChatGroupWithGuid:(NSString *)groupGuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMResults *result = [HDChatGroupEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        return [result objectAtIndex:0];
    }
    return nil;
}

+ (void)modifyGroup:(NSString *)groupGuid unReadCount:(NSInteger)count
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMResults *result = [HDChatGroupEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            HDChatGroupEntity *entity = [result objectAtIndex:0];
            entity.msgUnReadCount = [NSString stringWithFormat:@"%ld", (long)count];
        }];
    }
}

+ (void)modifyGroup:(NSString *)groupGuid groupName:(NSString *)groupName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMResults *result = [HDChatGroupEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            HDChatGroupEntity *entity = [result objectAtIndex:0];
            entity.groupdName = groupName;
        }];
    }
}

+ (void)modifyGroup:(NSString *)groupGuid groupPost:(NSString *)groupPost
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMResults *result = [HDChatGroupEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            HDChatGroupEntity *entity = [result objectAtIndex:0];
            entity.groupPost = groupPost;
        }];
    }
}

+ (void)deleteGroup:(NSString *)groupGuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMResults *result = [HDChatGroupEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm deleteObject:result[0]];
        }];
    }
}

+ (void)deleteAllGroup
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm deleteObjects:[HDChatGroupEntity allObjects]];
}


#pragma -mark  group message

+ (void)saveChatMessages:(NSArray *)messagesArray groupGuid:(NSString *)groupGuid
{
    [messagesArray enumerateObjectsUsingBlock:^(HDResponseChatMessageEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveChatMessage:obj groupGuid:groupGuid];
    }];
}

+ (void)saveChatMessage:(HDResponseChatMessageEntity *)entity groupGuid:(NSString *)groupGuid
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        HDChatMessageEntity *messageEntity = [self insertMessageWithEntity:entity];
        messageEntity.groupGuid = groupGuid;
        [HDChatMessageEntity createOrUpdateInDefaultRealmWithValue:messageEntity];
    }];
}

+ (void)saveSendMessage:(HDSendMessageEntity *)entity groupGuid:(NSString *)groupId
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        HDChatMessageEntity *messageEntity = [[HDChatMessageEntity alloc] init];
        messageEntity.groupGuid = groupId;
        messageEntity.messageContent = entity.content;
        messageEntity.messageDate = entity.messageDate;
        messageEntity.messageGuid = entity.messageGuid;
        messageEntity.messageLength = entity.length;
        messageEntity.messageType = entity.bodytype;
        messageEntity.messageProperty = entity.mtype;
        HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
        messageEntity.senderGuid = userEntity.userGuid;
        messageEntity.senderHeadURL = userEntity.userHeadURL;
        messageEntity.senderName = userEntity.userName;
        messageEntity.sendingType = entity.sendType;
        [HDChatMessageEntity createOrUpdateInDefaultRealmWithValue:messageEntity];
    }];
}

+ (HDChatMessageEntity *)insertMessageWithEntity:(HDResponseChatMessageEntity *)message
{
    HDChatMessageEntity *entity = [[HDChatMessageEntity alloc] init];
    entity.messageContent = message.messageContent;
    entity.messageDate = message.messageDate;
    entity.messageGuid = message.messageGuid;
    entity.messageProperty = message.messageProperty;
    entity.messageType = message.messageType;
    entity.senderGuid = message.senderGuid;
    entity.senderHeadURL = message.senderHeadURL;
    entity.senderName = message.senderName;
    entity.messageLength = message.messageLength;
    entity.sendingType = message.sendingType;
    return entity;
}

+ (RLMResults *)getGroupChatMessage:(NSString *)groupGuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMSortDescriptor *descriptor = [RLMSortDescriptor sortDescriptorWithKeyPath:@"messageDate" ascending:YES];
    return [[HDChatMessageEntity objectsWithPredicate:predicate] sortedResultsUsingDescriptors:@[descriptor]];
}

+ (void)deleteChatMessage:(NSString *)groupGuid messageId:(NSString *)messageId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@ AND messageGuid=%@", groupGuid, messageId];
    RLMResults *result = [HDChatMessageEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm deleteObject:result[0]];
        }];
    }
}

+ (void)deleteChatMessage:(NSString *)groupGuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupGuid=%@", groupGuid];
    RLMResults *result = [HDChatMessageEntity objectsWithPredicate:predicate];
    if (result.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm deleteObjects:result];
        }];
    }
}

+ (void)clearCacheData
{
    [[RLMRealm defaultRealm] deleteAllObjects];
}

@end
