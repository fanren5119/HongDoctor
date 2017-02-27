//
//  ZGAudioManager.m
//
//  Created by Owen.Qin on 13-5-9.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import "ZGAudioManager.h"
#import "AppDelegate.h"

static ZGAudioManager* audioManager = nil;

@interface ZGAudioManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSTimer           *timerProgress;

@end

@implementation ZGAudioManager

+ (ZGAudioManager*)sharedInstance
{
    if (audioManager == nil) {
        audioManager = [[ZGAudioManager alloc] init];
    }
    return audioManager;
}

+ (void)releaseInstance
{
    audioManager = nil;
}

- (id)init{
    if (self = [super init]) {
    }
    
    return self;
}

+ (BOOL)isMute
{
    // mute
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    OSStatus status = AudioSessionGetProperty (
                                               kAudioSessionCategory_UserInterfaceSoundEffects,//kAudioSessionProperty_AudioRoute,//kAudioSessionProperty_AudioRouteDescription
                                               &routeSize,
                                               &route
                                               );
    if (status == kAudioSessionNoError && (route == NULL || !CFStringGetLength(route)))
    {
        return YES;
    }
    return NO;
}

//系统音量
+ (float) audioVolume
{
    float volume = 0.0;
    UInt32 dataSize = sizeof(float);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    OSStatus status = AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume,
                                               &dataSize,
                                               &volume);
    if (status == kAudioSessionNoError)
    {
        return volume;
    }
    return 0;
}

- (void)playAudioFile:(NSString*)filePath {

	NSURL *url = [NSURL fileURLWithPath:filePath];
	NSError *error;
	if (self.audioPlayer && self.status == E_AudioStatus_Play) {
        [self updateAudioPlayerStatus:E_AudioStatus_Stop];
		[self.audioPlayer stop];
        self.audioPlayer = nil;
	}
	
    if (YES)
    {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (self.audioPlayer && [self.audioPlayer prepareToPlay]) {
            [self.audioPlayer play];
            [self updateAudioPlayerStatus:E_AudioStatus_Play];
        }
    }
	
}

- (void)playAudioFileUntilCompleted:(NSString*)filePath
{
	NSURL *url = [NSURL fileURLWithPath:filePath];
	NSError *error;
	if (self.audioPlayer && self.status == E_AudioStatus_Play) {
		return;
	}
	
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (self.audioPlayer) {
        if ([self.audioPlayer prepareToPlay]) {
            [self.audioPlayer setVolume: [ZGAudioManager audioVolume]];
            [self.audioPlayer play];
            self.audioPlayer.delegate = self;
        }
        [self updateAudioPlayerStatus:E_AudioStatus_Play];
    }
}

- (void) playAlertSound:(NSString*)filePath
{
    SystemSoundID sound = kSystemSoundID_Vibrate;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&sound);
    if (error != kAudioSessionNoError)
    {
        sound = 0;
    }
    AudioServicesPlaySystemSound(sound);
    AudioServicesRemoveSystemSoundCompletion(sound);
}

- (void)stopAudioFile {
	if (self.audioPlayer && [self.audioPlayer isPlaying]) {
        [self updateAudioPlayerStatus:E_AudioStatus_Stop];
		[self.audioPlayer stop];
        self.audioPlayer = nil;
	}
}

- (void)playZGDefaultAudio
{
//    if ([AppDelegate isOpenSound]) {
//        [[ZGAudioManager sharedInstance] playAudioFile:[[NSBundle mainBundle] pathForResource:@"audio_ZG_general" ofType:@"mp3"]];
//    }
    
    [self playShock];
    
}

- (void)playZGAcceptedAudio
{
//    if ([AppDelegate isOpenSound]) {
//        [[ZGAudioManager sharedInstance] playAudioFile:[[NSBundle mainBundle] pathForResource:@"audio_ZG_accepted" ofType:@"mp3"]];
//    }
    
    [self playShock];
    
}

- (void)playZGCompletedAudio
{
//    if ([AppDelegate isOpenSound]) {
//        [[ZGAudioManager sharedInstance] playAudioFile:[[NSBundle mainBundle] pathForResource:@"audio_ZG_completed" ofType:@"mp3"]];
//    }
    
    [self playShock];
}

- (void)playNewMessageAudio
{
//    if ([AppDelegate isOpenSound]) {
//        [[ZGAudioManager sharedInstance] playAlertSound:[[NSBundle mainBundle] pathForResource:@"audio_msg" ofType:@"wav"]];
//    }
//    
    [self playShock];
    
}

- (void)playTabAudio
{
//    if ([AppDelegate isOpenSound]) {
//        [[ZGAudioManager sharedInstance] playAlertSound:[[NSBundle mainBundle] pathForResource:@"audio_tab" ofType:@"wav"]];
//    }
    [self playShock];
}

- (void)playShock
{
//    if ([AppDelegate isOpenShock]) {
//        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
//    }
}

