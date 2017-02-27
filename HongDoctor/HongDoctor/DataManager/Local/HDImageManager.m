//
//  HDImageManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDImageManager.h"
#import "GWEncodeHelper.h"

@implementation HDImageManager

+ (NSString *)imagePathWithName:(NSString *)name
{
    NSString *directory = [self imageDirectoryPath];
    return [directory stringByAppendingPathComponent:name];
}

+ (NSString *)imageDirectoryPath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
    BOOL isDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)saveImageWithData:(NSData *)data
{
    NSString *imageName = [self imageNameWithData:data];
    NSString *path = [self imagePathWithName:imageName];
    NSURL *url = [NSURL fileURLWithPath:path];
    BOOL success = [data writeToURL:url atomically:YES];
    if (success) {
        NSLog(@"success");
    }
    return imageName;
}

+ (UIImage *)getImageWithName:(NSString *)name
{
    NSString *path = [self imagePathWithName:name];
    return [[UIImage alloc] initWithContentsOfFile:path];
}


+ (NSString *)imageNameWithData:(NSData *)data
{
    if (data != nil) {
        return [GWEncodeHelper dataMd5:data];
    }
    return  @"";
}

+ (void)deleImageWithName:(NSString *)name
{
    NSString *path = [self imagePathWithName:name];
    NSURL *url = [NSURL fileURLWithPath:path];
    dispatch_queue_t queue = dispatch_queue_create("deleteImage", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    });
}

@end
