//
//  HDMessageViewController.h
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMessageViewController : UIViewController

@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupProperty;
@property (nonatomic, assign) NSInteger groupMemberCount;
@property (nonatomic, assign) BOOL      isPopToGroupVC;

@end
