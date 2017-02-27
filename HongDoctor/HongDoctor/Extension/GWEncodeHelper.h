//
//  EncodeOperation.h
//  ShenYun
//
//  15/7/15.
//  Copyright (c) 2015年 ShenYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWEncodeHelper : NSObject

// 将json格式的数据经base64编码并返回编码后的字符串类型
+ (NSString *)base64EncodeWithJsonObject:(id)object;
//SHA1 加密
+ (NSString *)sha1:(NSString *)inputStr;
//MD5
+ (NSString *)md5:(NSString *)inPutText;

+ (NSString *)dataMd5:(NSData *)data;
@end
