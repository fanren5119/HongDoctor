//
//  HDStartManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDStartManager.h"
#import "HDHttpManager.h"
#import "HDStartEntity.h"

@implementation HDStartManager

+ (void)requsetToStart:(void (^) (HDStartEntity *entity, BOOL successed))completeBlock
{
    NSString *urlString = @"/17Intell/mobileweb/postFile.jsp?type=901";
    urlString = [HDbaseURL stringByAppendingString:urlString];
    [HDHttpManager GET:urlString success:^(NSString *string) {
        HDStartEntity *entity = [HDStartEntity serializerWithString:string];
        completeBlock(entity, YES);
    } fail:^(NSString *message) {
        completeBlock(nil, NO);
    }];
}

@end
