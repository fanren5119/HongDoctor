//
//  HDGroupInfoEntity.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDResponseChatGroupEntity.h"
#import <objc/runtime.h>
#import "HDResponseMemberEntity.h"
#import "HDResponseChatMessageEntity.h"

#define  Separator @"KHCLCHK"
#define CountSeparator @"KH666CLC666HK"

@implementation HDResponseChatGroupEntity

+ (HDResponseChatGroupEntity *)serializerEntityWithString:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    if ([string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:Separator];
    HDResponseChatGroupEntity *entity = [[HDResponseChatGroupEntity alloc] init];
    if (array == nil || array.count <= 0) {
        return entity;
    }
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        const char *properName = property_getName(property);
        NSString *key = [[NSString alloc] initWithUTF8String:properName];
        NSString *name = getPropertyType(property);
        Class class = NSClassFromString(name);
        if (array.count <= i) {
            break;
        }
        if ([class isSubclassOfClass:[NSObject class]]) {
            
            if ([name isEqualToString:@"NSString"]) {
                [entity setValue:array[i] forKey:key];
            } else {
                continue;
            }
            
        } else {
            
        }
    }
    free(properties);
    return entity;
}

static NSString *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return name;
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return @"id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return name;
        }
    }
    return @"";
}


@end
