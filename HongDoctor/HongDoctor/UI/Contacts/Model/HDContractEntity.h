//
//  HDContractModel.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDContractBaseEntity.h"

@interface HDContractEntity : HDContractBaseEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headImageURL;
@property (nonatomic, strong) NSString *contractId;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, assign) BOOL     isSign;

@end
