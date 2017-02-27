//
//  HDMedioCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageCellModel.h"

@interface HDAudioCellModel : HDMessageCellModel

@property (nonatomic, strong) NSString *audioURL;
@property (nonatomic, strong) NSString *length;
@property (nonatomic, assign) BOOL      hasRead;

@end
