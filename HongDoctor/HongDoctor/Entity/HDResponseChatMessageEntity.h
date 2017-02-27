//
//  HDSessionEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDResponseChatMessageEntity : NSObject

@property (nonatomic, strong) NSString  *messageDate;
@property (nonatomic, strong) NSString  *senderGuid;
@property (nonatomic, strong) NSString  *senderName;
@property (nonatomic, strong) NSString  *senderHeadURL;
@property (nonatomic, strong) NSString  *messageContent;
@property (nonatomic, strong) NSString  *messageType;
@property (nonatomic, strong) NSString  *messageProperty;
@property (nonatomic, strong) NSString  *messageGuid;
@property (nonatomic, strong) NSString  *messageLength;
@property (nonatomic, assign) NSInteger sendingType;

+ (NSArray *)serializerWithString:(NSString *)string;

@end
