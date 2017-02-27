//
//  EncodeOperation.m
//  ShenYun
//
//  15/7/15.
//  Copyright (c) 2015年 ShenYun. All rights reserved.
//

#import "GWEncodeHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GWEncodeHelper

// base64编码
+ (NSString *)base64EncodeWithJsonObject:(id)object
{
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    else {
        NSString *encodeString = [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
//        NSString*bStr =CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                 (CFStringRef)encodeString,
//                                                                                 NULL,
//                                                                                 CFSTR(":/?#[]@!$&’()*+,;="),
//                                                                                 kCFStringEncodingUTF8));
        return encodeString;
    }
    return nil;
}

+ (NSString *)sha1:(NSString *)inputStr
{
    
    
    NSData *data = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
    
}


+(NSString *)md5:(NSString *)inPutText
{
    if (inPutText == nil) {
        return @"";
    }
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSString *md5 =  [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                       result[0], result[1], result[2], result[3],
                       result[4], result[5], result[6], result[7],
                       result[8], result[9], result[10], result[11],
                       result[12], result[13], result[14], result[15]
                       ] uppercaseString];
    return md5?md5:@"";
}


+ (NSString *)dataMd5:(NSData *)data
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (int)[data length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

@end
