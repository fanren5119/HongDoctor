//
//  HDAudoServerManager.h
//  HongDoctor
//
//  Created by 王磊 on 2017/2/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDSendMessageEntity;
@class HDSendMsgResponseEntity;

@interface HDAutoServerManager : NSObject

+ (instancetype)shareManager;

- (void)autoLogin:(void (^) (BOOL succeed, NSString *message))completeBlock;

- (void)autoGetBeginData:(void (^) (BOOL succeed))completeBlock;

- (void)autoSendText:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock;

- (void)autoSendImage:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock;

- (void)autoSendAudio:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock;

- (void)autoSendVideo:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock;

- (void)autoSendLocation:(HDSendMessageEntity *)entity completeBlock:(void (^) (BOOL succeed, HDSendMsgResponseEntity *responseEntity))completeBlock;

@end
