//
//  HDForwardGroupCell.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDForwardGroupCellModel;

@interface HDForwardGroupCell : UITableViewCell

- (void)resetCellWithEntity:(HDForwardGroupCellModel *)model;
- (void)hideLineView:(BOOL)isHide;

@end
