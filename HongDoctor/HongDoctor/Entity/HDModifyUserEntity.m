
//
//  HDModifyUserEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDModifyUserEntity.h"
#import <objc/runtime.h>

#define  Separator  @"=KHHCLHK="

@implementation HDModifyUserEntity

- (NSString *)deserializer
{
//    NSMutableString *string = [[NSMutableString alloc] initWithString:@"1022"];
//    u_int count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    for (int i = 0; i < count - 1; i ++) {
//        objc_property_t property = properties[i];
//        const char *properName = property_getName(property);
//        NSString *key = [[NSString alloc] initWithUTF8String:properName];
//        NSString *value = [self valueForKey:key];
//        
//        [string appendString:Separator];
//        value = value ? value : @" ";
//        [string appendString:value];
//    }
//    free(properties);
    
    NSString *string = [NSString stringWithFormat:@"1022=KHHCLHK=%@=KHHCLHK=%d=KHHCLHK=", self.userGuid, self.type];
    switch (self.type) {
        case ModifyHead:
            return [string stringByAppendingString:@"nomsg"];
            break;
        case ModifyPsw:
            return [string stringByAppendingString:self.password];
            break;
        case ModifyName:
            return [string stringByAppendingString:self.userName];
            break;
        case ModifySex:
            return [string stringByAppendingString:self.sex];
            break;
        case ModifyPhone:
            return [string stringByAppendingString:self.phone];
            break;
        default:
            break;
    }
}

@end
