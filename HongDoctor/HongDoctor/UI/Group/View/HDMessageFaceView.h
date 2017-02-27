//
//  HDMessageFaceView.h
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMessageFaceViewDelegate;

@interface HDMessageFaceView : UIView

@property (nonatomic, assign) CGFloat itemSideLength;
@property (nonatomic, assign) CGFloat itemInterval;
@property (nonatomic, weak) id <HDMessageFaceViewDelegate> delegate;

@end

@protocol HDMessageFaceViewDelegate <NSObject>

- (void)didSelectIndexFace:(NSInteger)index;
- (void)didSelectDelete;

@end
