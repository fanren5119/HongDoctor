//
//  HDUserEntity.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUserEntity : NSObject

@property (nonatomic, strong) NSString *userHeadURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userGrade;
@property (nonatomic, strong) NSString *isOnLine;
@property (nonatomic, strong) NSString *userGuid;
@property (nonatomic, strong) NSString *userDepartment;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *orgguid;
@property (nonatomic, strong) NSString *orgid;
@property (nonatomic, strong) NSString *orgname;
@property (nonatomic, strong) NSString *isCompany;
@property (nonatomic, strong) NSString *qrImageURL;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *sorting;

+ (HDUserEntity *)serializerWithString:(NSString *)string;
- (NSString *)deserializer;

@end
