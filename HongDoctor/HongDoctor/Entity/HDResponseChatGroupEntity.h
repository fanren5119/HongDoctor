//
//  HDGroupInfoEntity.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDResponseChatGroupEntity : NSObject

@property (nonatomic, strong) NSString *msgUnReadCount;
@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupdName;
@property (nonatomic, strong) NSString *groupOwnerName;
@property (nonatomic, strong) NSString *groupOwnerId;
@property (nonatomic, strong) NSString *groupPost;
@property (nonatomic, strong) NSString *groupProperty;
@property (nonatomic, strong) NSString *groupMemberCount;
@property (nonatomic, strong) NSString *groupHeaderURl;
@property (nonatomic, strong) NSString *groupNewDate;
@property (nonatomic, strong) NSString *groupNewMessage;
@property (nonatomic, strong) NSString *groupMsgType;
@property (nonatomic, strong) NSString *msgProperty;
@property (nonatomic, strong) NSString *groupQRImageURL;


+ (HDResponseChatGroupEntity *)serializerEntityWithString:(NSString *)string;

@end
