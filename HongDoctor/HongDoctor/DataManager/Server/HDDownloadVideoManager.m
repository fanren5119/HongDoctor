//
//  HDDownloadVideoManager.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDDownloadVideoManager.h"
#import "AFNetworking.h"
#import "GWEncodeHelper.h"
#import "TaskUtility.h"
#import "VoiceConverter.h"
#import "ZipArchive.h"

#define  TimerInterval      2

static HDDownloadVideoManager *__manager = nil;

@interface HDDownloadVideoManager ()

@property (nonatomic, strong) NSMutableArray    *downloadURLArray;
@property (nonatomic, strong) NSTimer           *timer;

@end


@implementation HDDownloadVideoManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[HDDownloadVideoManager alloc] init];
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
    [self uploadVideoWithURL:firstURL completeBlock:^(BOOL succeed, NSString *path) {
        
    }];
}

- (void)uploadVideoWithURL:(NSString *)url completeBlock:(void (^) (BOOL succeed, NSString *path))completeBlock
{
    NSString *videoName = [GWEncodeHelper md5:url];
    NSString *localPath = [TaskUtility pathForAttachmentVideoFile:[NSString stringWithFormat:@"%@.mp4", videoName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream", @"video/mp4", nil];
    manager.responseSerializer = serializer;
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData * responseObject) {
        
        [responseObject writeToFile:localPath atomically:YES];
        completeBlock(YES, localPath);
//        NSString *zipPath = [TaskUtility pathForAttachmentVideoFile:[NSString stringWithFormat:@"%@.zip", videoName]];
//        NSString *unzipPath = [TaskUtility pathForAttachmentVideoFile:[NSString stringWithFormat:@"%@", videoName]];
//        ZipArchive* zip = [[ZipArchive alloc] init];
//        if( [zip UnzipOpenFile:zipPath] )
//        {
//            BOOL ret = [zip UnzipFileTo:localPath overWrite:NO];
//            if( NO==ret )
//            {
//            } else {
//                
//            }
//            [zip UnzipCloseFile];
//        }
//        
//        BOOL isDirectory;
//        [[NSFileManager defaultManager] fileExistsAtPath:unzipPath isDirectory:&isDirectory];
//        if (isDirectory == YES) {
//            NSLog(@"==文件夹");
//        } else {
//            NSLog(@"===文件");
//        }
//        [responseObject writeToFile:localPath atomically:YES];
//        [VoiceConverter amrToWav:localPath wavSavePath:pathForWav];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(NO, nil);
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
