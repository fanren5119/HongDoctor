//
//  HDIconEntity.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDIconEntity.h"

@implementation HDIconEntity

+ (NSArray *)serializerArrayWithString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"KHCLCHK"];
    NSMutableArray *entityArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i += 2) {
        HDIconEntity *entity = [[HDIconEntity alloc] init];
        entity.urlString = array[i];
        if (array.count > i + 1) {
            entity.bageValue = array[i + 1];
        }
        [entityArray addObject:entity];
    }
    return entityArray;
}

+ (NSString *)deserializerWithArray:(NSArray *)entityArray
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < entityArray.count; i ++) {
        HDIconEntity *entity = entityArray[i];
        if (i != 0) {
            [string appendString:@"KHCLCHK"];
        }
        if (entity.urlString != nil) {
            [string appendString:entity.urlString];
            [string appendString:@"KHCLCHK"];
        }
        if (entity.bageValue != nil) {
            [string appendString:entity.bageValue];
        }
    }
    return string;
}



@end