#pragma mark -
#pragma mark Play Audio Message

- (void)preparePlayAudioMessageFile:(NSString*)filePath
{
	self.audioFilePath = filePath;
	
	if (self.audioPlayer && [self.audioPlayer prepareToPlay]) {
        [self stopPlayAudioMessageFile];
        self.audioPlayer = nil;
	}
}

- (void)playAudioMessageFile:(NSString *)filePath
{
    if (nil == filePath)
    {
        return;
    }
    
	if (_audioPlayer == nil) {
		NSError *error = nil;
		NSURL *url = [NSURL fileURLWithPath:self.audioFilePath];
		self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
		// 如果发生错误，直接返回
		if (error) {
			return;
		}
		_audioPlayer.delegate = self;
	}

	// 播放
	if ([_audioPlayer prepareToPlay]) {
		[_audioPlayer play];
        
		// 默认使用扬声器播放
		NSError *error = nil;
		AVAudioSession *audioSession = [AVAudioSession sharedInstance];
		[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
		int audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRoute),&audioRoute);
		
		// 启用接近感应器
		[UIDevice currentDevice].proximityMonitoringEnabled = YES;
		// 添加近距离感应功能
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receiveProximityStateChanged:)
													 name:@"UIDeviceProximityStateDidChangeNotification"
												   object:nil];
		
		[self updateAudioPlayerStatus:E_AudioStatus_Play];
		
		// 更新进度
		_timerProgress = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerPlayProgress) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:_timerProgress forMode:NSRunLoopCommonModes];
		
		// 语音时间
		_audioDuration = _audioPlayer.duration;
        //
//		_audioPlayer.volume = 5;
	}
}

- (void)updateAudioPlayerStatus:(E_AudioStatus)status {
	self.status = status;
	switch (_status) {
		case E_AudioStatus_Init:
		{
		}
			break;
		case E_AudioStatus_Play:
		{
		}
			break;
		case E_AudioStatus_Pause:
		{
		}
			break;
		case E_AudioStatus_Stop:
		{
		}
		default:
			break;
	}
    
    // delegate
    if (self.delegateAM && [self.delegateAM respondsToSelector:@selector(audioManagerChangeState:)]) {
        [self.delegateAM audioManagerChangeState:self];
    }
}

- (void)stopPlayAudioMessageFile {
	// 禁用接近感应器
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
	[UIDevice currentDevice].proximityMonitoringEnabled = NO;
	
	// 停止播放
	if (_audioPlayer && self.status == E_AudioStatus_Play) {
		[_audioPlayer stop];
		_audioPlayer.currentTime = (NSTimeInterval)0.0;
		
		[self updateAudioPlayerStatus:E_AudioStatus_Stop];
		// 重置播放进度
		[self resetPlayProgress];
		// 暂停Timer
		[_timerProgress invalidate];
		_timerProgress = nil;
	}
}


#pragma mark -
#pragma mark Audio Player Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// 禁用接近感应器
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
	[UIDevice currentDevice].proximityMonitoringEnabled = NO;
	
    if (self.delegateAM && [self.delegateAM respondsToSelector:@selector(audioManagerDidFinishPlaying:)]) {
        [self.delegateAM audioManagerDidFinishPlaying:self];
    }
    
	[self updateAudioPlayerStatus:E_AudioStatus_Stop];
	// 重置进度
	[self resetPlayProgress];
	// 暂停Timer
	[_timerProgress invalidate];
	_timerProgress = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

#pragma mark -
#pragma mark Progress

- (void)updatePlayProgress {
	if (_audioPlayer) {
		// 更新刷新的次数
		_progressTimes++;
        
        if (self.delegateAM && [self.delegateAM respondsToSelector:@selector(audioManagerChangeProcess:)]) {
            [self.delegateAM audioManagerChangeProcess:self];
        }
	}
}


- (void)resetPlayProgress {
	if (_audioPlayer) {
		// 重置
		_audioDuration = 0;
		_progressTimes = 0;

        if (self.delegateAM && [self.delegateAM respondsToSelector:@selector(audioManagerChangeProcess:)]) {
            [self.delegateAM audioManagerChangeProcess:self];
        }
	}
}


- (void)timerPlayProgress {
	[self updatePlayProgress];
}


#pragma mark -
#pragma mark 近距离感应响应

- (void)receiveProximityStateChanged:(NSNotification*)notification {
	if ([UIDevice currentDevice].proximityState) {
		int audioRoute = kAudioSessionOverrideAudioRoute_None;
		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRoute),&audioRoute);
	}
	else {
		int audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRoute),&audioRoute);
	}
}



#pragma -mark  VolumeType

+ (void)saveVolumeType:(BOOL)on
{
    [[NSUserDefaults standardUserDefaults] setObject:@(on) forKey:@"kVolumeIsOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getVolumeType
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"kVolumeIsOn"];
    if (num == nil) {
        return YES;
    }
    return NO;
}


@end
