//
//  NSFileManager+BRAddition.m
//  YPCommon
//
//  Created by Ji Will on 12/18/12.
//  Copyright (c) 2012 iBrand. All rights reserved.
//

#import "NSFileManager+BRAddition.h"
//#import "NSString+BCAddition.h"
#import <sys/xattr.h>

@implementation NSFileManager (BRAddition)
+ (BOOL)dirExisted:(NSString *)path createIfNot:(BOOL)create
{
    BOOL ret = NO;
    if (path.length <= 0) {
        return ret;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
        if (isDir) {
            ret = YES;
        }
    }
    
    if (!ret && create) {
        if ([fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            ret = YES;
        }
    }
    return ret;
}

+ (BOOL)fileExisted:(NSString *)path createIfNot:(BOOL)create
{
    BOOL ret = NO;
    if (path.length <= 0) {
        return ret;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) {
            ret = YES;
        }
    }
    
    if (!ret && create) {
        if ([fm createFileAtPath:path contents:nil attributes:nil]) {
            ret = YES;
        }
    }
    return ret;
}



+ (NSString *)pathWithBasePath:(NSString *)basePath relativePath:(NSString *)relativePath
{
    NSString *trimedBasePath = [basePath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    NSString *ret = [trimedBasePath stringByAppendingPathComponent:relativePath];
    return ret;
}

// Modify by Arthur
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
        {
            NSError *error = nil;
            BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                          forKey: NSURLIsExcludedFromBackupKey error: &error];
            if(!success){
                NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
            }
            return success;
        } else {
            return NO;
        }
        
    } else {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
//        const char* filePath = [[URL path] fileSystemRepresentation];
//        
//        const char* attrName = "com.apple.MobileBackup";
//        u_int8_t attrValue = 1;
        
//        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//        return result == 0;
        return YES;
    }
}

@end
