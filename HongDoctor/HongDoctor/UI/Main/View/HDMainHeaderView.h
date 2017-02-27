//
//  HDMainHeaderView.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/10.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMainHeaderViewDelegate;

@interface HDMainHeaderView : UIView

@property (nonatomic, weak) id <HDMainHeaderViewDelegate> delegate;

@end

@protocol HDMainHeaderViewDelegate <NSObject>

- (void)didSelectHeadImageView;
- (void)didSelectToSearchWithText:(NSString *)text;
- (void)didSelectToAddButton;

@end
