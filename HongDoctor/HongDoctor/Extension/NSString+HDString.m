//
//  NSString+HDString.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/18.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "NSString+HDString.h"

@implementation NSString (HDString)

- (NSAttributedString *)messageAttribute
{
    NSArray *array = [self componentsSeparatedByString:@"<img src=\""];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    if (array.count <= 0) {
        return attributeStr;
    }
    
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:array[0]];
    [attributeStr appendAttributedString:attr1];
    
    for (int i = 1; i < array.count; i ++) {
        NSArray *array2 = [array[i] componentsSeparatedByString:@"\"/>"];
        if (array2.count > 0) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(0, 0, 15, 15);
            NSString *imageName = [NSString stringWithFormat:@"f_static_%@.png", array2[0]];
            attach.image = [UIImage imageNamed:imageName];
            NSAttributedString *attr2 = [NSAttributedString attributedStringWithAttachment:attach];
            [attributeStr appendAttributedString:attr2];
        } else if (array2.count > 1) {
            NSAttributedString *attr3 = [[NSAttributedString alloc] initWithString:array[1]];
            [attributeStr appendAttributedString:attr3];
        }
    }
    return attributeStr;
}
- (NSString *)hdfirstCharacter
{
    if (self == nil || self.length <= 0) {
        return @"";
    }
    NSMutableString *stringLetters = [NSMutableString stringWithString:self];
    
    CFStringTransform((CFMutableStringRef)stringLetters,NULL, kCFStringTransformMandarinLatin,NO);
    
    CFStringTransform((CFMutableStringRef)stringLetters,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *stringTrimming = [stringLetters stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstCharacter = [stringTrimming substringToIndex:1];
    NSString *upperCharacter = [firstCharacter uppercaseString];
    
//    NSString* number=@"[A-Z]";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
//    if ([numberPre evaluateWithObject:upperCharacter]) {
//        return upperCharacter;
//    }
    return upperCharacter;
}


@end
