//
//  HDUserManager.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserManager.h"
#import "HDUserEntity.h"
#import "HDHttpManager.h"
#import "HDModifyUserEntity.h"
#import "HDImageManager.h"

@implementation HDUserManager

+ (void)requestToModifyUser:(HDModifyUserEntity *)entity completeBlock:(void (^) (BOOL succeed, NSString *content))completeBlock
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO, nil);
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1022", baseURLStr];
    
    UIImage *image = [HDImageManager getImageWithName:entity.headImageURL];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *filename = [entity.headImageURL stringByAppendingString:@".jpg"];
    BOOL isFile = entity.type == ModifyHead;
    [HDHttpManager uploadMessage:urlString parameters:[entity deserializer] data:data filename:filename success:^(NSString *string) {
        if (entity.type == ModifyHead) {
            if (string.length > 0) {
                HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
                userEntity.userHeadURL = string;
                [HDLocalDataManager saveUserWithString:[userEntity deserializer]];
                completeBlock(YES, string);
            } else {
                completeBlock(NO, nil);
            }
        } else {
            if ([string isEqualToString:@"success"]) {
                completeBlock(YES, nil);
            } else {
                completeBlock(NO, nil);
            }
        }

    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    } isFile:isFile];
}

+ (void)requestToSendFeedBack:(NSString *)userGuid message:(NSString *)message images:(NSMutableArray *)imageNames completeBlock:(void (^) (BOOL succeed))completeBlock
{
    NSString *baseURLStr = [HDLocalDataManager getBaseURLString];
    if (baseURLStr.length <= 0) {
        completeBlock(NO);
    }
    NSString *urlString = [baseURLStr stringByAppendingFormat:@"?type=1042"];
    NSString *paramter = [NSString stringWithFormat:@"1042=KHHCLHK=%@", userGuid];
    [HDHttpManager uploadMessage:urlString parameters:paramter text:message images:imageNames success:^(NSString *string) {
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
