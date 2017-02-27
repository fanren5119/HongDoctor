//
//  HDLocalDataManager.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDLocalDataManager.h"
#import "HDUserEntity.h"
#import "HDIconEntity.h"
#import "HDMainHeaderEntity.h"
#import "HDMainTitleEntity.h"

#define  UserDefaults       [NSUserDefaults standardUserDefaults]
#define  StartTitle         @"HD_StartTitle"
#define  StartImageURL      @"HD_StartImageURL"
#define  StartInterval      @"HD_StartInterval"
#define  StartFailURL       @"HD_StartFailURL"
#define  RegisterURL        @"HD_RegisterURL"
#define  FindPasswordURL    @"HD_FindPasswordURL"
#define  LoginHeadURL       @"HD_LoginHeadURL"
#define  LoginNumber        @"HD_LoginNumber"
#define  LoginPassword      @"HD_LoginPassword"
#define  UserKey            @"HD_UserKey"
#define  BaseURLString      @"HD_BaseURLString"
#define  MainURLString      @"HD_MainURLString"
#define  SearchURLString    @"HD_SearchURLString"
#define  MainContent        @"HD_MainContent"
#define  MainIcons          @"HD_MainIcons"
#define  UserTokenId        @"HD_UserTokenId"
#define  MainHeaderString   @"HD_MainHeaderString"
#define  MainTitleString    @"HD_MainTitleString"

#define  VideoRecordLength  @"HD_VideoRecordLength"
#define  AudioRecordLength  @"HD_AudioRecordLength"
#define  NotificationSwitch @"HD_NotificationSwitch"

#define  HasReadAudio       @"HD_HasReadAudios"


@implementation HDLocalDataManager

+ (void)saveStartTitle:(NSString *)startTitle
{
    if (startTitle == nil) {
        return;
    }
    [UserDefaults setObject:startTitle forKey:StartTitle];
    [UserDefaults synchronize];
}

+ (void)saveStartImageURL:(NSString *)startURL
{
    if (startURL) {
        [UserDefaults setObject:startURL forKey:StartImageURL];
    }
}

+ (NSString *)getStartImageURL
{
    return [UserDefaults objectForKey:StartImageURL];
}

+ (NSString *)getStartTitle
{
    return [UserDefaults stringForKey:StartTitle];
}

+ (void)saveStartInterval:(NSString *)startInterval
{
    if (startInterval != nil) {
        [UserDefaults setObject:startInterval forKey:StartInterval];
    }
}

+ (NSInteger)getStartInterval
{
    NSString *interval = [UserDefaults objectForKey:StartInterval];
    return interval == nil ? 2 : [interval integerValue];
}

+ (void)saveStartFailURL:(NSString *)failURL
{
    if (failURL) {
        [UserDefaults setObject:failURL forKey:StartFailURL];
    }
}

+ (NSString *)getFailURL
{
    return [UserDefaults objectForKey:StartFailURL];
}

+ (void)saveRegisterURL:(NSString *)registerURL
{
    if (registerURL) {
        [UserDefaults setObject:registerURL forKey:RegisterURL];
    }
}
+ (NSString *)getRegisterURL
{
    return [UserDefaults objectForKey:RegisterURL];
}

+ (void)saveFindPasswordURL:(NSString *)findPasswordURL
{
    if (findPasswordURL) {
        [UserDefaults setObject:findPasswordURL forKey:FindPasswordURL];
    }
}
+ (NSString *)getFindPasswordURL
{
    return [UserDefaults objectForKey:FindPasswordURL];
}

#pragma -mark login

+ (void)saveLoginHeadURL:(NSString *)headURL
{
    if (headURL != nil) {
        [UserDefaults setObject:headURL forKey:LoginHeadURL];
    }
}

+ (NSString *)getLoginHeadURL
{
    return [UserDefaults stringForKey:LoginHeadURL];
}

+ (void)saveLoginNumber:(NSString *)loginNumber
{
    if (loginNumber) {
        [UserDefaults setObject:loginNumber forKey:LoginNumber];
    }
}
+ (NSString *)getLoginNumber
{
    return [UserDefaults objectForKey:LoginNumber];
}

+ (void)saveLoginPassword:(NSString *)password
{
    if (password) {
        [UserDefaults setObject:password forKey:LoginPassword];
    }
}

+ (NSString *)getLoginPassword
{
    return [UserDefaults objectForKey:LoginPassword];
}

+ (void)saveUserWithString:(NSString *)entity
{
    if (entity == nil) {
        return;
    }
    [UserDefaults setObject:entity forKey:UserKey];
    [UserDefaults synchronize];
}

