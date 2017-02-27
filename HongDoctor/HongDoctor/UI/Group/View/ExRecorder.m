//
//  ExRecorder.m
//  ExOffice
//
//  Created by MingbaoZhu on 14-3-20.
//  Copyright (c) 2014年 yipinapp. All rights reserved.
//

#import "ExRecorder.h"
#import "AppDelegate.h"
#import "VoiceConverter.h"
#import <UIKit/UIKit.h>

CGFloat const ExRecorderMinRecordDuration = 1.0f;

@interface ExRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSTimer *audioRecordTimer;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL isManualStopRecording;

@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, copy) ExRecorderRecordSuccessCallback successCallback;
@property (nonatomic, copy) ExRecorderRecordFailedCallback failedCallback;
@property (nonatomic, copy) ExRecorderRecordUpdateCallback updateCallback;
@property (nonatomic, copy) ExRecorderRecordWillStopCallback willStopCallback;

@end

@implementation ExRecorder

+ (instancetype) recorder
{
    ExRecorder *recorder = [[ExRecorder alloc] init];
    return recorder;
}

- (instancetype) init
{
    if (self = [super init])
    {
        [self reset];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidResignActive:) name: UIApplicationWillResignActiveNotification object: nil];
    }
    return self;
}

- (void) dealloc
{
    [self cancelRecord];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) registerSuccessCallback: (ExRecorderRecordSuccessCallback) success
                  failedCallback: (ExRecorderRecordFailedCallback) failed
                  updateCallback: (ExRecorderRecordUpdateCallback) update
                willStopCallback: (ExRecorderRecordWillStopCallback) willStop
{
    self.successCallback = success;
    self.failedCallback = failed;
    self.updateCallback = update;
    self.willStopCallback = willStop;
}

- (void)prepareRecord
{
    @synchronized (self)
    {
        // 准备Audio会话
        NSError *err = nil;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
        [[AVAudioSession sharedInstance] setActive:YES error:&err];
        
        if (nil != err)
        {
//            DebugLog(@"AVAudioSession prepared failed");
            return;
        }
        // 设置录音格式
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        // pcm
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        if (self.outputAudioFilePath && [self.outputAudioFilePath length] > 0) {
            // 准备文件和录音对象
            NSURL *url = [[NSURL alloc] initFileURLWithPath:self.tmpAudioFilePath];
            self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
            if(self.audioRecorder)
            {
                // prepare to record
                [self.audioRecorder setDelegate:self];
                [self.audioRecorder prepareToRecord];
                self.audioRecorder.meteringEnabled = YES;
                
                // 录音
                [self.audioRecorder recordForDuration:(NSTimeInterval)self.maxRecordDuration];
                self.audioRecordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                         target:self
                                                                       selector:@selector(timerRecordingProc:)
                                                                       userInfo:nil
                                                                        repeats:YES];
            }
        }
    }
}

- (void) prepareAudioSession
{
}

- (void)startRecord
{
    [self cancelRecord];
	// 判断 当前设备 是否支持 录音
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	BOOL inputAvailable = audioSession.inputAvailable;
    
    if (inputAvailable)
    {
        //Modify by Mingbao修复iOS7麦克风授权的问题
        if ([[AVAudioSession sharedInstance] respondsToSelector: @selector(requestRecordPermission:)])
        {
            [audioSession requestRecordPermission:^(BOOL granted) {
                if (granted)
                {
                    //addWithJunsun 2014.3.17 //修复录音播放声音轻的问题
                    [UIApplication sharedApplication].idleTimerDisabled = YES;
                    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
                    
                    if (inputAvailable)
                    {
                        // prepare record
                        self.isRecording = YES;
                        self.isCanceled = NO;
                        self.isManualStopRecording = NO;
                        [self prepareRecord];
                        [self.audioRecorder record];
                    }
                    else
                    {
                        [self showAlert:@"您的设备没有麦克风，无法录音！"];
                        // 弹出不支持录音的警告
                    }
                }
                else
                {
                    if (self.failedCallback)
                    {
                        self.failedCallback();
                    }
                    [self finishedRecord];
                    [self showAlert:@"请前往“设置-隐私-麦克风”选项中，允许随办访问你的手机麦克风"];
                }
            }];
        }
        else
        {
            // prepare record
            self.isRecording = YES;
            self.isCanceled = NO;
            self.isManualStopRecording = NO;
            [self prepareRecord];
            [self.audioRecorder record];
        }
    }
    else
    {
        [self showAlert:@"您的设备没有麦克风，无法录音！"];
    }
}

