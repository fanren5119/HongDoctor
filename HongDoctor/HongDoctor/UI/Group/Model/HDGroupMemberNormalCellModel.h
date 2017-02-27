//
//  HDGroupMemberNormalCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NormalCellType) {
    MemberCountCell         = 0,
    GroupOwnerCell          = 1,
    GroupNameCell           = 2,
    GroupPostCell           = 3,
    GroupSynchronize        = 4,
    GroupQRCell             = 5,
    GroupDiagnosisCell      = 6,
    GroupClearCell          = 7
};

@interface HDGroupMemberNormalCellModel : NSObject

@property (nonatomic, assign) NormalCellType    cellType;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, assign) BOOL              isCanSelect;
@property (nonatomic, assign) BOOL              isHideLine;

@end
