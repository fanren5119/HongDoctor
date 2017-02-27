//
//  HDMessageManager.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageManager.h"
#import "HDHttpManager.h"
#import "HDLocalDataManager.h"
#import "HDDataSerializerManager.h"
#import "HDSendMessageEntity.h"
#import "HDImageManager.h"
#import "GWEncodeHelper.h"
#import "HDResponseChatMessageEntity.h"
#import "HDCoreDataManager.h"
#import "HDSendMsgResponseEntity.h"
#import "HDResponseMemberEntity.h"


@implementation HDMessageManager

+ (void)requestGetIntervalMessage:(NSString *)userId groupGuid:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseURLString = [HDLocalDataManager getBaseURLString];
    if (baseURLString.length <= 0) {
        completeBlock(NO);
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1024&17Intellu=%@&17Intellg=%@", baseURLString, userId, groupGuid];
    
    [HDHttpManager GET:urlString success:^(NSString *string) {
        NSArray *array = [string componentsSeparatedByString:@"KHSEP3CLCSEP3HK"];
        
        if (array.count > 0) {
            NSArray *msgArray = [HDResponseChatMessageEntity serializerWithString:array[0]];
            if (msgArray != nil && msgArray.count > 0) {
                [HDCoreDataManager saveChatMessages:msgArray groupGuid:groupGuid];
                completeBlock(YES);
            } else {
                completeBlock(NO);
            }
        }
        if (array.count > 1) {
            NSArray *noLocalArray = [HDResponseMemberEntity serializerWithString:array[1]];
            [HDCoreDataManager saveNoLocalAddressBooks:noLocalArray];
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO);
    }];
}

+ (void)requestGetHistoryMessage:(NSString *)userGuid groupGuid:(NSString *)groupGuid completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseURLString = [HDLocalDataManager getBaseURLString];
    if (baseURLString.length <= 0) {
        completeBlock(NO);
        return;
    }
    NSString *urlString = [baseURLString stringByAppendingFormat:@"?type=1025&17Intellu=%@&17Intellg=%@", userGuid, groupGuid];
    
    [HDHttpManager GET:urlString success:^(NSString *string) {
        NSArray *msgArray = [HDResponseChatMessageEntity serializerWithString:string];
        for (HDResponseChatMessageEntity *messageEntity in msgArray) {
            if ([messageEntity.messageType isEqualToString:@"3"]) {
                [HDLocalDataManager saveHasReadAudioGuid:messageEntity.messageGuid];
            }
        }
        if (msgArray != nil) {
            [HDCoreDataManager saveChatMessages:msgArray groupGuid:groupGuid];
            completeBlock(YES);
        } else {
            completeBlock(NO);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO);
    }];
}

+ (void)requestSendMessage:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingHZ_GB_2312);
    NSData *data = [entity.content dataUsingEncoding:gbkEncoding];
    
    NSString *urlString = [entity.url stringByAppendingString:@"?type=1004"];
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:data filename:@"" success:^(NSString *string) {
        
        HDSendMsgResponseEntity *entity = [HDSendMsgResponseEntity serializerWithString:string];
        if (entity != nil) {
            completeBlock(YES, entity);
        } else {
            completeBlock(NO, nil);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    } isFile:NO];
}

+ (void)requestSendImage:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock
{
    UIImage *image = [HDImageManager getImageWithName:entity.content];
    NSString *filename = [entity.content stringByAppendingString:@".jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *urlString = [entity.url stringByAppendingString:@"?type=1004"];
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:data filename:filename success:^(NSString *string) {
        HDSendMsgResponseEntity *entity = [HDSendMsgResponseEntity serializerWithString:string];
        if (entity != nil) {
            completeBlock(YES, entity);
        } else {
            completeBlock(NO, nil);
        }
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    } isFile:YES];
}

+ (void)requestSendAudio:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock
{
    NSData *data = [NSData dataWithContentsOfFile:entity.content];
    NSString *filename = [GWEncodeHelper md5:entity.content];
    filename = [filename stringByAppendingString:@".amr"];
    NSString *urlString = [entity.url stringByAppendingString:@"?type=1004"];
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:data filename:filename success:^(NSString *string) {
        HDSendMsgResponseEntity *entity = [HDSendMsgResponseEntity serializerWithString:string];
        if (entity != nil) {
            completeBlock(YES, entity);
        } else {
            completeBlock(NO, nil);
        }
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    } isFile:YES];
}

+ (void)requestSendVideo:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock
{
    NSURL *url = [NSURL fileURLWithPath:entity.content];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString *fileName = [GWEncodeHelper md5:entity.content];
    fileName = [fileName stringByAppendingString:@".mp4"];
    NSString *urlString = [entity.url stringByAppendingString:@"?type=1004"];
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:data filename:fileName success:^(NSString *string) {
        HDSendMsgResponseEntity *entity = [HDSendMsgResponseEntity serializerWithString:string];
        if (entity != nil) {
            completeBlock(YES, entity);
        } else {
            completeBlock(NO, nil);
        }
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    } isFile:YES];
}

+ (void)requestSendLocation:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *entity))completeBlock
{
    UIImage *image = [HDImageManager getImageWithName:entity.content];
    NSString *filename = [entity.content stringByAppendingString:@".jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *urlString = [entity.url stringByAppendingString:@"?type=1004"];
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:data filename:filename success:^(NSString *string) {
        HDSendMsgResponseEntity *entity = [HDSendMsgResponseEntity serializerWithString:string];
        if (entity != nil) {
            completeBlock(YES, entity);
        } else {
            completeBlock(NO, nil);
        }
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    } isFile:YES];
}

+ (void)requestDeleteMessage:(NSString *)userId messageId:(NSString *)messageId completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO);
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1016&17Intellu=%@&msgguid=%@", baseURLStr, userId, messageId];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        completeBlock(YES);
    } fail:^(NSString *message) {
        completeBlock(NO);
    }];
}

+ (void)requestForwardMessage:(NSString *)messageId userGuid:(NSString *)userGuid groupIds:(NSArray *)groupIds contactIds:(NSArray *)contractIds completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO);
    }
    NSMutableString *IdString = [NSMutableString string];
    if (groupIds.count > 0) {
        NSString *groupIdStr = [groupIds componentsJoinedByString:@"KHCLCHK"];
        [IdString appendString:groupIdStr];
    } else {
        [IdString appendString:@"nomsg"];
    }
    [IdString appendString:@"KH666CLC666HK"];
    if (contractIds.count > 0) {
        NSString *contractIdStr = [contractIds componentsJoinedByString:@"KHCLCHK"];
        [IdString appendString:contractIdStr];
    } else {
        [IdString appendString:@"nomsg"];
    }
    
    
    NSString *urlString = [baseURLStr stringByAppendingFormat:@"?type=1032&17Intellu=%@&17Intellm=%@&17Intellg=%@", userGuid, messageId, IdString];
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

@end
