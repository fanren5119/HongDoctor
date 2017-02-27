//
//  HDSessionEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDResponseChatMessageEntity.h"
#import <objc/runtime.h>
#import "HDDownloadAudioManager.h"
#import "HDDownloadImageManager.h"
#import "HDDownloadVideoManager.h"

#define  Separator          @"KHCLCHK"
#define  CountSeparator     @"KH666CLC666HK"

@implementation HDResponseChatMessageEntity

+ (NSArray *)serializerWithString:(NSString *)string
{
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *stringArray = [string componentsSeparatedByString:CountSeparator];
    NSMutableArray *entityArray = [NSMutableArray array];
    for (NSString *string in stringArray) {
        HDResponseChatMessageEntity *entity = [self serializerEntityWithString:string];
        if (entity != nil) {
            entity.sendingType = 2;
            [entityArray addObject:entity];
        }
    }
    return entityArray;
}

+ (HDResponseChatMessageEntity *)serializerEntityWithString:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    if (array == nil || array.count <= 0) {
        return nil;
    }
    HDResponseChatMessageEntity *entity = [[HDResponseChatMessageEntity alloc] init];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        const char *properName = property_getName(property);
        NSString *key = [[NSString alloc] initWithUTF8String:properName];
        if (array.count > i) {
            [entity setValue:array[i] forKey:key];
        }
    }
    NSInteger messageType = [entity.messageType integerValue];
    switch (messageType) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [[HDDownloadImageManager shareManager] addDownloadUrl:entity.messageContent];
            [[HDDownloadImageManager shareManager] addDownloadUrl:entity.messageLength];
        }
            break;
        case 2:
        {
            [[HDDownloadImageManager shareManager] addDownloadUrl:entity.messageContent];
            [[HDDownloadVideoManager shareManager] addDownloadUrl:entity.messageLength];
        }
            break;
        case 3:
        {
            [[HDDownloadAudioManager shareManager] addDownloadUrl:entity.messageContent];
        }
            break;
        case 4:
        {
            [[HDDownloadImageManager shareManager] addDownloadUrl:entity.messageContent];
        }
            break;
        default:
            break;
    }
    free(properties);
    return entity;
}

@end
