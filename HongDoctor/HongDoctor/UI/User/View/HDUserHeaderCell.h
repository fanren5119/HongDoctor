//
//  HDUserHeaderCell.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDUserCellModel;

@interface HDUserHeaderCell : UITableViewCell

- (void)resetCellWithEntity:(HDUserCellModel *)entity;

@end
