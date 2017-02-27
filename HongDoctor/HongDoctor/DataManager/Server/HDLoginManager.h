//
//  HDLoginManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLoginManager : NSObject

+ (void)requestWithPhone:(NSString *)phone getLoginHead:(void (^) (NSString *headURL, BOOL succeed))completeBlock;

+ (void)requestLoginWithPhone:(NSString *)phone password:(NSString *)password completeBlock:(void(^) (BOOL succeed, NSString *message))completeBlock;

+ (void)requestGetBeginData:(NSString *)userGuid completeBlock:(void (^) (BOOL success, NSString *message))completeBlock;

+ (void)requestGetIntervalBeginData:(NSString *)userGuid completeBlock:(void (^) (BOOL succeed, NSArray *iconsArray))completeBlock;


@end
