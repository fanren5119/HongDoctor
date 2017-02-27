//
//  TimingPayAudioManager.h
//  Timing
//
//  Created by wanglei on 15/11/12.
//  Copyright © 2015年 Yipinapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimingPlayAudioManager : NSObject

+ (instancetype)shareManager;

- (void)playAudioWithUrl:(NSString *)audioUrl
             messageId:(NSString *)messageId
              groupId:(NSString *)groupId;

- (void)playAudioWithLocalPath:(NSString *)localPath;
- (void)stopPlayAudio;

@end
