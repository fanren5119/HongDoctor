//
//  TaskUtility.m
//
//  Created by Owen.Qin on 13-5-6.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import "TaskUtility.h"
#import <sys/xattr.h>
#import "HDUserEntity.h"
#import "HDLocalDataManager.h"

@implementation TaskUtility

+ (NSString*)mimeType:(NSString*)mediaType
{
    if ([mediaType isEqualToString:k_mimetype_jpeg] ||
        [mediaType isEqualToString:k_mimetype_png] ||
        [mediaType isEqualToString:k_mimetype_gif] ||
        [mediaType isEqualToString:k_mimetype_col_gif] ||
        [mediaType isEqualToString:k_mimetype_tiff]) {
        return [NSString stringWithFormat:@"%@/%@", k_mimecategory_image, mediaType];
    }
    else if ([mediaType isEqualToString:k_mimetype_amr] ||
             [mediaType isEqualToString:k_mimetype_wav] ||
             [mediaType isEqualToString:k_mimetype_mp3] ||
             [mediaType isEqualToString:k_mimetype_record_amr]) {
        return [NSString stringWithFormat:@"%@/%@", k_mimecategory_audio, mediaType];
    }
    else if ([mediaType isEqualToString:k_mimetype_xls]  ||
             [mediaType isEqualToString:k_mimetype_xlsx] ||
             [mediaType isEqualToString:k_mimetype_pptx] ||
             [mediaType isEqualToString:k_mimetype_ppt]  ||
             [mediaType isEqualToString:k_mimetype_ppsx] ||
             [mediaType isEqualToString:k_mimetype_doc]  ||
             [mediaType isEqualToString:k_mimetype_docx] ||
             [mediaType isEqualToString:k_mimetype_dotx] ||
             [mediaType isEqualToString:k_mimetype_pdf]  ||
             [mediaType isEqualToString:k_mimetype_zip]) {
        return [NSString stringWithFormat:@"%@/%@", k_mimecategory_application, mediaType];
    }
    else if ([mediaType isEqualToString:k_mimetype_plain]) {
        return [NSString stringWithFormat:@"%@/%@", k_mimecategory_text, mediaType];
    }
    else if ([mediaType isEqualToString:k_mimetype_mp4]  ||
             [mediaType isEqualToString:k_mimetype_3gp]  ||
             [mediaType isEqualToString:k_mimetype_avi]  ||
             [mediaType isEqualToString:k_mimetype_ogv]  ||
             [mediaType isEqualToString:k_mimetype_m4v]  ||
             [mediaType isEqualToString:k_mimetype_mov]) {
        return [NSString stringWithFormat:@"%@/%@", k_mimecategory_video, mediaType];
    }
    
    return k_mimecategory_unknown;
}

+ (NSString*)mimeCategory:(NSString*)mimeType
{
    if ([mimeType hasPrefix:@"image/"]) {
        return k_mimecategory_image;
    }
    if ([mimeType hasPrefix:@"audio/"]) {
        return k_mimecategory_audio;
    }
    if ([mimeType hasPrefix:@"application/"]) {
        return k_mimecategory_application;
    }
    if ([mimeType hasPrefix:@"text/"]) {
        return k_mimecategory_text;
    }
    if ([mimeType hasPrefix:@"video/"]) {
        return k_mimecategory_video;
    }
    return k_mimecategory_unknown;
}

