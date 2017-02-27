//
//  HDCoreDataManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class HDResponseChatMessageEntity;
@class HDChatGroupEntity;
@class HDResponseChatGroupEntity;
@class HDResponseMemberEntity;
@class HDMemberEntity;
@class HDSendMessageEntity;

@interface HDCoreDataManager : NSObject

// 通讯录成员
+ (void)saveLocalAddressBooks:(NSArray *)memberArray;
+ (void)saveRemoteAddressBooks:(NSArray *)memberArray;
+ (void)saveNoLocalAddressBooks:(NSArray *)memberArray;
+ (RLMResults *)getLocalAddressBooks;
+ (RLMResults *)getRemotAddressBooks;
+ (RLMResults *)getLocalAddressBooksWithOutIds:(NSArray *)memberIds;
+ (RLMResults *)getRemotAddressBooksWithOutIds:(NSArray *)memberIds;
+ (RLMResults *)getAddressBooksWithName:(NSString *)name outMemberIds:(NSArray *)outMemberIds;
+ (RLMResults *)getAddressBooksWithIds:(NSArray *)idsArray;
+ (HDMemberEntity *)getAddressBookWithId:(NSString *)memberId;


+ (void)saveChatGroups:(NSArray *)groupArray;
+ (void)saveChatGroup:(HDResponseChatGroupEntity *)groupInfo;
+ (RLMResults *)getChatGroups;
+ (RLMResults *)getChatGroupsWithGroupName:(NSString *)name;
+ (void)modifyGroup:(NSString *)groupGuid unReadCount:(NSInteger)count;
+ (void)modifyGroup:(NSString *)groupGuid groupName:(NSString *)groupName;
+ (void)modifyGroup:(NSString *)groupGuid groupPost:(NSString *)groupPost;
+ (void)deleteGroup:(NSString *)groupGuid;
+ (void)deleteAllGroup;

+ (HDChatGroupEntity *)getChatGroupWithGuid:(NSString *)groupGuid;
+ (void)saveChatMessages:(NSArray *)messagesArray groupGuid:(NSString *)groupGuid;
+ (void)saveChatMessage:(HDResponseChatMessageEntity *)entity groupGuid:(NSString *)groupGuid;
+ (void)saveSendMessage:(HDSendMessageEntity *)entity groupGuid:(NSString *)groupId;
+ (RLMResults *)getGroupChatMessage:(NSString *)groupGuid;
+ (void)deleteChatMessage:(NSString *)groupGuid messageId:(NSString *)messageId;
+ (void)deleteChatMessage:(NSString *)groupGuid;

+ (void)clearCacheData;

@end
