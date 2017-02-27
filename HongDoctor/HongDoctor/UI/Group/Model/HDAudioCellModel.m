//
//  HDMedioCellModel.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDAudioCellModel.h"

@implementation HDAudioCellModel

- (id)init
{
    self = [super init];
    if (self) {
        self.type = MessageAudio;
    }
    return self;
}


@end
