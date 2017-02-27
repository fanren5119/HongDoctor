//
//  HDTextCellModel.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDTextCellModel.h"

@implementation HDTextCellModel

- (id)init
{
    self = [super init];
    if (self) {
        self.type = MessageText;
    }
    return self;
}


@end