+ (NSString*)convertMimeTypeFromFileExt:(NSString*)fileExt
{    if ([fileExt isEqualToString:@"amr"]) {
        return k_mimetype_amr;
    }
    
    if ([fileExt isEqualToString:k_mimetype_record_amr]) {
        return k_mimetype_record_amr;
    }
    
    if ([fileExt isEqualToString:@"wav"]) {
        return k_mimetype_wav;
    }
    if ([fileExt isEqualToString:@"xls"]) {
        return k_mimetype_xls;
    }
    if ([fileExt isEqualToString:@"xlsx"]) {
        return k_mimetype_xlsx;
    }
    if ([fileExt isEqualToString:@"pptx"]) {
        return k_mimetype_pptx;
    }
    if ([fileExt isEqualToString:@"ppt"] ||
        [fileExt isEqualToString:@"pot"] ||
        [fileExt isEqualToString:@"pps"]) {
        return k_mimetype_ppt;
    }
    if ([fileExt isEqualToString:@"ppsx"]) {
        return k_mimetype_ppsx;
    }
    if ([fileExt isEqualToString:@"doc"] ||
        [fileExt isEqualToString:@"dot"]) {
        return k_mimetype_doc;
    }
    if ([fileExt isEqualToString:@"docx"]) {
        return k_mimetype_docx;
    }
    if ([fileExt isEqualToString:@"dotx"]) {
        return k_mimetype_dotx;
    }
    if ([fileExt isEqualToString:@"pdf"]) {
        return k_mimetype_pdf;
    }
    if ([fileExt isEqualToString:@"txt"]) {
        return k_mimetype_plain;
    }
    
    if ([fileExt isEqualToString:@"zip"]) {
        return k_mimetype_zip;
    }
    if ([fileExt isEqualToString:@"mp4"]) {
        return k_mimetype_mp4;
    }
    if ([fileExt isEqualToString:@"3gp"]) {
        return k_mimetype_3gp;
    }
    if ([fileExt isEqualToString:@"avi"]) {
        return k_mimetype_avi;
    }
    if ([fileExt isEqualToString:@"ogv"]) {
        return k_mimetype_ogv;
    }
    if ([fileExt isEqualToString:@"m4v"]) {
        return k_mimetype_m4v;
    }
    if ([fileExt isEqualToString:@"mov"]) {
        return k_mimetype_mov;
    }
    if ([fileExt isEqualToString:@"mp1"] ||
        [fileExt isEqualToString:@"mp2"] ||
        [fileExt isEqualToString:@"mp3"] ||
        [fileExt isEqualToString:@"mpg"] ||
        [fileExt isEqualToString:@"mpeg"]) {
        return k_mimetype_mp3;
    }
    
    if ([fileExt isEqualToString:@"jpg"] ||
        [fileExt isEqualToString:@"jpeg"] ) {
        return k_mimetype_jpeg;
    }
    
    if ([fileExt isEqualToString:@"png"]) {
        return k_mimetype_png;
    }
    
    if ([fileExt isEqualToString:@"gif"]) {
        return k_mimetype_gif;
    }
    
    if ([fileExt isEqualToString:@"tiff"]) {
        return k_mimetype_tiff;
    }
    
    return k_mimetype_unknown;
}

