//
//  BOAlertController.m
//  BlueOffice
//
//  Created by 孙俊 on 14-9-25.
//  Copyright (c) 2014年 yipinapp.ibrand. All rights reserved.
//

#import "BOAlertController.h"

@interface BOAlertController()

@property (nonatomic, strong) NSString              *title;
@property (nonatomic, strong) NSString              *message;
@property (nonatomic, weak) UIViewController        *inViewController;
@property (nonatomic, strong) NSMutableDictionary   *buttonInfoDict;

@end

@implementation BOAlertController

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)inViewController
{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.inViewController = inViewController;
    }
    return self;
}

- (NSMutableDictionary *)buttonInfoDict
{
    if (_buttonInfoDict == nil) {
        _buttonInfoDict = [NSMutableDictionary dictionary];
    }
    return _buttonInfoDict;
}

- (void)addButton:(RIButtonItem *)button type:(RIButtonItemType)itemType
{
    if (button == nil || ![button isKindOfClass:[RIButtonItem class]]) {
        return;
    }
    switch (itemType) {
        case RIButtonItemType_Cancel:
        {
            [self.buttonInfoDict setObject:button forKey:@"RIButtonItemType_Cancel"];
        }
            break;
        case RIButtonItemType_Destructive:
        {
            [self.buttonInfoDict setObject:button forKey:@"RIButtonItemType_Destructive"];
        }
            break;
        case RIButtonItemType_Other:
        {
            NSMutableArray *otherArray = self.buttonInfoDict[@"RIButtonItemType_Other"];
            if (otherArray == nil) {
                otherArray = [NSMutableArray array];
            }
            [otherArray addObject:button];
            [self.buttonInfoDict setObject:otherArray forKey:@"RIButtonItemType_Other"];
        }
            break;
            
        default:
            break;
    }
}

- (void)showInView:(UIView *)view
{
    [self showIOS8ViewWithType:BOAlertControllerType_ActionSheet];
}

- (void)show
{
    [self showIOS8ViewWithType:BOAlertControllerType_AlertView];
}

- (void)showIOS8ViewWithType:(BOAlertControllerType)viewType
{
    if (self.inViewController == nil) {
        return;
    }
    
    UIAlertController *alertController = nil;
    switch (viewType) {
        case BOAlertControllerType_AlertView:
        {
            alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleAlert];
        }
            break;
        case BOAlertControllerType_ActionSheet:
        {
            alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleActionSheet];
        }
            break;
            
        default:
            break;
    }
    
    RIButtonItem *cancelItem = self.buttonInfoDict[@"RIButtonItemType_Cancel"];
    if (cancelItem != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelItem.label style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (cancelItem.action != nil) {
                cancelItem.action();
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    RIButtonItem *destructiveItem = self.buttonInfoDict[@"RIButtonItemType_Destructive"];
    if (destructiveItem != nil) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveItem.label style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (destructiveItem.action != nil) {
               destructiveItem.action();
            }
        }];
        [alertController addAction:destructiveAction];
    }
    
    NSArray *otherItems = self.buttonInfoDict[@"RIButtonItemType_Other"];
    if (otherItems != nil && otherItems.count > 0) {
        for (RIButtonItem *buttonItem in otherItems) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:buttonItem.label style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (buttonItem.action != nil) {
                    buttonItem.action();
                }
            }];
            [alertController addAction:otherAction];
        }
    }
    
    [self.inViewController presentViewController:alertController animated:YES completion:nil];
}

@end
