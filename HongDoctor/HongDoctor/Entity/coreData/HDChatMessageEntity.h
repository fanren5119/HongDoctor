//
//  HDChatMessageEntity.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/15.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface HDChatMessageEntity : RLMObject

@property (nullable, nonatomic, copy) NSString *groupGuid;
@property (nullable, nonatomic, copy) NSString *messageContent;
@property (nullable, nonatomic, copy) NSString *messageDate;
@property (nullable, nonatomic, copy) NSString *messageGuid;
@property (nullable, nonatomic, copy) NSString *messageLength;
@property (nullable, nonatomic, copy) NSString *messageProperty;
@property (nullable, nonatomic, copy) NSString *messageType;
@property (nullable, nonatomic, copy) NSString *senderGuid;
@property (nullable, nonatomic, copy) NSString *senderHeadURL;
@property (nullable, nonatomic, copy) NSString *senderName;
@property (nonatomic, assign) NSInteger sendingType;

@end
