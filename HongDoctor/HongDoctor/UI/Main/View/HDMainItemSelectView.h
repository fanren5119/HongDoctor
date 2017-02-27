//
//  HDMainItemSelectView.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/10.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDMainHeaderEntity;
@protocol HDMainItemSelectViewDelegate;

@interface HDMainItemSelectView : UIView

@property (nonatomic, weak) id <HDMainItemSelectViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;
- (void)hide;

@end


@protocol HDMainItemSelectViewDelegate <NSObject>

- (void)didSelectWithEntity:(HDMainHeaderEntity *)entity;
- (void)didClickToHideView;

@end