+ (BOOL)isImageMimeType:(NSString*)mimeType
{
    if ([mimeType hasPrefix:@"image/"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isGifImageMimeType:(NSString*)mimeType
{
    if ([mimeType isEqualToString:@"image/gif"] || [mimeType hasSuffix:k_mimetype_col_gif] ) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLocationMimeType:(NSString*)mimeType
{
    if ([mimeType isEqualToString:k_mimetype_location]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAudioMimeType:(NSString*)mimeType
{
    if ([mimeType hasPrefix:@"audio/"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAudioRecordAmrMimeType:(NSString *)mimeType
{
    if ([mimeType isEqualToString:k_mimetype_recordamr_full]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isVideoMimeType:(NSString *)mimeType
{
    if ([mimeType hasPrefix:@"video/"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isExternalLinkType:(NSString*)mimeType
{
    if ([mimeType isEqualToString: k_mimecategory_externallink])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isApplicationMimeType:(NSString*)mimeType
{
    if ([mimeType hasPrefix:@"application/"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTextMimeType:(NSString*)mimeType
{
    if ([mimeType hasPrefix:@"text/"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isUnknowTypes:(NSString *)mimeType
{
    if ([mimeType isEqualToString:k_mimecategory_unknown]) {
        return YES;
    }
    return NO;
}

+ (NSString*)pathForUserSpace
{
    NSString* pathForDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    NSString* pathForUserSpace = [pathForDocuments stringByAppendingPathComponent:userEntity.userGuid];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForUserSpace withIntermediateDirectories:NO attributes:nil error:NULL];
    return pathForUserSpace;
}

+ (NSString*)pathForAttachmentImageFile:(NSString*)fileName
{
    NSString* pathForImage = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"image"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForImage withIntermediateDirectories:NO attributes:nil error:NULL];
    NSString* pathForFile = [pathForImage stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+ (NSString*)pathForAttachmentAudioFile:(NSString*)fileName
{
    NSString* pathForAudio = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"audio"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForAudio withIntermediateDirectories:NO attributes:nil error:NULL];
    NSString* pathForFile = [pathForAudio stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+ (NSString*)pathForAttachmentVideoFile:(NSString*)fileName
{
    NSString* pathForAudio = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"video"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForAudio withIntermediateDirectories:NO attributes:nil error:NULL];
    NSString* pathForFile = [pathForAudio stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+ (NSString*)pathForLocalDBFile:(NSString*)fileName
{
    NSString* pathForDB = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"localDB"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForDB withIntermediateDirectories:NO attributes:nil error:NULL];
    NSString* pathForFile = [pathForDB stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+ (NSString*)pathForOutBoxFile:(NSString*)fileName
{
    NSString* pathForOutBox = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"outbox"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForOutBox withIntermediateDirectories:NO attributes:nil error:NULL];
    NSString* pathForFile = [pathForOutBox stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+ (NSString*)pathForAttachmentFiles:(NSString*)fileName inTalk:(NSString*)talkId
{
    NSString* pathForAttachments = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"attachment"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForAttachments withIntermediateDirectories:NO attributes:nil error:NULL];

    NSString* pathForTalk = [pathForAttachments stringByAppendingPathComponent:talkId];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForTalk withIntermediateDirectories:NO attributes:nil error:NULL];
    
    NSString* pathForFile = [pathForTalk stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+ (NSString*)pathForTalk:(NSString*)talkId
{
    NSString* pathForAttachments = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"attachment"];
    NSString* pathForTalk = [pathForAttachments stringByAppendingPathComponent:talkId];
    return pathForTalk;
}

+ (void)deletePathForTalk:(NSString*)talkId
{
    NSString* pathForTalk = [TaskUtility pathForTalk:talkId];
    [[NSFileManager defaultManager] removeItemAtPath:pathForTalk error:nil];
}

+ (NSString*)pathForBCLog
{
    NSString *pathForDocuments = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pathForBCLogFile = [pathForDocuments stringByAppendingPathComponent:@"BCLog"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathForBCLogFile]) {
        return pathForBCLogFile;
    }
    return nil;
}

+ (NSString*)pathForRecvFile:(NSString*)fileName
{
    NSString* pathForRecv = [TaskUtility pathForRecvRootFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathForRecv])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathForRecv
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    NSString* path = [pathForRecv stringByAppendingPathComponent:fileName];
    return path;
}

#pragma mark - V2.7文件目录新增的方法

//+ (NSString *) pathForTalkId: (NSString *) talkId attachmentId:(NSString *) attachmentId fileName:(NSString *) fileName
//{
//    return [self pathForDirectoryId: talkId subDirectoryId: attachmentId fileName: fileName];
//}
//
//+ (NSString *) pathForTaskId: (NSString *) taskId attachmentId:(NSString *) attachmentId fileName:(NSString *) fileName
//{
//    return [self pathForDirectoryId: taskId subDirectoryId: attachmentId fileName: fileName];
//}
//
//+ (NSString *) pathForDirectoryId: (NSString *) directoryId subDirectoryId:(NSString *) attachmentId fileName:(NSString *) fileName
//{
//    NSString* pathForAttachment = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"file/attachment/"];
//    NSString* pathForTalk = [NSString stringWithFormat: @"%@/%@/%@/%@", pathForAttachment, directoryId, attachmentId, fileName];
//    [[NSFileManager defaultManager] createDirectoryAtPath:[pathForTalk stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];
//    return pathForTalk;
//}

//+ (NSArray *) fileFromUserDirectory
//{
//    NSString* pathForAttachment = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"file/attachment/"];
//    
//    //读取根目录
//    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:pathForAttachment];
//    BOOL isDir;
//    NSString *path = nil;
//    NSMutableArray *files = [NSMutableArray new];
//    
//    //对目录进行遍历
//    while (path = [dirEnum nextObject])
//    {
//        //第一层目录
//        NSString *firstLevelDirectory = [pathForAttachment stringByAppendingPathComponent:path];
//        [[NSFileManager defaultManager] fileExistsAtPath:firstLevelDirectory isDirectory:&isDir];
//        
//        //只判断目录 取出目录中的文件
//        if (isDir)
//        {
//            [dirEnum skipDescendants];
//
//            //第二层目录
//            NSDirectoryEnumerator *secondDirEnum = [[NSFileManager defaultManager] enumeratorAtPath:firstLevelDirectory];
//            NSString *secondPath = nil;
//            while (secondPath = [secondDirEnum nextObject])
//            {
//                isDir = NO;
//
//                NSString *secondLevelDirectory = [firstLevelDirectory stringByAppendingPathComponent:secondPath];
//                [[NSFileManager defaultManager] fileExistsAtPath:secondLevelDirectory isDirectory:&isDir];
//                if (isDir)
//                {
//                    [secondDirEnum skipDescendants];
//                    
//                    //第三层目录
//                    NSDirectoryEnumerator *thirdDirEnum = [[NSFileManager defaultManager] enumeratorAtPath:secondLevelDirectory];
//                    NSString *fileName = nil;
//                    if (fileName = [thirdDirEnum nextObject])
//                    {
//                        isDir = NO;
//                        NSString *fullPath = [secondLevelDirectory stringByAppendingPathComponent: fileName];
//                        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
//                        
//                        if (!isDir)
//                        {
//                            FileAttachment *attachment = [FileAttachment new];
//                            attachment.directoryId = [Guid guidFromString:path];
//                            
//                            attachment.attachmentId = [Guid guidFromString:secondPath];
//                            
//                            attachment.fileName = fileName;
//                            attachment.fullPath = fullPath;
//                            
//                            NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
//                                                        
//                            NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
//                            
//                            [tmpDic setObject:fileName forKey:@"fileName"];
//                            [tmpDic setObject:dic forKey:@"attribute"];
//                            
//                            attachment.fileAttribute = tmpDic;
//                            
//                            [files addObject:attachment];
//                        }
//                        else
//                        {
//                            DebugLog(@"此处有bug path = %@", secondLevelDirectory);
//                            //不是文件！不管了
//                        }
//                    }
//                }
//            }
//            
//        }
//        else
//        {
//            DebugLog(@"此处有bug path = %@", firstLevelDirectory);
//        }
//    }
//    
//    NSArray *results = [NSArray arrayWithArray:files];
//    return results;
//}

#pragma mark - RecvFile

+ (NSString *)pathForRecvRootFilePath
{
    NSString* pathForFile = [[TaskUtility pathForUserSpace] stringByAppendingPathComponent:@"file"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForFile withIntermediateDirectories:NO attributes:nil error:NULL];

    return pathForFile;
}

//+ (BOOL)writeRecvFile:(NSData *)data fileName:(NSString *)fileName extention:(NSString *)extention directoryId: (NSString *) directoryId subDirectoryId: (NSString *) subdirectoryId
//{
//    BOOL success = NO;
//    NSString *filePath = [TaskUtility pathForDirectoryId: directoryId subDirectoryId: subdirectoryId fileName: fileName];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory: NULL])
//    {
//        BOOL isRemove = NO;
//        isRemove = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//        if (!isRemove)
//        {
//            NSLog(@"存在重复命名文件移出失败");
//        }
//    }
//    
//    if ([extention length])
//    {
//        filePath = [filePath stringByAppendingPathExtension:extention];
//    }
//    success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
//    
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
//    [TaskUtility addSkipBackupAttributeToItemAtURL:fileURL];
//    return success;
//}

+ (BOOL)writeRecvFile:(NSData *)data fileName:(NSString *)fileName extention:(NSString *)extention
{
    BOOL success = NO;
    NSString *filePath = [[TaskUtility pathForRecvRootFilePath] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory: NULL])
    {
        BOOL isRemove = NO;
        isRemove = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        if (!isRemove)
        {
            NSLog(@"存在重复命名文件移出失败");
        }
    }
    
    if ([extention length])
    {
        filePath = [filePath stringByAppendingPathExtension:extention];
    }
    success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    [TaskUtility addSkipBackupAttributeToItemAtURL:fileURL];
    return success;
}

+ (BOOL)writeRecvFile:(NSData *)data fileName:(NSString *)fileName extention:(NSString *)extention filePath:(NSString *)subFilePath
{
    NSString* pathForFile = [[TaskUtility pathForRecvRootFilePath] stringByAppendingPathComponent:subFilePath];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForFile withIntermediateDirectories:YES attributes:nil error:NULL];
    fileName = [subFilePath stringByAppendingPathComponent:fileName];
    return [TaskUtility writeRecvFile:data fileName:fileName extention:extention];
}


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
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
}

+ (void)removeAllRecvFile
{
    NSDirectoryEnumerator *fileEnumeratorHome = [[NSFileManager defaultManager] enumeratorAtPath:[[TaskUtility pathForRecvRootFilePath] stringByDeletingLastPathComponent]];
    for (NSString *fileName in fileEnumeratorHome)
    {
        NSString *filePath = [[[TaskUtility pathForRecvRootFilePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
        BOOL suceess = NO;
        suceess =[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (BOOL)removeRecvFile:(NSString *)fileName
{
    NSString *filePath = [[TaskUtility pathForRecvRootFilePath] stringByAppendingPathComponent:fileName];
    BOOL suceess = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        suceess =[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    return suceess;
}

+ (NSString*)fileSizeByKB:(long long)fileSize {
    int k_bytes_onek = 1024;
    
	NSString *strAllLen = nil;
	if (fileSize < k_bytes_onek) {
		strAllLen = [NSString stringWithFormat:@"%lldB", fileSize];
	}
	else {
		double kLen = fileSize / k_bytes_onek;
		if (kLen < k_bytes_onek) {
            strAllLen = [NSString stringWithFormat:@"%.02fK", kLen];
		}
		else {
			double mLen = kLen / k_bytes_onek;
            strAllLen = [NSString stringWithFormat:@"%.02fM", mLen];
		}
	}
    return strAllLen;
}

+ (BOOL)fileExistsWithFileName:(NSString *)fileName
{
    NSString *filePath = [[TaskUtility pathForRecvRootFilePath] stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

#pragma mark -
#pragma mark Core Foundation

+ (NSString*)createUUID {
	NSString * nstrUUID = nil;
	
	// create UUID
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef cfstrUUID = CFUUIDCreateString(NULL, uuid);
	
	// convert NSString
	nstrUUID = [NSString stringWithString:(__bridge NSString*)cfstrUUID];
	
	// release
	CFRelease(uuid);
	CFRelease(cfstrUUID);
	
	return nstrUUID;
}

+ (NSString *)getFullNamePinyin:(NSString *)sourceString {
    if (![sourceString length] || sourceString == nil) {
        return nil;
    }
    
    NSString *fullName = sourceString;
	if ([fullName canBeConvertedToEncoding:NSASCIIStringEncoding]) {
		return fullName;
	}else {
//		NSString *pinyin = [BCPinyinConverter getPinyinWithString:fullName];
		return @"";
	}
}

//+ (NSString*)lastMessageTextFrom:(Message *)msgEntity
//{
//    NSString* lastMessageText = nil;
//    NSDictionary* dictAttachment = (NSDictionary *)[msgEntity.attachmentsJson objectFromJSONString];
//    if ([[dictAttachment allKeys] count] > 0) {
//        MessageAttachment *attachmentEntity = [MessageAttachment deserialize:dictAttachment];
//        if (attachmentEntity) {
//            if ([TaskUtility isGifImageMimeType:attachmentEntity.mime]) {
//                lastMessageText = [LocalizedUtil localizedStringFromTable:@"Message LastMessageText Gif" table:@"UI" comment:nil];
//            }
//            else if ([TaskUtility isImageMimeType:attachmentEntity.mime]) {
//                lastMessageText = [LocalizedUtil localizedStringFromTable:@"Message LastMessageText Image" table:@"UI" comment:nil];
//            }
//            else if ([TaskUtility isAudioRecordAmrMimeType:attachmentEntity.mime]) {
//                lastMessageText = [LocalizedUtil localizedStringFromTable:@"Message LastMessageText Audio" table:@"UI" comment:nil];
//            }
//            else if ([TaskUtility isLocationMimeType:attachmentEntity.mime]) {
//                lastMessageText = [LocalizedUtil localizedStringFromTable:@"Message LastMessageText Location" table:@"UI" comment:nil];
//            }
//        }
//    }
//    else {
//        lastMessageText = msgEntity.text;
//    }
//    return lastMessageText;
//}
//
//+ (UIImage*)shrinkImage:(UIImage*)original size:(CGSize)size
//{
//    NSLog(@"original size = %@", NSStringFromCGSize( original.size));
//    NSLog(@"size = %@", NSStringFromCGSize(size));
//    CGFloat x = 0, y = 0;
////    if (original.size.width > size.width)
////    {
////        x = (original.size.width - size.width)/2.0f;
////        y = (original.size.height - size.height)/2.0f;
////    }
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale,
//                                                 size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context,
//                       CGRectMake(-x, -y, size.width * scale, size.height * scale),
//                       original.CGImage);
//    CGImageRef shrunken = CGBitmapContextCreateImage(context);
//    UIImage *final = [UIImage imageWithCGImage:shrunken];
//    
//    CGContextRelease(context);
//    CGImageRelease(shrunken);
//    
//    return final;
//}

@end
