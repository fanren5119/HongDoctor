//
//  HDDiagonsisBottomEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDiagonsisBottomEntity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *selectImageURL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *remark;

+ (NSArray *)serializerWithString:(NSString *)string;

@end
