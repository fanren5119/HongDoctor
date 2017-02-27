//
//  HDForwardHeaderView.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/24.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDForwardHeaderViewDelegate;
@class HDForwardHeaderModel;

@interface HDForwardHeaderView : UIView

@property (nonatomic, weak) id <HDForwardHeaderViewDelegate> delegate;

- (void)resetViewWithData:(NSArray *)dataArray;

@end


@protocol HDForwardHeaderViewDelegate <NSObject>

- (void)didSelectItemWithModel:(HDForwardHeaderModel *)model;

@end
