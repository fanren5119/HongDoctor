//
//  HDUserCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserCellType) {
    UserHead            = 0,
    UserModifyPsw       = 1,
    UserSetting         = 2,
    UserFeedback        = 3,
    UserSynchContract   = 4
};

@interface HDUserCellModel : NSObject

@property (nonatomic, strong) NSString      *headImage;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, assign) BOOL          isShowLine;
@property (nonatomic, assign) BOOL          isShowArrow;
@property (nonatomic, assign) UserCellType  type;

+ (NSArray *)serializerWithArray:(NSArray *)dictArray;

@end
