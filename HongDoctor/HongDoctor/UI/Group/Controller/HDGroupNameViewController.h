//
//  HDGroupNameViewController.h
//  HongDoctor
//
//  Created by wanglei on 2017/1/13.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDGroupNameViewController : UIViewController

@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, strong) NSString *backItemTitle;
@property (nonatomic, strong) void (^modifyHandler) (NSString *groupName);

@end
