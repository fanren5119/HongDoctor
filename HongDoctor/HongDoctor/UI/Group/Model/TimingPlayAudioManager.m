//
//  TimingPayAudioManager.m
//  Timing
//
//  Created by wanglei on 15/11/12.
//  Copyright © 2015年 Yipinapp. All rights reserved.
//

#import "TimingPlayAudioManager.h"
#import "ZGAudioManager.h"
#import "TaskUtility.h"
#import "NSFileManager+BRAddition.h"
#import "GWEncodeHelper.h"
#import "HDDownloadAudioManager.h"
#import "VoiceConverter.h"

static TimingPlayAudioManager *manager = nil;

@interface TimingPlayAudioManager () <ZGAudioManagerDelegate>

@property (nonatomic, strong) NSString *messageId;

@end

@implementation TimingPlayAudioManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TimingPlayAudioManager alloc] init];
    });
    return manager;
}

- (void)playAudioWithUrl:(NSString *)audioUrl
               messageId:(NSString *)messageId
                 groupId:(NSString *)groupId
{
    self.messageId = messageId;
    
    NSString *audioName = [GWEncodeHelper md5:audioUrl];
    NSString* pathForWav = [TaskUtility pathForAttachmentAudioFile:[NSString stringWithFormat:@"%@.wav", audioName]];
    
    if ([NSFileManager fileExisted:pathForWav createIfNot:NO]) {
        [self playAudioWithPath:pathForWav];
        return;
    }
    [[HDDownloadAudioManager shareManager]uploadAudioWithURL:audioUrl completeBlock:^(NSString *path) {
        [self playAudioWithPath:pathForWav];
    }];
}

- (void)playAudioWithLocalPath:(NSString *)localPath
{
    [self playAudioWithPath:localPath];
}

- (void)playAudioWithPath:(NSString *)audioPath
{

    
    [[ZGAudioManager sharedInstance] preparePlayAudioMessageFile:audioPath];
    [ZGAudioManager sharedInstance].delegateAM = self;
    [[ZGAudioManager sharedInstance] playAudioMessageFile:audioPath];
}

- (void)stopPlayAudio
{
    [[ZGAudioManager sharedInstance] stopAudioFile];
    [[ZGAudioManager sharedInstance] stopPlayAudioMessageFile];
    if (self.messageId != nil) {
        NSDictionary *userInfoDic = @{@"status"     :@(E_AudioStatus_Stop),
                                      @"messageId"  :self.messageId};
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Playudio object:nil userInfo:userInfoDic];
    }
}

- (void)audioManagerChangeState:(ZGAudioManager *)audioManager
{
    NSDictionary *userInfoDic = @{@"status"     :@(audioManager.status),
                                  @"messageId"  :self.messageId};
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Playudio object:nil userInfo:userInfoDic];
}

- (void)audioManagerChangeProcess:(ZGAudioManager*)audioManager
{
    
}

- (void)audioManagerDidFinishPlaying:(ZGAudioManager*)audioManager
{
    
}

@end
