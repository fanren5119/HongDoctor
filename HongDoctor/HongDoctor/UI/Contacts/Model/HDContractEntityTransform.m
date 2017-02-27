//
//  HDContractEntityTransform.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContractEntityTransform.h"
#import "HDMemberEntity.h"
#import "HDMemberDepartmentEntity.h"
#import "HDContractEntity.h"
#import "NSString+HDString.h"

@implementation HDContractEntityTransform

+ (NSArray *)shallowSortDepartments:(NSArray *)departmentArray
{
    return [departmentArray sortedArrayUsingComparator:^NSComparisonResult(HDMemberDepartmentEntity *obj1, HDMemberDepartmentEntity *obj2) {
        return [obj1.sort compare:obj2.sort];
    }];
}

+ (void)transforLocalMembers:(RLMResults *)membersArray completeBlock:(void (^) (NSArray *departments, NSDictionary *contentDict))completeBlock
{
    NSMutableArray *departmentArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < membersArray.count; i ++) {
        HDMemberEntity *member = (HDMemberEntity *)[membersArray objectAtIndex:i];
        NSArray *organizations = [member.organization componentsSeparatedByString:@"-"];
        NSArray *sorts = [member.sorting componentsSeparatedByString:@"-"];
        if (organizations.count <= 0) {
            continue;
        }
        for (int i = 0; i < organizations.count; i ++) {
            HDMemberDepartmentEntity *entity = [[HDMemberDepartmentEntity alloc] init];
            NSArray *organizationArr = [organizations subarrayWithRange:NSMakeRange(0, i+1)];
            entity.organization = [organizationArr componentsJoinedByString:@"-"];
            entity.cellType = DepartmentCell;
            entity.departmentName = [organizationArr lastObject];
            entity.layerGrade = organizationArr.count;
            
            if (sorts.count > i) {
                NSArray *sortArr = [sorts subarrayWithRange:NSMakeRange(0, i + 1)];
                entity.sort = [sortArr lastObject];
            }
            
            if (organizationArr.count > 1) {
                NSArray *newArray = [organizationArr subarrayWithRange:NSMakeRange(0, organizationArr.count - 1)];
                entity.parentOrganization = [newArray componentsJoinedByString:@"-"];
            }
            
            BOOL isContain = NO;
            for (HDMemberDepartmentEntity *department in departmentArray) {
                if ([department.organization isEqualToString:entity.organization]) {
                    isContain = YES;
                    break;
                }
            }
            if (isContain == NO) {
                [departmentArray addObject:entity];
            }
        }
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < membersArray.count; i ++) {
        HDMemberEntity *member = (HDMemberEntity *)[membersArray objectAtIndex:i];
        NSMutableArray *members = [dictionary objectForKey:member.organization];
        if (members == nil) {
            members = [NSMutableArray array];
            [dictionary setObject:members forKey:member.organization];
        }
        NSLog(@"===%@", member.userGrade);
        HDContractEntity *entity = [[HDContractEntity alloc] init];
        entity.parentOrganization = member.organization;
        entity.cellType = ContractCell;
        entity.headImageURL = member.userHeadURL;
        entity.contractId = member.userGuid;
        entity.name = member.nickname;
        entity.isSelect = NO;
        entity.isSign = NO;
        entity.grade = member.userGrade;
        [members addObject:entity];
    }
    NSArray *departments = [self shallowSortDepartments:departmentArray];
    completeBlock(departments, dictionary);
}

+ (void)transforRemoteMembers:(RLMResults *)membersArray completeBlock:(void (^) (NSArray *departments, NSDictionary *contentDict))completeBlock
{
    [self transforLocalMembers:membersArray completeBlock:completeBlock];
}

@end
