//
//  HDContractItemSelectView.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDContractItemSelectViewDelegate;

@interface HDContractItemSelectView : UIView

@property (nonatomic, weak) id <HDContractItemSelectViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)hide;

@end


@protocol HDContractItemSelectViewDelegate <NSObject>

- (void)didSelectWithIndex:(NSInteger)index;
- (void)didClickToHideView;

@end
