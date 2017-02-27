//
//  HDGroupManager.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HDResponseChatGroupEntity;
@class HDModifyGroupEntity;
@class HDDiagonsisEntity;

@interface HDGroupManager : NSObject

+ (void)createGroup:(NSString *)userId memberGuids:(NSArray *)memberGuids groupId:(NSString *)groupId completeBlock:(void (^) (BOOL succeed, HDResponseChatGroupEntity *entity))completeBlock;

+ (void)quitGroup:(NSString *)userId groupId:(NSString *)groupId completBlock:(void (^) (BOOL succeed))completeBlock;

+ (void)requestGetGroupMember:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed, NSArray *membersArray))completeBlock;

+ (void)requestModifyGroup:(HDModifyGroupEntity *)entity completeBlock:(void (^) (BOOL succeed))completeBlock;

+ (void)requestToDiagonsis:(NSString *)userGuid groupGuid:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed, HDDiagonsisEntity *entity))completeBlock;

@end
