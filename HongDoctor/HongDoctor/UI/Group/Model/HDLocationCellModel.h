//
//  HDLocationCellModel.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/28.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageCellModel.h"

@interface HDLocationCellModel : HDMessageCellModel

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *contentImageURL;
@property (nonatomic, assign) double   longitude;
@property (nonatomic, assign) double  latitude;

@end
