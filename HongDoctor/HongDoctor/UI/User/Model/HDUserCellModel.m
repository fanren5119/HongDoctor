//
//  HDUserCellModel.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserCellModel.h"

@implementation HDUserCellModel

+ (NSArray *)serializerWithArray:(NSArray *)dictArray
{
    NSMutableArray *entityArray = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        HDUserCellModel *entity = [self serilizerWithDict:dict];
        [entityArray addObject:entity];
    }
    return entityArray;
}

+ (HDUserCellModel *)serilizerWithDict:(NSDictionary *)dict
{
    HDUserCellModel *entity = [[HDUserCellModel alloc] init];
    entity.headImage = [dict objectForKey:@"headImage"];
    entity.title = [dict objectForKey:@"title"];
    entity.isShowLine = [[dict objectForKey:@"isShowLine"] boolValue];
    entity.isShowArrow = [[dict objectForKey:@"isShowArrow"] boolValue];
    entity.type = [[dict objectForKey:@"type"] integerValue];
    return entity;
}

@end
