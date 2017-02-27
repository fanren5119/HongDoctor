//
//  HDGroupCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/16.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDGroupCellModel : NSObject

@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupHeaderURl;
@property (nonatomic, strong) NSString *groupdName;
@property (nonatomic, strong) NSString *groupNewMessage;
@property (nonatomic, strong) NSString *groupNewDate;
@property (nonatomic, strong) NSString *groupNewMsgType;
@property (nonatomic, strong) NSString *groupProperty;
@property (nonatomic, strong) NSString *msgProperty;
@property (nonatomic, strong) NSString *msgUnReadCount;
@property (nonatomic, strong) NSString *groupMemberCount;
@property (nonatomic, assign) BOOL      isExportGroup;

@end
