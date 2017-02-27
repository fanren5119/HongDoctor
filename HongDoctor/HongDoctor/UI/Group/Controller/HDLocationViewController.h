//
//  HDLocationViewController.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/25.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLocationViewController : UIViewController

@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *backItemTitle;

@property (nonatomic, strong) void (^locationComplete) (NSString *address, double latitude, double longitude, NSString *imageName);

@end
