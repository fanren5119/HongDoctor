//
//  HDContractBaseEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/2/21.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ContractCellType) {
    DepartmentCell      = 0,
    ContractCell        = 1
};

@interface HDContractBaseEntity : NSObject

@property (nonatomic, assign) ContractCellType  cellType;
@property (nonatomic, strong) NSString          *organization;
@property (nonatomic, strong) NSString          *parentOrganization;
@property (nonatomic, assign) NSInteger         isSelect;
@property (nonatomic, assign) NSInteger         layerGrade;

@end
