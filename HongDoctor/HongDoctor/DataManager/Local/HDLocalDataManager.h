//
//  HDLocalDataManager.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDUserEntity;
@class HDMainEntity;

@interface HDLocalDataManager : NSObject


#pragma -mark start

+ (void)saveStartTitle:(NSString *)startTitle;
+ (NSString *)getStartTitle;

+ (void)saveStartImageURL:(NSString *)startURL;
+ (NSString *)getStartImageURL;

+ (void)saveStartInterval:(NSString *)startInterval;
+ (NSInteger)getStartInterval;

+ (void)saveStartFailURL:(NSString *)failURL;
+ (NSString *)getFailURL;

+ (void)saveRegisterURL:(NSString *)registerURL;
+ (NSString *)getRegisterURL;

+ (void)saveFindPasswordURL:(NSString *)findPasswordURL;
+ (NSString *)getFindPasswordURL;

#pragma -mark login

+ (void)saveLoginHeadURL:(NSString *)headURL;
+ (NSString *)getLoginHeadURL;

+ (void)saveLoginNumber:(NSString *)loginNumber;
+ (NSString *)getLoginNumber;

+ (void)saveLoginPassword:(NSString *)password;
+ (NSString *)getLoginPassword;

+ (void)saveUserWithString:(NSString *)entity;
+ (HDUserEntity *)getUserEntity;

+ (void)saveBaseURLString:(NSString *)baseURLString;
+ (NSString *)getBaseURLString;

+ (void)saveMainURLString:(NSString *)mainURLString;
+ (NSString *)getMainURLString;

+ (void)saveSearchUrlString:(NSString *)searchURLString;
+ (NSString *)getSearchUrlString;

+ (void)saveTokenId:(NSString *)tokenId;
+ (NSString *)getTokenId;

+ (void)saveMainHeader:(NSString *)mainHeaderStr;
+ (NSArray *)getMainHeaderArray;

+ (void)saveMainTitle:(NSString *)mainTitleStr;
+ (NSArray *)getMainTitleArray;


#pragma -mark setting

+ (void)saveVideoRecordLength:(NSNumber *)length;
+ (NSInteger)getVideoRecordLength;

+ (void)saveAudioRecordLength:(NSNumber *)length;
+ (NSInteger)getAudioRecordLength;

+ (void)saveNotificationSwitch:(BOOL)isOn;
+ (BOOL)getNotificationSwitch;

#pragma -mark save hasReadAudio

+ (void)saveHasReadAudioGuid:(NSString *)audioGuid;
+ (void)saveHasReadAudioGuids:(NSArray *)audioGuids;
+ (NSArray *)getHasReadAudioGuids;

@end
