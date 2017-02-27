//
//  NSFileManager+BRAddition.h
//  YPCommon
//
//  Created by Ji Will on 12/18/12.
//  Copyright (c) 2012 iBrand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSFileManager (BRAddition)
+ (BOOL)dirExisted:(NSString *)path createIfNot:(BOOL)create;
+ (BOOL)fileExisted:(NSString *)path createIfNot:(BOOL)create;
+ (NSString *)pathWithBasePath:(NSString *)basePath relativePath:(NSString *)relativePath;

// Modify by Arthur
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
