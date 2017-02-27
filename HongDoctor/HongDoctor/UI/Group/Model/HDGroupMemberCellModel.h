//
//  HDGroupMemberCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellModelType) {
    NormalMemberCell    = 0,
    AddMemberCell       = 1,
    EmptyCell           = 2
};

@interface HDGroupMemberCellModel : NSObject

@property (nonatomic, strong) NSString      *memberId;
@property (nonatomic, strong) NSString      *memberName;
@property (nonatomic, strong) NSString      *memberHeadURL;
@property (nonatomic, assign) CellModelType type;
@property (nonatomic, assign) BOOL          isCompany;

@end
