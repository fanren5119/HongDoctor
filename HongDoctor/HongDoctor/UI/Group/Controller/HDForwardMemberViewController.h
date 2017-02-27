//
//  HDForwardMemberViewController.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/24.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDForwardMemberViewController : UIViewController

@property (nonatomic, strong) NSString  *backItemTitle;

@property (nonatomic, strong) void (^selectHandler) (NSArray *memberArray);

@end
