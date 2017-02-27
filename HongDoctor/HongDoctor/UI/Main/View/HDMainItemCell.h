//
//  HDMainItemCell.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/10.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDMainHeaderEntity;

@interface HDMainItemCell : UITableViewCell

- (void)resetCellWithEntity:(HDMainHeaderEntity *)entity;
- (void)hideLineView:(BOOL)hide;

@end
