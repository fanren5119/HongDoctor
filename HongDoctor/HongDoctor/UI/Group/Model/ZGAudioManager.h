//
//  ZGAudioManager.h
//
//  Created by Owen.Qin on 13-5-9.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
	E_AudioStatus_Init = 0,
	E_AudioStatus_Play,
	E_AudioStatus_Pause,
	E_AudioStatus_Stop
} E_AudioStatus;

@protocol ZGAudioManagerDelegate;

@interface ZGAudioManager : NSObject
{
    BOOL _ismuted;
}

@property (nonatomic, strong) AVAudioPlayer                 *audioPlayer;
@property (nonatomic, weak) id<ZGAudioManagerDelegate>    delegateAM;

@property (nonatomic) E_AudioStatus             status;
@property (nonatomic) NSTimeInterval            audioDuration;	// 语音总时间
@property (nonatomic) NSInteger                 progressTimes;		// 语音播放时，进度更新的次数
@property (nonatomic, strong) NSString          *audioFilePath;

//@property (nonatomic) Float32                           volume;

+ (ZGAudioManager*)sharedInstance;
+ (void)releaseInstance;

+ (BOOL)isMute;
//系统音量
+ (float) audioVolume;

- (void) playAlertSound:(NSString*)filePath;
- (void)playAudioFile:(NSString*)filePath;
- (void)playAudioFileUntilCompleted:(NSString*)filePath;
- (void)stopAudioFile;
- (void)playZGDefaultAudio;
- (void)playZGAcceptedAudio;
- (void)playZGCompletedAudio;
- (void)playNewMessageAudio;
- (void)playTabAudio;

// audio message
- (void)preparePlayAudioMessageFile:(NSString*)filePath;
- (void)playAudioMessageFile:(NSString*)filePath;
- (void)updateAudioPlayerStatus:(E_AudioStatus)status;
- (void)stopPlayAudioMessageFile;

@end




@protocol ZGAudioManagerDelegate <NSObject>

@optional
- (void)audioManagerChangeState:(ZGAudioManager*)audioManager;
- (void)audioManagerChangeProcess:(ZGAudioManager*)audioManager;
- (void)audioManagerDidFinishPlaying:(ZGAudioManager*)audioManager;

@end