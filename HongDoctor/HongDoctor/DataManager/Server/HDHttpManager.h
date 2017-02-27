//
//  HDHttpManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDStartEntity;
@class HDSendMessageEntity;

typedef void (^successBolck) (NSString *string);
typedef void (^failBolck) (NSString *message);

@interface HDHttpManager : NSObject

+ (void)GET:(NSString *)urlString success:(successBolck)success fail:(failBolck)fail;

+ (void)POST:(NSString *)urlString parameters:(NSString *)parameters success:(successBolck)success fail:(failBolck)fail;

+ (void)uploadMessage:(NSString *)urlString parameters:(NSString *)parameter data:(NSData *)data filename:(NSString *)filename success:(successBolck)success fail:(failBolck)fail isFile:(BOOL)isFile;

+ (void)uploadMessage:(NSString *)urlString parameters:(NSString *)parameter text:(NSString *)text images:(NSArray *)images success:(successBolck)success fail:(failBolck)fail;

@end
