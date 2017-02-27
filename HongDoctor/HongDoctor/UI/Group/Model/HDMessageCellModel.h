//
//  HDMessageModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageCellType) {
    MessageText     = 0,
    MessageImage    = 1,
    MessageVideo    = 2,
    MessageAudio    = 3,
    MessageLocation = 4
};

typedef NS_ENUM(NSInteger, SendType) {
    MessageSending      = 0,
    MessageSendFailed   = 1,
    MessageSendSuccess  = 2
};

@class HDChatMessageEntity;

@interface HDMessageCellModel : NSObject

@property (nonatomic, assign) MessageCellType   type;
@property (nonatomic, assign) BOOL              isUserSend;
@property (nonatomic, strong) NSString          *senderHeadURL;
@property (nonatomic, strong) NSString          *messageGuid;
@property (nonatomic, assign) SendType          sendType;
@property (nonatomic, strong) NSString          *messageTime;
@property (nonatomic, assign) BOOL              isCompany;
@property (nonatomic, strong) NSString          *senderName;
@property (nonatomic, strong) NSString          *senderGuid;

+ (instancetype)cellModelWithEntity:(HDChatMessageEntity *)entity;

@end
