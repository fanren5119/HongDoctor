//
//  HDStartEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDStartEntity.h"
#import <objc/runtime.h>

static NSString * const Separator = @"KHCLCHK";

@implementation HDStartEntity

+ (HDStartEntity *)serializerWithString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:Separator];
    
    HDStartEntity *entity = [[HDStartEntity alloc] init];
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
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"imageURL:%@, title:%@, showTime:%@, failURL:%@", self.imageURL, self.title, self.showInterval, self.failURL];
}

@end
