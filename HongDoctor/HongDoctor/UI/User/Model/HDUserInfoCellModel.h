//
//  HDUserInfoCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserInfoCellType) {
    UserInfoHeadCell        = 0,
    UserInfoNickNameCell    = 1,
    UserInfoTrueNameCell    = 2,
    UserInfoNumberCell      = 3,
    UserInfoQRCode          = 4,
    UserInfoSexCell         = 5,
    UserInfoGradeCell       = 6,
    UserInfoPhoneCell       = 7,
    UserInfoCompanyCell     = 8
};

@interface HDUserInfoCellModel : NSObject

@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, assign) UserInfoCellType  cellType;

@end
