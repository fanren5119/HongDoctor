//
//  HDScanImageViewController.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/17.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDScanImageViewController : UIViewController

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSString *backItemTitle;

@end
