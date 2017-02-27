//
//  HDGroupMemberFootCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupMemberFootCell.h"

@implementation HDGroupMemberFootCell

- (IBAction)respondsToExistButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickToExistGroup)]) {
        [self.delegate didClickToExistGroup];
    }
}

@end
