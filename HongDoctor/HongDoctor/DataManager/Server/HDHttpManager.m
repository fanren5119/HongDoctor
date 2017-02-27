//
//  HDHttpManager.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDHttpManager.h"
#import "AFNetworking.h"
#import "HDStartEntity.h"
#import "GWEncodeHelper.h"
#import "HDImageManager.h"

@implementation HDHttpManager

+ (void)GET:(NSString *)urlString success:(successBolck)success fail:(failBolck)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    manager.responseSerializer = serializer;
//    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL, urlString];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData * responseObject) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
        NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        success(newString);
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"");
    }];
}

+ (void)POST:(NSString *)urlString parameters:(NSString *)parameters success:(successBolck)success fail:(failBolck)fail
{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL, urlString];
//    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
//    NSString *string = [NSString stringWithFormat:@"%@%@",baseURL, urlString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:url];
    [requst setHTTPMethod:@"POST"];
    [requst setTimeoutInterval:60];
//    NSDictionary *dict = @{};
//    [requst setAllHTTPHeaderFields:dict];
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [parameters dataUsingEncoding:gbkEncoding];
    [requst setHTTPBody:data];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"====%@", response);
    }];
    [task resume];
}


+ (void)uploadMessage:(NSString *)urlString parameters:(NSString *)parameter data:(NSData *)data filename:(NSString *)filename success:(successBolck)success fail:(failBolck)fail isFile:(BOOL)isFile
{
    NSStringEncoding gbkEncoding = NSUTF8StringEncoding;

    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"multipart/form-data; boundary=--------------------------7d03135102b8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:parameter forHTTPHeaderField:@"ChatMsg"];
    NSString *boundary = @"--------------------------7d03135102b8";
    
    NSMutableData *contentData = [[NSMutableData alloc] init];
    NSMutableString *contentHeaderString = [[NSMutableString alloc] init];
    [contentHeaderString appendString:[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]];
    if (isFile) {
        [contentHeaderString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedFile\"; filename=\"%@\"\r\n", filename]];
        [contentHeaderString appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
        [contentData appendData:[contentHeaderString dataUsingEncoding:gbkEncoding]];
        if (data != nil) {
            [contentData appendData:data];
        }
    } else {
        [contentHeaderString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n"]];
        [contentHeaderString appendString:[NSString stringWithFormat:@"Content-Length: %lu\r\n\r\n", (unsigned long)data.length]];
        [contentData appendData:[contentHeaderString dataUsingEncoding:gbkEncoding]];
        if (data != nil) {
            [contentData appendData:data];
        }
    }
    
    NSMutableString *contentTailString = [[NSMutableString alloc] init];
    [contentTailString appendString:[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]];
    [contentData appendData:[contentTailString dataUsingEncoding:gbkEncoding]];
    urlRequest.HTTPBody = contentData;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    sessionManager.responseSerializer = serializer;
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            fail(error.description);
        } else {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            success(string);
        }
    }];
    [dataTask resume];
}

+ (void)uploadMessage:(NSString *)urlString parameters:(NSString *)parameter text:(NSString *)text images:(NSArray *)images success:(successBolck)success fail:(failBolck)fail
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"multipart/form-data; boundary=--------------------------7d03135102b8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:parameter forHTTPHeaderField:@"ChatMsg"];
    NSString *boundary = @"--------------------------7d03135102b8";
    
    NSMutableData *contentData = [[NSMutableData alloc] init];
    NSMutableString *contentHeaderString = [[NSMutableString alloc] init];
    [contentHeaderString appendString:[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]];
    [contentData appendData:[contentHeaderString dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (text != nil && text.length > 0) {
        NSMutableString *string = [NSMutableString string];
        NSData *data = [text dataUsingEncoding:gbkEncoding];
        [string appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n"]];
        [string appendString:[NSString stringWithFormat:@"Content-Length: %lu\r\n\r\n", (unsigned long)data.length]];
        [contentData appendData:[string dataUsingEncoding:gbkEncoding]];
        if (data != nil) {
            [contentData appendData:data];
        }
    }
    
    if (images.count > 0) {
        for (NSString *imageName in images) {
            UIImage *image = [HDImageManager getImageWithName: imageName];
            NSString *filename = [imageName stringByAppendingString:@".jpg"];
            NSData *data = UIImageJPEGRepresentation(image, 1);

            NSMutableString *string = [NSMutableString string];
            [string appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedFile\"; filename=\"%@\"\r\n", filename]];
            [string appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
            [contentData appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
            if (data != nil) {
                [contentData appendData:data];
            }
        }
    }
    
    NSMutableString *contentTailString = [[NSMutableString alloc] init];
    [contentTailString appendString:[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]];
    [contentData appendData:[contentTailString dataUsingEncoding:NSUTF8StringEncoding]];
    urlRequest.HTTPBody = contentData;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    sessionManager.responseSerializer = serializer;
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            fail(error.description);
        } else {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            success(string);
        }
    }];
    [dataTask resume];
}

@end

