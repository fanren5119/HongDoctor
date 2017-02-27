//
//  ZGImagePickerManager.m
//  ZiGe
//
//  Created by wanglei on 15/6/12.
//  Copyright (c) 2015年 Yipinapp. All rights reserved.
//

#import "TimingImagePickerManager.h"
#import "HDUserManager.h"
#import "HDModifyUserEntity.h"
#import "HDUserEntity.h"
#import "HDImageManager.h"

static TimingImagePickerManager *pickerManager = nil;

@interface TimingImagePickerManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation TimingImagePickerManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        pickerManager = [[TimingImagePickerManager alloc] init];
    });
    return pickerManager;
}

- (void)imagePickerPresentFromViewController:(UIViewController *)viewController
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:nil message:nil viewController:viewController];
    RIButtonItem *cameraItem = [RIButtonItem itemWithLabel:@"相机" action:^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [viewController presentViewController:imagePick animated:YES completion:nil];
    }];
    [alert addButton:cameraItem type:RIButtonItemType_Other];
    
    RIButtonItem *albumItem = [RIButtonItem itemWithLabel:@"相册" action:^{
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewController presentViewController:imagePick animated:YES completion:nil];
    }];
    [alert addButton:albumItem type:RIButtonItemType_Other];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:nil];
    [alert addButton:cancelItem type:RIButtonItemType_Cancel];
    
    [alert showInView:viewController.view];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    [HDImageManager saveImageWithData:data];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imagName = [HDImageManager imageNameWithData:data];
    HDModifyUserEntity *userEntity = [[HDModifyUserEntity alloc] init];
    HDUserEntity *entity = [HDLocalDataManager getUserEntity];
    userEntity.userGuid = entity.userGuid;
    userEntity.headImageURL = imagName;
    userEntity.type = ModifyHead;
    ShowLoading(@"数据加载中");
    [HDUserManager requestToModifyUser:userEntity completeBlock:^(BOOL succeed, NSString *content) {
        RemoveLoading;
        if (succeed) {
            [[HDDownloadImageManager shareManager] addDownloadUrl:content];
            self.success(imagName);
//            self.userEntity.userName = name;
//            NSString *string = [self.userEntity deserializer];
//            [HDLocalDataManager saveUserWithString:string];
//            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowText(@"网络请求失败，请稍后重试", 2);
        }
    }];
}




@end
