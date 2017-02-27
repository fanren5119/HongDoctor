//
//  HDChatGroupEntity.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/15.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface HDChatGroupEntity : RLMObject

@property (nullable, nonatomic, copy) NSString *groupdName;
@property (nullable, nonatomic, copy) NSString *groupGuid;
@property (nullable, nonatomic, copy) NSString *groupHeaderURl;
@property (nullable, nonatomic, copy) NSString *groupMemberCount;
@property (nullable, nonatomic, copy) NSString *groupMsgType;
@property (nullable, nonatomic, copy) NSString *groupNewDate;
@property (nullable, nonatomic, copy) NSString *groupNewMessage;
@property (nullable, nonatomic, copy) NSString *groupOwnerId;
@property (nullable, nonatomic, copy) NSString *groupOwnerName;
@property (nullable, nonatomic, copy) NSString *groupPost;
@property (nullable, nonatomic, copy) NSString *groupProperty;
@property (nullable, nonatomic, copy) NSString *msgProperty;
@property (nullable, nonatomic, copy) NSString *msgUnReadCount;
@property (nullable, nonatomic, copy) NSString *groupQRImageURL;

@end
