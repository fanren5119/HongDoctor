//
//  HDLoginManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDLoginManager.h"
#import "HDHttpManager.h"
#import "HDDataSerializerManager.h"

#define  GetLoginHeadURL @"/17Intell/mobileweb/postFile.jsp?type=902&17Intellu=%@"
#define  LoginURL @"/17Intell/mobileweb/postFile.jsp?type=905&17Intellu=%@&17Intellp=%@&KH=1&loginType=0"

@implementation HDLoginManager

+ (void)requestWithPhone:(NSString *)phone getLoginHead:(void (^) (NSString *headURL, BOOL succeed))completeBlock
{
    NSString *urlString = [NSString stringWithFormat:GetLoginHeadURL, phone];
    urlString = [HDbaseURL stringByAppendingString:urlString];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        completeBlock(string, YES);
    } fail:^(NSString *message) {
        completeBlock(nil, NO);
    }];
}

+ (void)requestLoginWithPhone:(NSString *)phone password:(NSString *)password completeBlock:(void(^) (BOOL succeed, NSString *message))completeBlock
{
    NSString *urlString = [NSString stringWithFormat:LoginURL, phone, password];
    urlString = [HDbaseURL stringByAppendingString:urlString];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        if ([string isEqualToString:@"error"]) {
            completeBlock(NO, @"error");
        } else {
            [HDDataSerializerManager serializerWithLoginString:string];
            completeBlock(YES, nil);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO, message);
    }];
}

+ (void)requestGetBeginData:(NSString *)userGuid completeBlock:(void (^) (BOOL success, NSString *message))completeBlock
{
    NSString *baseURLString = [HDLocalDataManager getBaseURLString];
    NSString *password = [HDLocalDataManager getLoginPassword];
    NSString *tokenId = [HDLocalDataManager getTokenId];
    NSString *urlString = [baseURLString stringByAppendingFormat:@"?type=1053&17Intellu=%@&17Intellp=%@&tokenId=%@", userGuid, password, tokenId];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        if ([string isEqualToString:@"backLogin"]) {
            completeBlock(NO, @"backLogin");
        } else if ([string isEqualToString:@"error"]) {
            completeBlock(NO, @"error");
        } else {
            [HDDataSerializerManager serializerWithBeginString:string];
            completeBlock(YES, nil);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO, message);
    }];
}

+ (void)requestGetIntervalBeginData:(NSString *)userGuid completeBlock:(void (^) (BOOL succeed, NSArray *iconsArray))completeBlock
{
    NSString *baseURLString = [HDLocalDataManager getBaseURLString];
    NSString *tokenId = [HDLocalDataManager getTokenId];
    NSString *urlString = [baseURLString stringByAppendingFormat:@"?type=1051&17Intellu=%@&tokenId=%@", userGuid, tokenId];
    NSLog(@"tokenid===%@", tokenId);
    [HDHttpManager GET:urlString success:^(NSString *string) {
        if ([string isEqualToString:@"dropped"]) {
            completeBlock(NO, @[]);
        } else {
            NSArray *iconArray = [HDDataSerializerManager serializerWithGroupIntervalString:string];
            completeBlock(YES, iconArray);
        }
        
    } fail:^(NSString *message) {
        completeBlock(NO, nil);
    }];
}

@end
