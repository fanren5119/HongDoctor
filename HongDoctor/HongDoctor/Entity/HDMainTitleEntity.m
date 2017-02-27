//
//  HDMainTitleEntity.m
//  HongDoctor
//
//  Created by wanglei on 2017/2/25.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDMainTitleEntity.h"
#import <objc/runtime.h>

#define  Separator @"KHCLCHK"
#define CountSeparator @"KH666CLC666HK"

@implementation HDMainTitleEntity

+ (NSArray *)serializerWithString:(NSString *)string
{
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *stringArray = [string componentsSeparatedByString:CountSeparator];
    NSMutableArray *entityArray = [NSMutableArray array];
    for (NSString *string in stringArray) {
        HDMainTitleEntity *entity = [self serializerEntityWithString:string];
        if (entity != nil) {
            [entityArray addObject:entity];
        }
    }
    return entityArray;
}

+ (HDMainTitleEntity *)serializerEntityWithString:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    if (array == nil || array.count <= 0) {
        return nil;
    }
    HDMainTitleEntity *entity = [[HDMainTitleEntity alloc] init];
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
    if (entity.imageURL != nil) {
        [[HDDownloadImageManager shareManager] addDownloadUrl:entity.imageURL];
    }
    return entity;
}

@end
