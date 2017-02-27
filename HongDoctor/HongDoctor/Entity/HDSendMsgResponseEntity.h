//
//  HDSendMsgResponseEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/16.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDSendMsgResponseEntity : NSObject

@property (nonatomic, strong) NSString *msgGuid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *length;
@property (nonatomic, strong) NSString *sendDate;

+ (HDSendMsgResponseEntity *)serializerWithString:(NSString *)string;

@end
