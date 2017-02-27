//
//  HDSendMsgResponseEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/16.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDSendMsgResponseEntity.h"
#import <objc/runtime.h>

#define Separator @"KHCLCHK"

@implementation HDSendMsgResponseEntity

+ (HDSendMsgResponseEntity *)serializerWithString:(NSString *)string
{
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    
    HDSendMsgResponseEntity *entity = [[HDSendMsgResponseEntity alloc] init];
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

@end
