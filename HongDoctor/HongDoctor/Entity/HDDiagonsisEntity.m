//
//  HDDiagonsisEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDDiagonsisEntity.h"
#import "HDDiagonsisBottomEntity.h"

#define  ClassSeparator      @"KHSEP3CLCSEP3HK"
#define  Separator           @"KHCLCHK"

@implementation HDDiagonsisEntity

+ (HDDiagonsisEntity *)serializerEntityWithString:(NSString *)string
{
    if (string.length <= 0 && [string isEqualToString:@"error"] && [string isEqualToString:@"nomsg"]) {
        return nil;
    }
    NSArray *array = [string componentsSeparatedByString:ClassSeparator];
    HDDiagonsisEntity *entity = [[HDDiagonsisEntity alloc] init];

    if (array.count > 0) {
        NSArray *array2 = [array[0] componentsSeparatedByString:Separator];
        if (array2.count > 0) {
            entity.title = array2[0];
        }
        if (array2.count > 1) {
            entity.url = array2[1];
        }
    }
    
    if (array.count > 1) {
        entity.bottomArray = [HDDiagonsisBottomEntity serializerWithString:array[1]];
    }
    
    return entity;
}

@end