+ (HDUserEntity *)getUserEntity
{
    NSString *string = [UserDefaults stringForKey:UserKey];
    return [HDUserEntity serializerWithString:string];
}

+ (void)saveBaseURLString:(NSString *)baseURLString
{
    if (baseURLString.length > 0) {
        [UserDefaults setObject:baseURLString forKey:BaseURLString];
    }
}
+ (NSString *)getBaseURLString
{
    return [UserDefaults objectForKey:BaseURLString];
}

+ (void)saveMainURLString:(NSString *)mainURLString
{
    if (mainURLString.length > 0) {
        [UserDefaults setObject:mainURLString forKey:MainURLString];
    }
}
+ (NSString *)getMainURLString
{
    return [UserDefaults objectForKey:MainURLString];
}

+ (void)saveSearchUrlString:(NSString *)searchURLString
{
    if (searchURLString) {
        [UserDefaults setObject:searchURLString forKey:SearchURLString];
    }
}

+ (NSString *)getSearchUrlString
{
    return [UserDefaults objectForKey:SearchURLString];
}

+ (void)saveTokenId:(NSString *)tokenId
{
    if (tokenId) {
        [UserDefaults setObject:tokenId forKey:UserTokenId];
    }
}

+ (NSString *)getTokenId
{
    NSString *token = [UserDefaults objectForKey:UserTokenId];
    return token ? token : @"";
}

+ (void)saveMainHeader:(NSString *)mainHeaderStr
{
    if (mainHeaderStr) {
        [UserDefaults setObject:mainHeaderStr forKey:MainHeaderString];
    }
}

+ (NSArray *)getMainHeaderArray
{
    NSString *mainHeader = [UserDefaults objectForKey:MainHeaderString];
    return [HDMainHeaderEntity serializerWithString:mainHeader];
}

+ (void)saveMainTitle:(NSString *)mainTitleStr
{
    if (mainTitleStr) {
        [UserDefaults setObject:mainTitleStr forKey:MainTitleString];
    }
}

+ (NSArray *)getMainTitleArray
{
    NSString *mainTitle = [UserDefaults objectForKey:MainTitleString];
    return [HDMainTitleEntity serializerWithString:mainTitle];
}


#pragma -mark setting

+ (void)saveVideoRecordLength:(NSNumber *)length
{
    if (length) {
        [UserDefaults setObject:length forKey:VideoRecordLength];
    }
}
+ (NSInteger)getVideoRecordLength
{
    NSNumber *length = [UserDefaults objectForKey:VideoRecordLength];
    if (length == nil) {
        return 10;
    }
    return [length integerValue];
}

+ (void)saveAudioRecordLength:(NSNumber *)length
{
    if (length) {
        [UserDefaults setObject:length forKey:AudioRecordLength];
    }
}
+ (NSInteger)getAudioRecordLength
{
    NSNumber *length = [UserDefaults objectForKey:AudioRecordLength];
    if (length == nil) {
        return 20;
    }
    return [length integerValue];
}

+ (void)saveNotificationSwitch:(BOOL)isOn
{
    [UserDefaults setBool:isOn forKey:NotificationSwitch];
}
+ (BOOL)getNotificationSwitch
{
    NSNumber *isOn = [UserDefaults objectForKey:NotificationSwitch];
    if (isOn == nil) {
        return YES;
    }
    return [isOn boolValue];
}


#pragma -mark hasReadAudios

+ (void)saveHasReadAudioGuid:(NSString *)audioGuid
{
    NSMutableArray *hasReadAudios = [self getHasReadAudioGuids].mutableCopy;
    if ([hasReadAudios containsObject:audioGuid]) {
        return;
    }
    if (hasReadAudios == nil) {
        hasReadAudios = [NSMutableArray array];
    }
    [hasReadAudios addObject:audioGuid];
    [UserDefaults setObject:hasReadAudios forKey:HasReadAudio];
    [UserDefaults synchronize];
}

+ (void)saveHasReadAudioGuids:(NSArray *)audioGuids
{
    NSMutableArray *hasReadAudios = [self getHasReadAudioGuids].mutableCopy;
    if (hasReadAudios != nil) {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT(SELF in %@)",hasReadAudios];
        NSArray *audios = [audioGuids filteredArrayUsingPredicate:thePredicate];
        [hasReadAudios addObject:audios];
        [UserDefaults setObject:hasReadAudios forKey:HasReadAudio];
        [UserDefaults synchronize];
    } else {
        [UserDefaults setObject:audioGuids forKey:HasReadAudio];
        [UserDefaults synchronize];
    }
}

+ (NSArray *)getHasReadAudioGuids
{
    return [UserDefaults objectForKey:HasReadAudio];
}

@end