- (void)stopRecord
{
    //addWithJunsun 2014.3.17 //修复录音播放声音轻的问题
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    if([self.audioRecordTimer isValid])
    {
        [self.audioRecordTimer invalidate];
        self.audioRecordTimer = nil;
    }
    if (self.willStopCallback)
    {
        self.willStopCallback();
    }
	@synchronized (self)
    {
        self.isManualStopRecording = YES;
		if (self.audioRecorder && [self.audioRecorder isRecording])
        {
            self.recordTime = self.audioRecorder.currentTime;
            [self.audioRecorder stop];
		}
	}
}

- (void)cancelRecord
{
    self.isRecording = NO;
    self.isCanceled = YES;

    [self stopRecord];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.outputAudioFilePath error:nil];
}

- (void) finishedRecord
{
    self.successCallback = nil;
    self.failedCallback = nil;
    self.updateCallback = nil;
    self.willStopCallback = nil;
}

- (void)convertAmrAudioFile
{
    int ret = [VoiceConverter wavToAmr:self.tmpAudioFilePath amrSavePath:self.outputAudioFilePath];
    if (ret == 0)
    {
        if (self.successCallback)
        {
            self.successCallback(self.outputAudioFilePath, self.recordTime);
        }
    }
    else
    {
        if (self.failedCallback)
        {
            self.failedCallback();
        }
        [self showAlert:@"录音出错，请重新尝试！"];
    }
    [self finishedRecord];
}

- (void)timerRecordingProc:(id)object
{
    NSLog(@"timerRecordingProc");
    if (self.audioRecorder && [self.audioRecorder isRecording])
    {
        [self.audioRecorder updateMeters];
        //-160表示完全安静，0表示最大输入值
        float value = [self.audioRecorder averagePowerForChannel:0];
        if (self.updateCallback)
        {
            self.updateCallback(value);
        }
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.audioRecordTimer && [self.audioRecordTimer isValid])
    {
        [self.audioRecordTimer invalidate];
        self.audioRecordTimer = nil;
    }
    
    if (self.isRecording && !self.isCanceled)
    {
        // duration
        if (!self.isManualStopRecording)
        {
            self.recordTime = self.maxRecordDuration;
        }
        if (self.recordTime < ExRecorderMinRecordDuration)
        {
            [self showAlert:@"录音时间太短!"];
            return;
        }
        // convert amr file
        [self convertAmrAudioFile];
    }
    self.isRecording = NO;
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    [self stopRecord];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    [recorder stop];
    self.isRecording = NO;
    if ([self.audioRecordTimer isValid])
    {
        [self.audioRecordTimer invalidate];
    }
    self.audioRecordTimer = nil;
    if (self.failedCallback)
    {
        self.failedCallback();
    }
}

- (void) reset
{
    if ([self.audioRecordTimer isValid])
    {
        [self.audioRecordTimer invalidate];
    }
    self.audioRecordTimer = nil;
    if (self.audioRecorder.recording){[self.audioRecorder stop];}
    self.audioRecorder = nil;
    self.tmpAudioFilePath = nil;
    self.outputAudioFilePath = nil;
    self.successCallback = nil;
    self.failedCallback = nil;
    self.updateCallback = nil;
}

- (void) applicationDidResignActive: (NSNotification *) notiObj
{
    [self stopRecord];
}

- (void)showAlert:(NSString *)message
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:message viewController:appDelegate.window.rootViewController];
    RIButtonItem *okItme = [RIButtonItem itemWithLabel:@"确定"];
    [alert addButton:okItme type:RIButtonItemType_Other];
    [alert show];
}

- (NSTimeInterval)maxRecordDuration
{
    return [HDLocalDataManager getAudioRecordLength];
}

@end
