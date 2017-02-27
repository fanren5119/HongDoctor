//
//  HDModifyGroupEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ModifyGroupType) {
    ModifyGroupNone     = 0,
    ModifyGroupName     = 1,
    ModifyGroupPost     = 2
};

@interface HDModifyGroupEntity : NSObject

@property (nonatomic, strong) NSString *userGuid;
@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupPost;
@property (nonatomic, assign) ModifyGroupType type;

- (NSString *)deserializer;

@end
