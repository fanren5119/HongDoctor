//
//  HDMainTitleEntity.h
//  HongDoctor
//
//  Created by wanglei on 2017/2/25.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDMainTitleEntity : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *isRransferNative;
@property (nonatomic, strong) NSString *nativeFunc;

+ (NSArray *)serializerWithString:(NSString *)string;

@end
