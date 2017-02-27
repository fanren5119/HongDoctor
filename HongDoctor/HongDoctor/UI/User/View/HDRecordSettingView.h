//
//  HDRecordSettingView.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDRecordSettingViewDelegate;

@interface HDRecordSettingView : UIView

@property (nonatomic, weak) id <HDRecordSettingViewDelegate> delegate;

- (void)showViewWithData:(NSArray *)data;
- (void)hide;

@end


@protocol HDRecordSettingViewDelegate <NSObject>

- (void)didSelectItem:(NSInteger)index;

@end
