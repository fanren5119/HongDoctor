//
//  HDMessageOtherOptionView.h
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMessageOtherOptionViewDelegate;

@interface HDMessageOtherOptionView : UIView

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, weak) id <HDMessageOtherOptionViewDelegate> delegate;

@end


@protocol HDMessageOtherOptionViewDelegate <NSObject>

- (void)didSelectOptionView:(HDMessageOtherOptionView *)optionView;

@end
