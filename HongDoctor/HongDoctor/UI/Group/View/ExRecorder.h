//
//  ExRecorder.h
//  ExOffice
//
//  Created by MingbaoZhu on 14-3-20.
//  Copyright (c) 2014年 yipinapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^ExRecorderRecordSuccessCallback)(NSString *filePath, CGFloat duration);
typedef void (^ExRecorderRecordFailedCallback)(void);
typedef void (^ExRecorderRecordCancelCallback)(void);

typedef void (^ExRecorderRecordWillStopCallback)(void);

typedef void (^ExRecorderRecordUpdateCallback)(CGFloat power);

@interface ExRecorder : NSObject

+ (instancetype) recorder;

@property (nonatomic, copy) NSString *outputAudioFilePath;
@property (nonatomic, copy) NSString *tmpAudioFilePath;

- (void) registerSuccessCallback: (ExRecorderRecordSuccessCallback) success
                  failedCallback: (ExRecorderRecordFailedCallback) failed
                  updateCallback: (ExRecorderRecordUpdateCallback) update
                willStopCallback: (ExRecorderRecordWillStopCallback) willStop;

- (void)startRecord;

- (void)stopRecord;

- (void)cancelRecord;
@end
