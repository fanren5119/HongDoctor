//
//  HDRegisterViewController.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDRegisterViewController : UIViewController

@property (nonatomic, strong) void (^registerHandler) (NSString *phone);

@end
