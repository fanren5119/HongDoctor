//
//  HDNotificationEntity.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDNotificationEntity : NSObject

@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *senderGuid;

+ (HDNotificationEntity *)serializerEntityWithString:(NSString *)string;

@end
