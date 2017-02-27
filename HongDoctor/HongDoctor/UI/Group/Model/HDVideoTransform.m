//
//  HDVideoTransform.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/27.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDVideoTransform.h"
#import <AVFoundation/AVFoundation.h>

@implementation HDVideoTransform

+ (void)tranformMov:(NSURL *)movPath toMp4:(NSString *)mp4Path completeBlock:(void (^) (BOOL succeed))completeBlock
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movPath options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:mp4Path];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    break;
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusCompleted:
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                    break;
                default:
                    break;
            }
        }];
    }
}

@end
