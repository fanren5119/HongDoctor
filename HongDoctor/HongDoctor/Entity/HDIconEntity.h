//
//  HDIconEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDIconEntity : NSObject

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *bageValue;

+ (NSArray *)serializerArrayWithString:(NSString *)string;

+ (NSString *)deserializerWithArray:(NSArray *)entityArray;

@end
