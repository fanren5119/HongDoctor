//
//  HDLocationCellEntity.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLocationCellEntity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) double   latitude;
@property (nonatomic, assign) double   longitude;
@property (nonatomic, assign) BOOL     isSelect;

@end
