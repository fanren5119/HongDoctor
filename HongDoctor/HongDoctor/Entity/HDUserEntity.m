//
//  HDUserEntity.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserEntity.h"
#import <objc/runtime.h>

#define Separator @"KHCLCHK"

@implementation HDUserEntity

+ (HDUserEntity *)serializerWithString:(NSString *)string
{
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    
    HDUserEntity *entity = [[HDUserEntity alloc] init];
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
    return entity;

    return [[HDUserEntity alloc] init];
}

- (NSString *)deserializer
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        const char *properName = property_getName(property);
        NSString *key = [[NSString alloc] initWithUTF8String:properName];
        NSString *value = [self valueForKey:key];
        if (i != 0) {
            [string appendString:Separator];
        }
        value = value ? value : @" ";
        [string appendString:value];
    }
    free(properties);
    
    return string;
}


@end
