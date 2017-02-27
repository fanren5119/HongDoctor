//
//  HDMainHeaderEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/10.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDMainHeaderEntity : NSObject

@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *accessURL;
@property (nonatomic, strong) NSString *title;

+ (NSArray *)serializerWithString:(NSString *)string;

@end
