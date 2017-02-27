//
//  HDContractEntityTransform.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface HDContractEntityTransform : NSObject

+ (void)transforLocalMembers:(RLMResults *)membersArray completeBlock:(void (^) (NSArray *departments, NSDictionary *contentDict))completeBlock;

+ (void)transforRemoteMembers:(RLMResults *)membersArray completeBlock:(void (^) (NSArray *departments, NSDictionary *contentDict))completeBlock;


@end
