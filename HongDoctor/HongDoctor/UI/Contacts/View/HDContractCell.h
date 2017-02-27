//
//  HDContractCell.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDContractBaseEntity;

@interface HDContractCell : UITableViewCell

- (void)resetCellWithEntity:(HDContractBaseEntity *)entity;

@end


