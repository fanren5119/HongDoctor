//
//  HDSendMessageEntity.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDSendMessageEntity.h"
#import <objc/runtime.h>

#define  Separator  @"=KHHCLHK="

@implementation HDSendMessageEntity

- (NSString *)deserializer
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"1004"];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count - 5; i ++) {
        objc_property_t property = properties[i];
        const char *properName = property_getName(property);
        NSString *key = [[NSString alloc] initWithUTF8String:properName];
        NSString *value = [self valueForKey:key];
        
        [string appendString:Separator];
        value = value ? value : @"";
        [string appendString:value];
    }
    free(properties);
    
    return string;
}

@end
