//
//  HDMessageManager.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDSendMessageEntity;
@class HDSendMsgResponseEntity;

@interface HDMessageManager : NSObject

+ (void)requestGetIntervalMessage:(NSString *)userId groupGuid:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed))completeBlock;

+ (void)requestGetHistoryMessage:(NSString *)userGuid groupGuid:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed))completeBlock;

+ (void)requestSendMessage:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock;

+ (void)requestSendImage:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completBlock;

+ (void)requestSendAudio:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock;

+ (void)requestSendVideo:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock;

+ (void)requestSendLocation:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock;

+ (void)requestDeleteMessage:(NSString *)userId messageId:(NSString *)messageId completeBlock:(void (^) (BOOL succeed))completeBlock;

+ (void)requestForwardMessage:(NSString *)messageId userGuid:(NSString *)userGuid groupIds:(NSArray *)groupIds contactIds:(NSArray *)contractIds completeBlock:(void (^) (BOOL succeed))completeBlock;

@end
