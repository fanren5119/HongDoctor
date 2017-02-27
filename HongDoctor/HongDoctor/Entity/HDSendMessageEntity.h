//
//  HDSendMessageEntity.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/11.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDSendMessageEntity : NSObject

@property (nonatomic, strong) NSString *userGuid; //用户 GUID
@property (nonatomic, strong) NSString *groupGuid; //群 GUID
@property (nonatomic, strong) NSString *gtype; //群属性
@property (nonatomic, strong) NSString *bodytype; //消息体类型
@property (nonatomic, strong) NSString *mtype; //消息属性
@property (nonatomic, strong) NSString *length;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *messageGuid;
@property (nonatomic, assign) NSInteger sendType;
@property (nonatomic, strong) NSString *messageDate;

- (NSString *)deserializer;

@end
