//
//  HDImageManager.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDImageManager : NSObject

+ (NSString *)saveImageWithData:(NSData *)data;
+ (void)deleImageWithName:(NSString *)name;
+ (NSString *)imageNameWithData:(NSData *)data;
+ (UIImage *)getImageWithName:(NSString *)name;

@end
