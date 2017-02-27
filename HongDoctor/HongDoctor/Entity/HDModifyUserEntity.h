//
//  HDModifyUserEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ModifyType) {
    ModifyHead  = 0,
    ModifyPsw   = 1,
    ModifyName  = 2,
    ModifySex   = 3,
    ModifyPhone = 4,
};

@interface HDModifyUserEntity : NSObject

@property (nonatomic, strong) NSString *userGuid;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, assign) ModifyType type;
@property (nonatomic, strong) NSString *headImageURL;

- (NSString *)deserializer;

@end
