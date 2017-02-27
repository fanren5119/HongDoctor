//
//  HDMessageRightTextCell.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMessageCellDelegate;
@class HDMessageCellModel;

@interface HDMessageRightTextCell : UITableViewCell

@property (nonatomic, weak) id <HDMessageCellDelegate> delegate;

- (void)resetCellWithModel:(HDMessageCellModel *)model;

@end
