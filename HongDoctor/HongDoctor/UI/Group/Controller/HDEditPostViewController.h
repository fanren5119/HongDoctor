//
//  HDEditPostViewController.h
//  HongDoctor
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDEditPostViewController : UIViewController

@property (nonatomic, strong) NSString *groupGuid;
@property (nonatomic, strong) NSString *groupPost;
@property (nonatomic, assign) BOOL     canEdit;
@property (nonatomic, strong) NSString *backItemTitle;
@property (nonatomic, strong) void (^modifyHandler) (NSString *groupName);

@end
