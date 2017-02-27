//
//  HDMessageModel.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageCellModel.h"
#import "HDChatMessageEntity.h"
#import "HDTextCellModel.h"
#import "HDImageCellModel.h"
#import "HDVideoCellModel.h"
#import "HDAudioCellModel.h"
#import "HDUserEntity.h"
#import "HDLocalDataManager.h"
#import "HDLocationCellModel.h"

@implementation HDMessageCellModel

+ (instancetype)cellModelWithEntity:(HDChatMessageEntity *)entity
{
    MessageCellType type = (MessageCellType)entity.messageType.integerValue;
    HDMessageCellModel *model = nil;
    switch (type) {
        case MessageText:
        {
            model = [[HDTextCellModel alloc] init];
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *string = [entity.messageContent stringByReplacingPercentEscapesUsingEncoding:gbkEncoding];
            [model setValue:string forKey:@"text"];
        }
            break;
        case MessageImage:
        {
            model = [[HDImageCellModel alloc] init];
            [model setValue:entity.messageContent forKey:@"imageURL"];
            [model setValue:entity.messageLength forKey:@"scanImageURL"];
        }
            break;
        case MessageVideo:
        {
            model = [[HDVideoCellModel alloc] init];
            [model setValue:entity.messageContent forKey:@"contentImageURL"];
            [model setValue:entity.messageLength forKey:@"videoURL"];
        }
            break;
        case MessageAudio:
        {
            model = [[HDAudioCellModel alloc] init];
            [model setValue:entity.messageContent forKey:@"audioURL"];
            [model setValue:entity.messageLength forKey:@"length"];
            NSArray *hasReadAudios = [HDLocalDataManager getHasReadAudioGuids];
            if ([hasReadAudios containsObject:entity.messageGuid]) {
                [model setValue:@(YES) forKey:@"hasRead"];
            } else {
                [model setValue:@(NO) forKey:@"hasRead"];
            }
        }
            break;
        case MessageLocation:
        {
            model = [[HDLocationCellModel alloc] init];
            [model setValue:entity.messageContent forKey:@"contentImageURL"];
            NSString *length = entity.messageLength;
            NSArray *array = [length componentsSeparatedByString:@"=KHHCLHK="];
            if (array.count > 0) {
                ((HDLocationCellModel *)model).longitude = [array[0] doubleValue];
            }
            if (array.count > 1) {
                ((HDLocationCellModel *)model).latitude = [array[1] doubleValue];
            }
            if (array.count > 2) {
                NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *string = [array[2] stringByReplacingPercentEscapesUsingEncoding:gbkEncoding];
                [model setValue:string forKey:@"address"];
            }
        }
            break;
        default:
            break;
    }
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    model.isUserSend = ([userEntity.userGuid isEqualToString:entity.senderGuid]);
    model.senderHeadURL = entity.senderHeadURL;
    model.sendType = (SendType)entity.sendingType;
    model.messageGuid = entity.messageGuid;
    
    NSDate *date = [NSDate dateFromString:entity.messageDate withFormat:@"yyyy-MM-dd HH:mm:ss:S"];
    model.messageTime = [NewsRelativeTimeFormat FromNowdateStringWithDate:date];
    return model;
}

@end
