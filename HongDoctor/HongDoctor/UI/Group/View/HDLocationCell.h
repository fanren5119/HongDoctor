//
//  HDLocationCell.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDLocationCellEntity;

@interface HDLocationCell : UITableViewCell

- (void)resetCellWithEntity:(HDLocationCellEntity *)entity;

@end
