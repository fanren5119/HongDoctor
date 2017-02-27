//
//  HDContractHeaderView.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDMemberDepartmentEntity;
@protocol HDContractHeaderViewDelegate;

@interface HDContractHeaderView : UIView

@property (nonatomic, weak) id <HDContractHeaderViewDelegate> delegate;

- (void)resetViewWithEntity:(HDMemberDepartmentEntity *)entity;

@end


@protocol HDContractHeaderViewDelegate <NSObject>

- (void)didSelectHeaderView:(HDMemberDepartmentEntity *)entity;

@end
