//
//  TaskUtility.h
//
//  Created by Owen.Qin on 13-5-6.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#define k_mimetype_jpeg     @"jpeg"
#define k_mimetype_png      @"png"
#define k_mimetype_col_gif  @"collaboration.gif"
#define k_mimetype_gif      @"gif"//
#define k_mimetype_tiff     @"tiff"
#define k_mimetype_amr      @"amr"
#define k_mimetype_wav      @"x-wav"
#define k_mimetype_mp3      @"mpeg"
#define k_mimetype_xls      @"vnd.ms-excel"
#define k_mimetype_xlsx     @"vnd.openxmlformats-officedocument.spreadsheetml.sheet"
#define k_mimetype_pptx     @"vnd.openxmlformats-officedocument.presentationml.presentation"
#define k_mimetype_ppt      @"vnd.ms-powerpoint"
#define k_mimetype_ppsx     @"vnd.openxmlformats-officedocument.presentationml.slideshow"
#define k_mimetype_doc      @"msword"
#define k_mimetype_docx     @"vnd.openxmlformats-officedocument.wordprocessingml.document"
#define k_mimetype_dotx     @"vnd.openxmlformats-officedocument.wordprocessingml.template"
#define k_mimetype_pdf      @"pdf"
#define k_mimetype_plain    @"plain"

#define k_mimetype_zip      @"zip"

#define k_mimetype_mp4      @"mp4"
#define k_mimetype_3gp      @"3gpp"
#define k_mimetype_avi      @"x-msvideo"
#define k_mimetype_ogv      @"ogg"
#define k_mimetype_m4v      @"x-m4v"
#define k_mimetype_mov      @"quicktime"

#define k_mimetype_unknown   @"oct-stream"

//#define k_mimetype_record_amr @"recordamr"
#define k_mimetype_record_amr @"collaboration.amr"
#define k_mimetype_recordamr_full @"audio/collaboration.amr"

#define k_mimetype_location @"application/collaboration.location"

/*
audio
video(jiamei)
doc
xls
ppt
pdf
txt
zip(jiamei)
application/zip
未知图标 -> application/oct-stream
*/
 
#define k_mimecategory_image            @"image"
#define k_mimecategory_audio            @"audio"
#define k_mimecategory_video            @"video"
#define k_mimecategory_application      @"application"
#define k_mimecategory_text             @"text"
#define k_mimecategory_unknown          @"application/oct-stream"
#define k_mimecategory_externallink     @"external-link"

@interface TaskUtility : NSObject

+ (NSString*)mimeType:(NSString*)mediaType;
+ (NSString*)mimeCategory:(NSString*)mimeType;
+ (NSString*)convertMimeTypeFromFileExt:(NSString*)fileExt;

+ (BOOL)isImageMimeType:(NSString*)mimeType;
+ (BOOL)isGifImageMimeType:(NSString*)mimeType;
+ (BOOL)isLocationMimeType:(NSString*)mimeType;
+ (BOOL)isAudioMimeType:(NSString*)mimeType;
+ (BOOL)isAudioRecordAmrMimeType:(NSString *)mimeType;
+ (BOOL)isVideoMimeType:(NSString *)mimeType;
+ (BOOL)isExternalLinkType:(NSString*)mimeType;
+ (BOOL)isApplicationMimeType:(NSString*)mimeType;
+ (BOOL)isTextMimeType:(NSString*)mimeType;
+ (BOOL)isUnknowTypes:(NSString *)mimeType;

+ (NSString*)pathForUserSpace;
+ (NSString*)pathForAttachmentImageFile:(NSString*)fileName;
+ (NSString*)pathForAttachmentAudioFile:(NSString*)fileName;
+ (NSString*)pathForAttachmentVideoFile:(NSString*)fileName;
+ (NSString*)pathForLocalDBFile:(NSString*)fileName;
+ (NSString*)pathForOutBoxFile:(NSString*)fileName;
+ (NSString*)pathForAttachmentFiles:(NSString*)fileName inTalk:(NSString*)talkId;
+ (NSString*)pathForTalk:(NSString*)talkId;
+ (void)deletePathForTalk:(NSString*)talkId;
+ (NSString*)pathForBCLog;
#pragma mark - Recv File
+ (NSString *)pathForRecvRootFilePath;
+ (NSString*)pathForRecvFile:(NSString*)fileName;
//+ (BOOL)writeRecvFile:(NSData *)data fileName:(NSString *)fileName extention:(NSString *)extention directoryId: (NSString *) directoryId subDirectoryId: (NSString *) subdirectoryId;
+ (BOOL)writeRecvFile:(NSData *)data fileName:(NSString *)fileName extention:(NSString *)extention;
+ (BOOL)writeRecvFile:(NSData *)data fileName:(NSString *)fileName extention:(NSString *)extention filePath:(NSString *)subFilePath;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (void)removeAllRecvFile;
+ (NSString*)fileSizeByKB:(long long)fileSize;
+ (BOOL)fileExistsWithFileName:(NSString *)fileName;

//+ (NSString *) pathForTalkId: (NSString *) talkId attachmentId:(NSString *) attachmentId fileName:(NSString *) fileName;
//+ (NSString *) pathForTaskId: (NSString *) taskId attachmentId:(NSString *) attachmentId fileName:(NSString *) fileName;
//+ (NSArray *) fileFromUserDirectory;

#pragma mark -
#pragma mark Core Foundation

+ (NSString*)createUUID;
+ (NSString *)getFullNamePinyin:(NSString *)sourceString;

#pragma mark -
#pragma mark message
//+ (NSString*)lastMessageTextFrom:(Message *)msgEntity;
//+ (UIImage*)shrinkImage:(UIImage*)original size:(CGSize)size;

@end
