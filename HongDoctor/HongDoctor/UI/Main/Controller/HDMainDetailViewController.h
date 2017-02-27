//
//  HDMainDetailViewController.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMainDetailViewController : UIViewController

@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL      isPopToRoot;
@property (nonatomic, strong) NSString *backTitle;

@end
