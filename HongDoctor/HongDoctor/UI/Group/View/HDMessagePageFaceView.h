//
//  HDMessagePageFaceView.h
//  Test
//
//  Created by 王磊 on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDMessagePageFaceViewDelegate;

@interface HDMessagePageFaceView : UIView

@property (nonatomic, weak) id <HDMessagePageFaceViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imageArray;

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

@end

@protocol  HDMessagePageFaceViewDelegate <NSObject>

- (void)faceView:(HDMessagePageFaceView *)faceView didSelectIndex:(NSInteger)index;

@end
