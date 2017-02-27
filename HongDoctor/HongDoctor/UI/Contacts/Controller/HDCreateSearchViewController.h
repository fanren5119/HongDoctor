//
//  HDCreateSearchViewController.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCreateSearchViewController : UIViewController

@property (nonatomic, strong) NSArray *outContractIds;
@property (nonatomic, strong) NSArray *selectContractIds;
@property (nonatomic, strong) NSString *backItemTitle;

@property (nonatomic, strong) void (^searchContractHandler) (NSArray *contractIds);

@end
