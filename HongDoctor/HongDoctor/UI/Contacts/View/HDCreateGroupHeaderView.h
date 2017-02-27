//
//  HDCreateGroupHeaderView.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDContractEntity;
@protocol HDCreateGroupHeaderViewDelegate;

@interface HDCreateGroupHeaderView : UIView

@property (nonatomic, weak) id <HDCreateGroupHeaderViewDelegate> delegate;

- (void)resetViewWithData:(NSArray *)dataArray;

@end

@protocol HDCreateGroupHeaderViewDelegate <NSObject>

- (void)didSelectItemWithEntity:(HDContractEntity *)entity;

@end
