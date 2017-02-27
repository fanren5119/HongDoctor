//
//  HDModifyGroupEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDModifyGroupEntity.h"
#import <objc/runtime.h>

#define  Separator  @"=KHHCLHK="

@implementation HDModifyGroupEntity

- (NSString *)deserializer
{
    NSString *string = [NSString stringWithFormat:@"1022=KHHCLHK=%@=KHHCLHK=5=KHHCLHK=%@=KHHCLHK=%ld=KHHCLHK=", self.userGuid, self.groupGuid, (long)self.type];
    
    switch (self.type) {
        case ModifyGroupNone:
            break;
        case ModifyGroupName:
            string = [string stringByAppendingString:self.groupName];
            break;
        case ModifyGroupPost:
            string = [string stringByAppendingString:self.groupPost];
            break;
        default:
            break;
    }
    return string;
}

@end
