//
//  HDDiagonsisEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDiagonsisEntity : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray  *bottomArray;

+ (HDDiagonsisEntity *)serializerEntityWithString:(NSString *)string;

@end
