//
//  HDStartEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDStartEntity : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *showInterval;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *failURL;
@property (nonatomic, strong) NSString *registerURL;
@property (nonatomic, strong) NSString *findPasswordURL;

+ (HDStartEntity *)serializerWithString:(NSString *)string;

@end
