//
//  HDMessageHandleView.h
//  WebViewCacheTest
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HandleItemType) {
    HandleItemCopy      = 0,
    HandleItemForward   = 1,
    HandleItemDelete    = 2,
};

@protocol HDMessageHandleViewDelegate;

@interface HDMessageHandleView : UIView

- (id)initWithFrame:(CGRect)frame itemTypes:(NSArray *)itemTypes;

@property (nonatomic, weak) id <HDMessageHandleViewDelegate> delegate;

@end


@protocol HDMessageHandleViewDelegate <NSObject>

- (void)didSelectItemWithType:(HandleItemType)type;

@end
