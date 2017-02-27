//
//  HDMemberEntity.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/15.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Realm/Realm.h>
#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, MemberType) {
    LocalMember     = 0,
    RemoteMember    = 1,
    NoLocalMember   = 2
};

@interface HDMemberEntity : RLMObject

@property (nullable, nonatomic, copy) NSString *isCompany;
@property (nullable, nonatomic, copy) NSString *isOnLine;
@property (nullable, nonatomic, copy) NSString *orgguid;
@property (nullable, nonatomic, copy) NSString *orgid;
@property (nullable, nonatomic, copy) NSString *orgname;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *userDepartment;
@property (nullable, nonatomic, copy) NSString *userGrade;
@property (nullable, nonatomic, copy) NSString *userGuid;
@property (nullable, nonatomic, copy) NSString *userHeadURL;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *qrImageURL;
@property (nullable, nonatomic, copy) NSString *number;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *organization;
@property (nullable, nonatomic, copy) NSString *sorting;
@property (nonatomic, assign) MemberType        type;

@end
