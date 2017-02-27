//
//  HDCreateGroupViewController.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCreateGroupViewController : UIViewController

@property (nonatomic, assign) BOOL      isCreateGroup;
@property (nonatomic, strong) NSString  *groupGuid;
@property (nonatomic, strong) NSArray   *outMemberGuids;
@property (nonatomic, strong) NSString  *backItemTitle;

@end
