//
//  HDMainNoDataView.h
//  HongDoctor
//
//  Created by 王磊 on 2017/2/13.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMainNoDataViewDelegate;

@interface HDMainNoDataView : UIView

@property (nonatomic, weak) id <HDMainNoDataViewDelegate> delegate;

@end


@protocol HDMainNoDataViewDelegate <NSObject>

- (void)didSelectButtonToRefresh;

@end
