//
//  HDFeedBackViewController.m
//  HongDoctor
//
//  Created by wanglei on 2017/2/11.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDFeedBackViewController.h"
#import "HDImageManager.h"
#import "HDUserManager.h"
#import "HDUserEntity.h"

@interface HDFeedBackViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *imageSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation HDFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigation];
    [self setupImageViews];
    [self refreshImageViews];
    [self addGesture];
    [self.textView becomeFirstResponder];
    [self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setupNavigation
{
    self.navigationItem.title = @"设置";
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupImageViews
{
    for (UIImageView *imageView in self.imageViewArray) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;
    }
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToTextViewChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.textView action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)refreshImageViews
{
    for (UIImageView *imageView in self.imageViewArray) {
        NSInteger tag = imageView.tag;
        if (self.imagesArray.count > tag) {
            imageView.image = [HDImageManager getImageWithName:self.imagesArray[tag]];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.hidden = NO;
        } else if (self.imagesArray.count == tag) {
            imageView.image = [UIImage imageNamed:@"FeedBack_add"];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.hidden = NO;
        } else {
            imageView.hidden = YES;
        }
    }
    
    if (self.imagesArray.count > 0) {
        self.imageSignLabel.hidden = YES;
    } else {
        self.imageSignLabel.hidden = NO;
    }
}

#pragma -mark responds

- (void)respondsToBackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)respondsToCommitButton:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length <= 0 && self.imagesArray.count <= 0) {
        BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:@"请输入反馈的内容" viewController:self];
        RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定"];
        [alert addButton:okItem type:RIButtonItemType_Other];
        [alert show];
        return;
    }
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *newText = [text stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    ShowLoading(@"数据加载中");
    [HDUserManager requestToSendFeedBack:userEntity.userGuid message:newText images:self.imagesArray completeBlock:^(BOOL succeed) {
        RemoveLoading;
        ShowText(@"反馈发送成功", 1);
    }];
}

- (void)selectorToTextViewChange
{
    NSString *string = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
    
    if (string.length >= 400) {
        self.countLabel.text = @"0";
        NSString *newStr = [string substringWithRange:NSMakeRange(0, 400)];
        self.textView.text = newStr;
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%lu", 400 - string.length];
    }
}

- (void)respondsToTapGesture:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    UIImageView *imageView = (UIImageView *)gesture.view;
    if (imageView.tag == self.imagesArray.count) {
        [self takePhoto];
    } else {
        [self deletePhoto:imageView.tag];
    }
}

- (void)takePhoto
{
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:nil message:nil viewController:self];
    RIButtonItem *camera = [RIButtonItem itemWithLabel:@"拍照" action:^{
        [self presentImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addButton:camera type:RIButtonItemType_Other];
    RIButtonItem *library = [RIButtonItem itemWithLabel:@"相册" action:^{
        [self presentImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alert addButton:library type:RIButtonItemType_Other];
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    [alert addButton:cancel type:RIButtonItemType_Other];
    [alert showInView:self.view];
}

- (void)presentImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        imagePicker.sourceType = sourceType;
    } else {
        ShowText(@"相机不可用", 1);
        return;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)deletePhoto:(NSInteger)index
{
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:nil message:nil viewController:self];
    RIButtonItem *deleteItem = [RIButtonItem itemWithLabel:@"删除" action:^{
        [self.imagesArray removeObjectAtIndex:index];
        [self refreshImageViews];
    }];
    [alert addButton:deleteItem type:RIButtonItemType_Other];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:nil];
    [alert addButton:cancelItem type:RIButtonItemType_Other];
    [alert showInView:self.view];
}


#pragma -mark imagePickerView delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(editImage, 0.4);
    NSString *imageName = [HDImageManager saveImageWithData:data];
    [self.imagesArray addObject:imageName];
    [self refreshImageViews];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma -mark data

- (NSMutableArray *)imagesArray
{
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

@end
