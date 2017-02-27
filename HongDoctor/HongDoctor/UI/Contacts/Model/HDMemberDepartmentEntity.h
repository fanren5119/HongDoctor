//
//  HDMemberDepartmentEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDContractBaseEntity.h"

@interface HDMemberDepartmentEntity : HDContractBaseEntity

@property (nonatomic, strong) NSString          *sort;
@property (nonatomic, strong) NSString          *departmentName;
@property (nonatomic, assign) BOOL              isSelect;

@end
