//
//  HDContractDepartmentCell.m
//  HongDoctor
//
//  Created by 王磊 on 2017/2/21.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDContractDepartmentCell.h"
#import "HDMemberDepartmentEntity.h"

@interface HDContractDepartmentCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;


@end

@implementation HDContractDepartmentCell

- (void)resetCellWithEntity:(HDContractBaseEntity *)entity
{
    HDMemberDepartmentEntity *cellEntity = (HDMemberDepartmentEntity *)entity;
    NSString *name = cellEntity.departmentName;
    if ([name isEqualToString:@"null"]) {
        self.titleLabel.text = @"其他";
    } else {
        self.titleLabel.text = cellEntity.departmentName;
    }
    if (cellEntity.isSelect) {
        self.signImageView.image = [UIImage imageNamed:@"Con_arrow_up"];
    } else {
        self.signImageView.image = [UIImage imageNamed:@"Con_arrow_down"];
    }
    self.leftConstraint.constant = 15 * cellEntity.layerGrade;
}


@end
