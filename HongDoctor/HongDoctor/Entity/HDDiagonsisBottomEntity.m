//
//  HDDiagonsisBottomEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDDiagonsisBottomEntity.h"
#import <objc/runtime.h>

#define  CountSeparator     @"KH666CLC666HK"
#define  Separator          @"KHCLCHK"

@implementation HDDiagonsisBottomEntity

+ (NSArray *)serializerWithString:(NSString *)string
{
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *stringArray = [string componentsSeparatedByString:CountSeparator];
    NSMutableArray *entityArray = [NSMutableArray array];
    for (NSString *string in stringArray) {
        HDDiagonsisBottomEntity *entity = [self serializerEntityWithString:string];
        if (entity != nil) {
            [entityArray addObject:entity];
        }
    }
    return entityArray;
}

+ (HDDiagonsisBottomEntity *)serializerEntityWithString:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    if (array == nil || array.count <= 0) {
        return nil;
    }
    HDDiagonsisBottomEntity *entity = [[HDDiagonsisBottomEntity alloc] init];
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
    [[HDDownloadImageManager shareManager] addDownloadUrl:entity.imageURL];
    [[HDDownloadImageManager shareManager] addDownloadUrl:entity.selectImageURL];
    free(properties);
    return entity;
}


@end
