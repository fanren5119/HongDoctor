//
//  HDContactsEntity.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDResponseMemberEntity.h"
#import <objc/runtime.h>

#define CountSeparator @"KH666CLC666HK"
#define Separator @"KHCLCHK"

@implementation HDResponseMemberEntity

+ (NSArray *)serializerWithString:(NSString *)string
{
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *stringArray = [string componentsSeparatedByString:CountSeparator];
    NSMutableArray *entityArray = [NSMutableArray array];
    for (NSString *string in stringArray) {
        HDResponseMemberEntity *entity = [self serializerEntityWithString:string];
        if (entity != nil) {
            [entityArray addObject:entity];
        }
    }
    return entityArray;
}

+ (HDResponseMemberEntity *)serializerEntityWithString:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    HDResponseMemberEntity *entity = [[HDResponseMemberEntity alloc] init];
    if (array == nil || array.count <= 0) {
        return entity;
    }
    
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
    free(properties);
    if (entity.userHeadURL != nil) {
        [[HDDownloadImageManager shareManager] addDownloadUrl:entity.userHeadURL];
    }
    if (entity.qrImageURL != nil) {
        [[HDDownloadImageManager shareManager] addDownloadUrl:entity.qrImageURL];
    }
    return entity;
}

@end
