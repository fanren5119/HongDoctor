//
//  HDCreateGroupCell.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDContractEntity;
@protocol HDContractCellDelegate;

@interface HDCreateGroupCell : UITableViewCell

@property (nonatomic, weak) id <HDContractCellDelegate> delegate;

- (void)resetCellWithEntity:(HDContractEntity *)entity;

@end

@protocol HDContractCellDelegate <NSObject>

- (void)didClickSelectButton:(HDContractEntity *)entity;

@end
