//
//  HDDownloadAudioManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/23.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDDownloadAudioManager.h"
#import "AFNetworking.h"
#import "GWEncodeHelper.h"
#import "TaskUtility.h"
#import "VoiceConverter.h"

static HDDownloadAudioManager *__manager = nil;

@interface HDDownloadAudioManager ()

@property (nonatomic, strong) NSMutableArray    *downloadURLArray;
@property (nonatomic, strong) NSTimer           *timer;

@end

@implementation HDDownloadAudioManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[HDDownloadAudioManager alloc] init];
    });
    return __manager;
}

- (void)addDownloadUrl:(NSString *)url
{
    [self.downloadURLArray addObject:url];
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
    }
}

- (void)respondsToTimer
{
    if (self.downloadURLArray.count <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    NSString *firstURL = self.downloadURLArray[0];
    [self.downloadURLArray removeObjectAtIndex:0];
    [self uploadAudioWithURL:firstURL completeBlock:^(NSString *path) {
        
    }];
}

- (void)uploadAudioWithURL:(NSString *)url completeBlock:(void (^) (NSString *path))completeBlock
{
    NSString *audioName = [GWEncodeHelper md5:url];
    NSString *localPath = [TaskUtility pathForAttachmentAudioFile:[NSString stringWithFormat:@"%@.amr", audioName]];
    NSString *pathForWav = [TaskUtility pathForAttachmentAudioFile:[NSString stringWithFormat:@"%@.wav", audioName]];

    if ([NSFileManager fileExisted:pathForWav createIfNot:NO]) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream", nil];
    manager.responseSerializer = serializer;
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData * responseObject) {
        [responseObject writeToFile:localPath atomically:YES];
        [VoiceConverter amrToWav:localPath wavSavePath:pathForWav];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (NSMutableArray *)downloadURLArray
{
    if (_downloadURLArray == nil) {
        _downloadURLArray = [NSMutableArray array];
    }
    return _downloadURLArray;
}

@end
