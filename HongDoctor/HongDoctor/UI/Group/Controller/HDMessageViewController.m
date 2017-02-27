//
//  HDMessageViewController.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageViewController.h"
#import "HDGroupMembersViewController.h"
#import "HDLocationViewController.h"
#import "HDTabBarController.h"
#import "HDGroupViewController.h"
#import "HDScanImageViewController.h"
#import "HDScanLocationViewController.h"
#import "HDForwardViewController.h"
#import "TZImagePickerController.h"
#import "HDUserInfoViewController.h"
#import "HDContractDetailViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "HDMessageTabBarView.h"
#import "HDMessageFaceView.h"
#import "HDMessageOtherView.h"
#import "HDMessageLeftTextCell.h"
#import "HDMessageRightTextCell.h"
#import "HDMessageLeftImageCell.h"
#import "HDMessageRightImageCell.h"
#import "HDMessageLeftAudioCell.h"
#import "HDMessageRightAudioCell.h"
#import "HDMessageLeftVideoCell.h"
#import "HDMessageRightVideoCell.h"
#import "HDMessageLeftLocationCell.h"
#import "HDMessageRightLocationCell.h"
#import "HDMessageCellDelegate.h"
#import "AudioRecordingView.h"
#import "AudioRecordCancelView.h"
#import "HDMessageHandleView.h"

#import "HDChatGroupEntity.h"
#import "HDChatMessageEntity.h"
#import "HDChatGroupEntity.h"
#import "HDMessageManager.h"
#import "HDSendMessageEntity.h"
#import "HDUserEntity.h"
#import "HDAudioCellModel.h"
#import "HDMessageCellModel.h"
#import "HDTextCellModel.h"
#import "HDImageCellModel.h"
#import "HDVideoCellModel.h"
#import "HDLocationCellModel.h"
#import "HDSendMsgResponseEntity.h"
#import "HDMemberEntity.h"

#import "HDImageManager.h"
#import "HDCoreDataManager.h"
#import "TimingPlayAudioManager.h"
#import "HDDownloadVideoManager.h"
#import "ExRecorder.h"
#import "TaskUtility.h"
#import "VoiceConverter.h"
#import "GWEncodeHelper.h"
#import "HDVideoTransform.h"
#import "HDGetIntervalMessageManager.h"
#import "HDAutoServerManager.h"
#import "HLBarButtonItem.h"
#import <Realm/Realm.h>


@interface HDMessageViewController () <UITableViewDelegate, UITableViewDataSource, HDMessageTabBarViewDelegate, HDMessageFaceViewDelegate, HDMessageOtherViewDelegate, HDMessageCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, HDMessageHandleViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) HDMessageTabBarView       *tabBarView;
@property (nonatomic, strong) HDMessageFaceView         *faceView;
@property (nonatomic, strong) HDMessageOtherView        *otherView;
@property (nonatomic, strong) HDMessageHandleView       *handleView;
@property (nonatomic, strong) HDUserEntity              *userEntity;
@property (nonatomic, assign) BOOL                      isShowFace;
@property (nonatomic, assign) BOOL                      isShowOther;
@property (nonatomic, assign) BOOL                      isTextFieldEdit;
@property (nonatomic, strong) NSString                  *baseURLStr;
@property (nonatomic, strong) NSMutableArray            *dataSourceArray;
@property (nonatomic, strong) AVPlayer                  *player;
@property (nonatomic, strong) AVPlayerViewController    *playerView;
@property (nonatomic, strong) UIImagePickerController   *imagePicker;

@property (nonatomic, strong) AudioRecordCancelView     *audioRecordCancelView;
@property (nonatomic, strong) AudioRecordingView        *audioRecordingView;
@property (nonatomic, strong) ExRecorder                *recorder;
@property (nonatomic, strong) NSString                  *audioRecordFilePath;
@property (nonatomic, assign) NSTimeInterval            recordTime;
@property (nonatomic, assign) BOOL                      isCancelRecording;
@property (nonatomic, strong) NSTimer                   *timer;
@property (nonatomic, strong) NSMutableArray            *membersArray;
@property (nonatomic, strong) HDMessageCellModel        *selectModel;
@property (nonatomic, strong) HDAudioCellModel          *playAudioModel;
@property (nonatomic, strong) NSMutableArray            *scanImageArray;

@end

@implementation HDMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self registerNotification];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[HDGetIntervalMessageManager shareInstance] stopGetMessage];
    [self startGetIntervalData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView scrollToBottom:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [[TimingPlayAudioManager shareManager] stopPlayAudio];
    [[HDGetIntervalMessageManager shareInstance] startGetMessage];
}


#pragma -mark setupUI

- (void)setupUI
{
    [self setupNavigationBar];
    [self setupTableView];
    [self setupFaceView];
    [self setupAddOtherView];
    [self setupTabBarView];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = self.groupName;
    
    NSInteger groupProperty = [self.groupProperty integerValue];
    NSString *imagName = groupProperty != 3 ? @"Message_member_s.png": @"Message_member_d.png";
    UIImage *image = [UIImage imageNamed:imagName];
    UIBarButtonItem *rightBarButton = [[HLBarButtonItem alloc] initWithImage:image target:self action:@selector(respondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    HLBarButtonItem *leftItem = [[HLBarButtonItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"Main_back"] target:self action:@selector(respondsToBackItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTabBarView
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    self.tabBarView = [[HDMessageTabBarView alloc] initWithFrame:CGRectMake(0, height - 50 - 64, width, 50)];
    self.tabBarView.delegate = self;
    [self.view addSubview:self.tabBarView];
    
    [self.view bringSubviewToFront:self.tabBarView];
}

- (void)setupTableView
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGRect rect = CGRectMake(0, 0, width, height - 50 - 64);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    UINib *leftText = [UINib nibWithNibName:@"HDMessageLeftTextCell" bundle:[NSBundle mainBundle]];
    UINib *leftImage = [UINib nibWithNibName:@"HDMessageLeftImageCell" bundle:[NSBundle mainBundle]];
    UINib *leftAudio = [UINib nibWithNibName:@"HDMessageLeftAudioCell" bundle:[NSBundle mainBundle]];
    UINib *leftVideo = [UINib nibWithNibName:@"HDMessageLeftVideoCell" bundle:[NSBundle mainBundle]];
    UINib *leftLocation = [UINib nibWithNibName:@"HDMessageLeftLocationCell" bundle:[NSBundle mainBundle]];
    UINib *rightText = [UINib nibWithNibName:@"HDMessageRightTextCell" bundle:[NSBundle mainBundle]];
    UINib *rightImage = [UINib nibWithNibName:@"HDMessageRightImageCell" bundle:[NSBundle mainBundle]];
    UINib *rightAudio = [UINib nibWithNibName:@"HDMessageRightAudioCell" bundle:[NSBundle mainBundle]];
    UINib *rightVideo = [UINib nibWithNibName:@"HDMessageRightVideoCell" bundle:[NSBundle mainBundle]];
    UINib *rightLocation = [UINib nibWithNibName:@"HDMessageRightLocationCell" bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:leftText forCellReuseIdentifier:@"HDMessageLeftTextCell"];
    [self.tableView registerNib:leftImage forCellReuseIdentifier:@"HDMessageLeftImageCell"];
    [self.tableView registerNib:leftAudio forCellReuseIdentifier:@"HDMessageLeftAudioCell"];
    [self.tableView registerNib:leftVideo forCellReuseIdentifier:@"HDMessageLeftVideoCell"];
    [self.tableView registerNib:leftLocation forCellReuseIdentifier:@"HDMessageLeftLocationCell"];
    [self.tableView registerNib:rightText forCellReuseIdentifier:@"HDMessageRightTextCell"];
    [self.tableView registerNib:rightImage forCellReuseIdentifier:@"HDMessageRightImageCell"];
    [self.tableView registerNib:rightAudio forCellReuseIdentifier:@"HDMessageRightAudioCell"];
    [self.tableView registerNib:rightVideo forCellReuseIdentifier:@"HDMessageRightVideoCell"];
    [self.tableView registerNib:rightLocation forCellReuseIdentifier:@"HDMessageRightLocationCell"];
}

- (void)setupFaceView
{
    CGFloat interval = ([[UIScreen mainScreen] bounds].size.width - 30 * 8)/9.0;
    CGRect rect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, interval * 3 + 30 * 3 + 40);
    self.faceView = [[HDMessageFaceView alloc] initWithFrame:rect];
    self.faceView.itemSideLength = 30;
    self.faceView.itemInterval = interval;
    self.faceView.delegate = self;
    [self.view addSubview:self.faceView];
}

- (void)setupAddOtherView
{
    self.otherView = [[HDMessageOtherView alloc] initWithFrame:self.faceView.frame];
    self.otherView.delegate = self;
    [self.view addSubview:self.otherView];
}

#pragma -mark register Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToKeyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToChatGroupChange:) name:@"HDMessageChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToGroupNameChange:) name:@"HDGroupNameChangeNotification" object:nil];
}


#pragma -mark responds

- (void)respondsToBackItem
{
    if (self.isPopToGroupVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)respondsToTapGesture
{
    [self.handleView removeFromSuperview];
    if (self.isTextFieldEdit) {
        self.isTextFieldEdit = NO;
        [self.tabBarView textFieldRegisnFirstResponder];
    }
    if (self.isShowFace) {
        self.isShowFace = NO;
        [self showFaceView:NO];
    }
    if (self.isShowOther) {
        self.isShowOther = NO;
        [self showOtherView:NO];
    }
}

- (void)respondsToRightBarButtonItem
{
    HDGroupMembersViewController *membersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDGroupMembersViewController"];
    membersVC.groupGuid = self.groupGuid;
    membersVC.groupName = self.groupName;
    membersVC.backItemTitle = @"会话";
    [self.navigationController pushViewController:membersVC animated:YES];
}

- (void)selectorToKeyBoardChange:(NSNotification *)not
{
    [self.handleView removeFromSuperview];
    NSDictionary *userInfo = not.userInfo;
    NSValue *value = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = value.CGRectValue;
    
    if (rect.origin.y < self.view.frame.size.height) {
        self.isTextFieldEdit = YES;
        if (self.isShowFace) {
            self.isShowFace = NO;
            [self showFaceView:NO];
        }
        if (self.isShowOther) {
            self.isShowOther = NO;
            [self showOtherView:NO];
        }
    }
    
    CGRect tabBarRect = self.tabBarView.frame;
    tabBarRect.origin.y = rect.origin.y - tabBarRect.size.height - 64;
    self.tabBarView.frame = tabBarRect;
    
    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.size.height = tabBarRect.origin.y;
    self.tableView.frame = tableViewRect;
    [self.tableView scrollToBottom:NO];
}

- (void)selectorToChatGroupChange:(NSNotification *)not
{
    NSString *groupGuid = [not.userInfo objectForKey:@"groupGuid"];
    if ([self.groupGuid isEqualToString:groupGuid]) {
        [self getLocalMessages];
    }
}

- (void)selectorToGroupNameChange:(NSNotification *)not
{
    NSString *groupName = [not.userInfo objectForKey:@"groupName"];
    self.navigationItem.title = groupName;
}

#pragma -mark tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDMessageCellModel *model = self.dataSourceArray[indexPath.row];
    switch (model.type) {
        case MessageText:
        {
            if (model.isUserSend) {
                HDMessageRightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageRightTextCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell resetCellWithModel:model];
                return cell;
            } else {
                HDMessageLeftTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageLeftTextCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell resetCellWithModel:model];
                return cell;
            }
        }
            break;
        case MessageImage:
        {
            if (model.isUserSend) {
                HDMessageRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageRightImageCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell resetCellWithModel:model];
                return cell;
            } else {
                HDMessageLeftImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageLeftImageCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell resetCellWithModel:model];
                return cell;
            }
        }
            break;
        case MessageAudio:
        {
            if (model.isUserSend) {
                HDMessageRightAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageRightAudioCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                cell.delegate = self;
                return cell;
            } else {
                HDMessageLeftAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageLeftAudioCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                cell.delegate = self;
                return cell;
            }
        }
            break;
        case MessageVideo:
        {
            if (model.isUserSend) {
                HDMessageRightVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageRightVideoCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                cell.delegate = self;
                return cell;
            } else {
                HDMessageLeftVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageLeftVideoCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                cell.delegate = self;
                return cell;
            }
        }
            break;
        case MessageLocation:
        {
            if (model.isUserSend) {
                HDMessageRightLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageRightLocationCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell resetCellWithModel:model];
                return cell;
            } else {
                HDMessageLeftLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMessageLeftLocationCell" forIndexPath:indexPath];
                [cell resetCellWithModel:model];
                cell.delegate = self;
                return cell;
            }
            break;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    HDMessageCellModel *model = self.dataSourceArray[indexPath.row];
    switch (model.type) {
        case MessageText:
        {
            return UITableViewAutomaticDimension;
        }
            break;
        case MessageImage:
        {
            return 233;
        }
            break;
        case MessageAudio:
        {
            return 95;
        }
            break;
        case MessageVideo:
        {
            return 233;
        }
            break;
        case MessageLocation:
        {
            return 178;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDMessageCellModel *model = self.dataSourceArray[indexPath.row];
    if (model.type == MessageText) {
        return 95;
    }
    return 178;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.handleView removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.handleView removeFromSuperview];
//    [self.view endEditing:YES];
}


#pragma -mark gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *class = NSStringFromClass([touch.view class]);
    if ([class isEqualToString:@"UITableViewCellContentView"] || [class isEqualToString:@"UITableView"]) {
        return YES;
    }
    return NO;
}


#pragma -mark cellDelegate

- (void)didClickToPlayVideo:(HDMessageCellModel *)model
{
    [self.handleView removeFromSuperview];
    HDVideoCellModel *cellModel = (HDVideoCellModel *)model;
    NSString *videoName = [GWEncodeHelper md5:cellModel.videoURL];
    NSString *localPath = [TaskUtility pathForAttachmentVideoFile:[NSString stringWithFormat:@"%@.mp4", videoName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        
        NSURL *url = [NSURL fileURLWithPath:localPath];
        AVPlayerViewController *player = [[AVPlayerViewController alloc]init];
        player.player = [[AVPlayer alloc]initWithURL:url];
        [self presentViewController:player animated:YES completion:nil];
    } else {
        ShowLoading(@"数据加载中...");
        [[HDDownloadVideoManager shareManager] uploadVideoWithURL:cellModel.videoURL completeBlock:^(BOOL succeed, NSString *path) {
            RemoveLoading;
            if (succeed) {
                NSURL *url = [NSURL fileURLWithPath:localPath];
                AVPlayerViewController *player = [[AVPlayerViewController alloc]init];
                player.player = [[AVPlayer alloc]initWithURL:url];
                [self presentViewController:player animated:YES completion:nil];
            } else {
                ShowText(@"网络加载失败，请重试", 2);
            }
        }];
    }
}

- (void)didClickToPlayAudio:(HDMessageCellModel *)model stauts:(E_AudioStatus)status
{
    [self.handleView removeFromSuperview];
    HDAudioCellModel *cellModel = (HDAudioCellModel *)model;
    
    if ([self.playAudioModel.messageGuid isEqualToString:cellModel.messageGuid] && status == E_AudioStatus_Play) {
        [[TimingPlayAudioManager shareManager] stopPlayAudio];
        return;
    }
    if (![self.playAudioModel.messageGuid isEqualToString:cellModel.messageGuid]) {
        [[TimingPlayAudioManager shareManager] stopPlayAudio];
    }
    self.playAudioModel = cellModel;
    [HDLocalDataManager saveHasReadAudioGuid:cellModel.messageGuid];
    if (cellModel.sendType == MessageSending) {
        NSString *audioName = [self randomAudioName];
        NSString *pathForWav = [TaskUtility pathForAttachmentAudioFile:[NSString stringWithFormat:@"%@.wav", audioName]];
        [VoiceConverter amrToWav:cellModel.audioURL wavSavePath:pathForWav];
        [[TimingPlayAudioManager shareManager] playAudioWithLocalPath: pathForWav];
    } else {
        [[TimingPlayAudioManager shareManager] playAudioWithUrl:cellModel.audioURL messageId:cellModel.messageGuid groupId:self.groupGuid];
    }
}

- (void)didClickToReSendMessage:(HDMessageCellModel *)model
{
    [self.handleView removeFromSuperview];
    NSDictionary *dict = @{@"HDMsgGuid": model.messageGuid};
    [self postNotificationWhenSending:dict];
    switch (model.type) {
        case MessageText:
            [self requestToSendText:(HDTextCellModel *)model];
            break;
        case MessageImage:
            [self requestToSendImage:(HDImageCellModel *)model];
            break;
        case MessageAudio:
            [self requestToSendAudio:(HDAudioCellModel *)model];
            break;
        case MessageVideo:
            [self requestToSendVideo:(HDVideoCellModel *)model];
            break;
        case MessageLocation:
            [self requestToSendLocation:(HDLocationCellModel *)model];
            break;
        default:
            break;
    }
}

- (void)didClickToPressCell:(UITableViewCell *)cell messsage:(HDMessageCellModel *)model
{
    self.selectModel = model;
    [self.handleView removeFromSuperview];
    
    
    NSInteger index = [self.dataSourceArray indexOfObject:model];
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    CGRect superRect = [self.tableView convertRect:rect toView:self.view];
    
    NSArray *itemTypes = nil;
    CGRect handleFrame = CGRectZero;
    handleFrame.origin.y = superRect.origin.y - 5;
    handleFrame.size.height = 35;
    if (model.type == MessageText) {
        handleFrame.size.width = 182;
        itemTypes = @[@(HandleItemCopy), @(HandleItemForward), @(HandleItemDelete)];
    } else {
        handleFrame.size.width = 121;
        itemTypes = @[@(HandleItemForward), @(HandleItemDelete)];
    }
    if (model.isUserSend) {
        handleFrame.origin.x = superRect.size.width - handleFrame.size.width - 45;
    } else {
        handleFrame.origin.x = 45;
    }
    
    self.handleView = [[HDMessageHandleView alloc] initWithFrame:handleFrame itemTypes:itemTypes];
    self.handleView.delegate = self;
    [self.view addSubview:self.handleView];
}

- (void)deleteLocalMessage:(NSString *)messageGuid
{
    [HDCoreDataManager deleteChatMessage:self.groupGuid messageId:messageGuid];
    for (HDMessageCellModel *model in self.dataSourceArray) {
        if ([model.messageGuid isEqualToString:messageGuid]) {
            [self.dataSourceArray removeObject:model];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)didClickToScanImage:(HDMessageCellModel *)model
{
    [self.handleView removeFromSuperview];
    HDImageCellModel *cellModel = (HDImageCellModel *)model;
    HDScanImageViewController *scanImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDScanImageViewController"];
    scanImageVC.backItemTitle = @"会话";
    scanImageVC.imageArray = self.scanImageArray;
    scanImageVC.currentIndex = [self.scanImageArray indexOfObject:cellModel.scanImageURL];
    [self.navigationController pushViewController:scanImageVC animated:NO];
}

- (void)didClickToScanLocation:(HDMessageCellModel *)model
{
    [self.handleView removeFromSuperview];
    HDLocationCellModel *cellModel = (HDLocationCellModel *)model;
    HDScanLocationViewController *scanLocationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDScanLocationViewController"];
    scanLocationVC.latitude = cellModel.latitude;
    scanLocationVC.longitude = cellModel.longitude;
    scanLocationVC.backItemTitle = @"会话";
    [self.navigationController pushViewController:scanLocationVC animated:YES];
}

- (void)didClickHeadImage:(HDMessageCellModel *)model
{
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    if ([userEntity.userGuid isEqualToString:model.senderGuid]) {
        HDUserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDUserInfoViewController"];
        userInfoVC.backItemTitle = @"群消息";
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else {
        HDContractDetailViewController *contractDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDContractDetailViewController"];
        contractDetailVC.contractGuid = model.senderGuid;
        contractDetailVC.backItemTitle = @"群信息";
        [self.navigationController pushViewController:contractDetailVC animated:YES];
    }
}

#pragma -mark faceViewDelegate

- (void)didSelectIndexFace:(NSInteger)index
{
    NSString *string = [NSString stringWithFormat:@"<img src=\"%ld\"/>", (long)index];
    NSString *imageName = [NSString stringWithFormat:@"f_static_%ld", (long)index];
    UIImage *image = [UIImage imageNamed:imageName];
    
    EmojiTextAttachment *attactment = [[EmojiTextAttachment alloc] init];
    attactment.emojiTag = string;
    attactment.image = image;
    
    //Set emoji size
    attactment.emojiSize = CGSizeMake(16, 16);
    [self.tabBarView insertAttachment:attactment];
}

- (void)didSelectDelete
{
    [self.tabBarView deleteLastAttachment];
}

#pragma -mark otherView delegate

- (void)didSelectView:(HDMessageOtherView *)view optionIndex:(NSInteger)index
{
    [self respondsToTapGesture];
    if (index == 3) {
        [self getLocation];
        return;
    }
    if (index == 1) {
        [self getPhoto];
        return;
    }
    self.imagePicker = [[UIImagePickerController alloc]init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    if (index == 0) {
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    } else if (index == 2) {
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        NSInteger maxVideoDuration = [HDLocalDataManager getVideoRecordLength];
        self.imagePicker.videoMaximumDuration = maxVideoDuration;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)getLocation
{
    [self.handleView removeFromSuperview];
    HDLocationViewController *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDLocationViewController"];
    locationVC.backItemTitle = @"会话";
    [self.navigationController pushViewController:locationVC animated:YES];
    locationVC.locationComplete = ^(NSString *address, double latitude, double longitude, NSString *imageName) {
        [self sendLocationWithAddress:address latitude:latitude longitude:longitude imageName:imageName];
    };
}

- (void)getPhoto
{
//    self.imagePicker = [[UIImagePickerController alloc]init];
//    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    self.imagePicker.allowsEditing = YES;
//    self.imagePicker.delegate = self;
//    [self presentViewController:self.imagePicker animated:YES completion:nil];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.isSelectOriginalPhoto = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma -mark handlerView delegate

- (void)didSelectItemWithType:(HandleItemType)type
{
    switch (type) {
        case HandleItemCopy:
            [self didSelectToCopyMessage];
            break;
        case HandleItemForward:
            [self didSelectToForward];
            break;
        case HandleItemDelete:
            [self didSelectToDelete];
            break;
        default:
            break;
    }
}

- (void)didSelectToCopyMessage
{
    [self.handleView removeFromSuperview];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    HDTextCellModel *cellModel = (HDTextCellModel *)self.selectModel;
    pasteboard.string = cellModel.text;
}

- (void)didSelectToDelete
{
    [self.handleView removeFromSuperview];
    BOAlertController *alert = [[BOAlertController alloc] initWithTitle:@"提示" message:@"是否删除此消息" viewController:self];
    RIButtonItem *item = [RIButtonItem itemWithLabel:@"确定" action:^{
        if (self.selectModel.sendType == MessageSendFailed) {
            [self deleteLocalMessage:self.selectModel.messageGuid];
            return;
        }
        [HDMessageManager requestDeleteMessage:self.userEntity.userGuid messageId:self.selectModel.messageGuid completeBlock:^(BOOL succeed) {
            if (succeed) {
                [self deleteLocalMessage:self.selectModel.messageGuid];
            }
        }];
    }];
    [alert addButton:item type:RIButtonItemType_Other];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:nil];
    [alert addButton:cancelItem type:RIButtonItemType_Cancel];
    [alert show];
}
- (void)didSelectToForward
{
    [self.handleView removeFromSuperview];
    HDForwardViewController *forwardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HDForwardViewController"];
    forwardVC.messageGuid = self.selectModel.messageGuid;
    [self.navigationController pushViewController:forwardVC animated:YES];
}


#pragma -mark TZImagePickerController delegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    for (UIImage *image in photos) {
        NSData *data = UIImageJPEGRepresentation(image, 0.6);
        NSString *imageName = [HDImageManager saveImageWithData:data];
        [self sendImageMsgWithName:imageName];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self showOtherView:NO];
    }];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self showOtherView:NO];
    }];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self showOtherView:NO];
    }];
}


#pragma -mark ImagePicker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSData *data = UIImageJPEGRepresentation(image, 0.6);
        NSString *imageName = [HDImageManager saveImageWithData:data];
        [self sendImageMsgWithName:imageName];
        
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [self randomAudioName]];
        NSString *videoPath = [TaskUtility pathForAttachmentVideoFile:videoName];
        [HDVideoTransform tranformMov:url toMp4:videoPath completeBlock:^(BOOL succeed) {
            [self sendVideoWithPath:videoPath];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self showOtherView:NO];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self showOtherView:NO];
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self sendVideoWithPath:videoPath];
}

- (void)sendImageMsgWithName:(NSString *)imageName
{
    HDImageCellModel *model = [[HDImageCellModel alloc] init];
    model.isUserSend = YES;
    model.imageURL = imageName;
    model.senderHeadURL = self.userEntity.userHeadURL;
    model.messageGuid = @"";
    model.sendType = MessageSending;
    model.messageGuid = [self messageRandomGuid];
    model.messageTime = [[NSDate date] string];
    model.isCompany = self.userEntity.isCompany;
    model.senderName = self.userEntity.userName;
    model.senderGuid = self.userEntity.userGuid;
    [self.dataSourceArray addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToBottom:NO];
    [self requestToSendImage:model];
}

- (void)sendVideoWithPath:(NSString *)path
{
    HDVideoCellModel *model = [[HDVideoCellModel alloc] init];
    model.isUserSend = YES;
    model.videoURL = path;
    model.contentImageURL = @"";
    model.senderHeadURL = self.userEntity.userHeadURL;
    model.messageGuid = @"";
    model.sendType = MessageSending;
    model.messageGuid = [self messageRandomGuid];
    model.messageTime = [[NSDate date] string];
    model.isCompany = self.userEntity.isCompany;
    model.senderName = self.userEntity.userName;
    model.senderGuid = self.userEntity.userGuid;
    [self.dataSourceArray addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToBottom:NO];
    [self requestToSendVideo:model];
}

- (void)sendLocationWithAddress:(NSString *)address latitude:(double)latitude longitude:(double)longitude imageName:(NSString *)imageName
{
    HDLocationCellModel *model = [[HDLocationCellModel alloc] init];
    model.isUserSend = YES;
    model.address = address;
    model.latitude = latitude;
    model.longitude = longitude;
    model.contentImageURL = imageName;
    model.senderHeadURL = self.userEntity.userHeadURL;
    model.messageGuid = @"";
    model.sendType = MessageSending;
    model.messageGuid = [self messageRandomGuid];
    model.messageTime = [[NSDate date] string];
    model.isCompany = self.userEntity.isCompany;
    model.senderName = self.userEntity.userName;
    model.senderGuid = self.userEntity.userGuid;
    [self.dataSourceArray addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToBottom:NO];
    
    [self requestToSendLocation:model];
}

#pragma -mark tabBarView delegate

- (void)didSelectToChangeToVideo
{
    [self respondsToTapGesture];
}

- (void)didSelectToChangeInputFace
{
    [self.handleView removeFromSuperview];
    if (self.isShowFace) {
        self.isShowFace = NO;
        [self showFaceView:NO];
        self.isTextFieldEdit = YES;
        [self.tabBarView textFieldBecomeFirstResponder];
    } else {
        self.isShowFace = YES;
        if (self.isTextFieldEdit) {
            self.isTextFieldEdit = NO;
            [self.tabBarView textFieldRegisnFirstResponder];
        }
        if (self.isShowOther) {
            self.isShowOther = NO;
            [self showOtherView:NO];
        }
        [self showFaceView:YES];
    }
}

- (void)didSelectToInputOther
{
    [self.handleView removeFromSuperview];
    if (self.isShowOther) {
        self.isShowOther = NO;
        [self showOtherView:NO];
        self.isTextFieldEdit = YES;
        [self.tabBarView textFieldBecomeFirstResponder];
    } else {
        self.isShowOther = YES;
        if (self.isTextFieldEdit) {
            self.isTextFieldEdit = NO;
            [self.tabBarView textFieldRegisnFirstResponder];
        }
        if (self.isShowFace) {
            self.isShowFace = NO;
            [self showFaceView:NO];
        }
        [self showOtherView:YES];
    }
}

- (void)showFaceView:(BOOL)isShow
{
    CGRect faceRect = self.faceView.frame;
    if (isShow) {
        faceRect.origin.y = self.view.frame.size.height - faceRect.size.height;
    } else {
        faceRect.origin.y = self.view.frame.size.height;
    }
    self.faceView.frame = faceRect;
    
    CGRect taBarRect = self.tabBarView.frame;
    taBarRect.origin.y = faceRect.origin.y - taBarRect.size.height;
    self.tabBarView.frame = taBarRect;
    
    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.size.height = taBarRect.origin.y;
    self.tableView.frame = tableViewRect;
    [self.tableView scrollToBottom:NO];
}

- (void)showOtherView:(BOOL)isShow
{
    CGRect rect = self.otherView.frame;
    if (isShow) {
        rect.origin.y = self.view.frame.size.height - rect.size.height;
    } else {
        rect.origin.y = self.view.frame.size.height;
    }
    self.otherView.frame = rect;
    CGRect taBarRect = self.tabBarView.frame;
    taBarRect.origin.y = rect.origin.y - taBarRect.size.height;
    self.tabBarView.frame = taBarRect;
    
    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.size.height = taBarRect.origin.y;
    self.tableView.frame = tableViewRect;
    [self.tableView scrollToBottom:NO];
}

- (void)didSelectToSendMessage:(NSString *)text
{
    [self respondsToTapGesture];
    HDTextCellModel *model = [[HDTextCellModel alloc] init];
    model.isUserSend = YES;
    model.text = text;
    model.senderHeadURL = self.userEntity.userHeadURL;
    model.messageGuid = @"";
    model.sendType = MessageSending;
    model.messageGuid = [self messageRandomGuid];
    model.messageTime = [[NSDate date] string];
    model.isCompany = self.userEntity.isCompany;
    model.senderName = self.userEntity.userName;
    model.senderGuid = self.userEntity.userGuid;
    [self.dataSourceArray addObject:model];
//    [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.dataSourceArray count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self.tableView scrollToBottom:NO];
    [self requestToSendText:model];
}

- (void)respondsToAudioButtonTouchDown
{
    [[TimingPlayAudioManager shareManager] stopPlayAudio];
    [self showRecordingView];
    [self startRecord];
}
- (void)respondsToAudioButtonDragOutside
{
    [self showRecordCancelView];
}
- (void)respondsToAudioButtonDragEnter
{
    [self showRecordingView];
}
- (void)respondsToAudioButtonTouchUpInside
{
    [self performSelector: @selector(stopRecord) withObject: nil afterDelay: 0.3f];
}
- (void)respondsToAudioButtonTouchUpOutside
{
    if (_audioRecordCancelView && [_audioRecordCancelView superview])
    {
        [self cancelRecord];
    }
    else {
        [self stopRecord];
        [self sendAudio];
    }
    [self removeRecordingView];
    [self removeRecordCancelView];
}

#pragma -mark loadData

- (void)loadData
{
    self.userEntity = [HDLocalDataManager getUserEntity];
    self.baseURLStr = [HDLocalDataManager getBaseURLString];
    [self getLocalMessages];
}

- (void)startGetIntervalData
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(selectorToGetMessages) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }

}

- (void)getLocalMessages
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    self.scanImageArray = [NSMutableArray array];
    RLMResults *messages = [HDCoreDataManager getGroupChatMessage:self.groupGuid];
    for (int i = 0; i < messages.count; i ++) {
        HDChatMessageEntity * obj = [messages objectAtIndex:i];
        HDMessageCellModel *model = [HDMessageCellModel cellModelWithEntity:obj];
        HDMemberEntity *entity = [self memberEntityWithMemberGuid:obj.senderGuid];
        model.isCompany = [entity.isCompany boolValue];
        model.senderHeadURL = entity.userHeadURL;
        model.senderName = entity.userName;
        model.senderGuid = entity.userGuid;
        if (model) {
            [self.dataSourceArray addObject:model];
        }
        if (model.type == MessageImage && obj.messageLength != nil) {
            [self.scanImageArray addObject:obj.messageLength];
        }
    }
    [self.tableView reloadData];
    [self.tableView scrollToBottom:NO];
}

- (HDMemberEntity *)memberEntityWithMemberGuid:(NSString *)memberGuid
{
    for (HDMemberEntity *entity in self.membersArray) {
        if ([entity.userGuid isEqualToString:memberGuid]) {
            return entity;
        }
    }
    
    HDMemberEntity *entity = [HDCoreDataManager getAddressBookWithId:memberGuid];
    [self.membersArray addObject:entity];
    return entity;
}

- (NSMutableArray *)membersArray
{
    if (_membersArray == nil) {
        _membersArray = [NSMutableArray array];
    }
    return _membersArray;
}

- (void)selectorToGetMessages
{
    [HDMessageManager requestGetIntervalMessage:self.userEntity.userGuid groupGuid:self.groupGuid completeBlock:^(BOOL succeed) {
        if (succeed) {
            [self getLocalMessages];
        }
    }];
}


#pragma -mark record

- (void)startRecord
{
    if (YES)
    {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
            {
                [self cancelRecord];
                
                BOAlertController *popView = [[BOAlertController alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许随办访问你的麦克风。" viewController:self];
                
                RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:^{
                }];
                [popView addButton:okItem type:RIButtonItemType_Other];
                [popView show];
                return;
            }
                
            default:
                break;
        }
    }
    
    if (nil == self.recorder)
    {
        self.recorder = [ExRecorder recorder];
    }
    
    NSString *audioFileName = [NSString stringWithFormat:@"%@.wav", [self randomAudioName]];
    NSString *recorderFilePath = [TaskUtility pathForAttachmentFiles:audioFileName inTalk:self.groupGuid];
    self.audioRecordFilePath = recorderFilePath;
    
    NSString* fileName = [[self.audioRecordFilePath lastPathComponent] stringByDeletingPathExtension];
    NSString* pathForAmr = [TaskUtility pathForAttachmentFiles:[NSString stringWithFormat:@"%@.amr", fileName] inTalk:self.groupGuid];
    
    self.recorder.tmpAudioFilePath = self.audioRecordFilePath;
    self.recorder.outputAudioFilePath = pathForAmr;
    
    [self.recorder registerSuccessCallback:^(NSString *filePath, CGFloat duration) {
        [self removeRecordView];
        self.recordTime = duration;
        [self sendAudioWithFile: filePath];
    } failedCallback:^{
        [self cancelRecord];
    } updateCallback:^(CGFloat power) {
        [self updatePower: power];
    }willStopCallback: nil];
    
    [self.recorder startRecord];
}

- (void)cancelRecord
{
    [self removeRecordView];
    self.isCancelRecording = YES;
    
    [self.recorder cancelRecord];
    
    // delete audio file
    [[NSFileManager defaultManager] removeItemAtPath:self.audioRecordFilePath error:nil];
    self.audioRecordFilePath = nil;
}


- (void)stopRecord
{
    [self.recorder stopRecord];
    [self removeRecordView];
}

- (void)showRecordingView
{
    [self removeRecordCancelView];
    if (_audioRecordingView == nil)
    {
        _audioRecordingView = [[[NSBundle mainBundle] loadNibNamed:@"AudioRecordingView"
                                                             owner:self
                                                           options:nil]
                               objectAtIndex:0];
        CGRect rect = self.view.bounds;
        rect.size.height = rect.size.height - 50 - 64;
        _audioRecordingView.frame = rect;
        [self.view addSubview:_audioRecordingView];
    }
    else
    {
        if (![_audioRecordingView superview])
        {
            [self.view addSubview:_audioRecordingView];
        }
    }
}

- (void)showRecordCancelView
{
    [self removeRecordingView];
    if (_audioRecordCancelView == nil) {
        _audioRecordCancelView = [[[NSBundle mainBundle] loadNibNamed:@"AudioRecordCancelView"
                                                                owner:self
                                                              options:nil]
                                  objectAtIndex:0];
        CGRect rect = self.view.bounds;
        rect.size.height = rect.size.height - 50 - 64;
        _audioRecordCancelView.frame = rect;
        [self.view addSubview:_audioRecordCancelView];
    }
    else {
        if (![_audioRecordCancelView superview]) {
            [self.view addSubview:_audioRecordCancelView];
        }
    }
}


- (void)updatePower: (CGFloat) power
{
    [_audioRecordingView updatePowerWithValue: power];
}

- (void) removeRecordView
{
    [self removeRecordCancelView];
    [self removeRecordingView];
}

- (void)removeRecordCancelView
{
    if (_audioRecordCancelView && [_audioRecordCancelView superview]) {
        [_audioRecordCancelView removeFromSuperview];
        _audioRecordCancelView = nil;
    }
}

- (void)removeRecordingView
{
    if (_audioRecordingView && [_audioRecordingView superview]) {
        [_audioRecordingView removeFromSuperview];
        _audioRecordingView = nil;
    }
}

- (void) sendAudioWithFile: (NSString *) filePath
{
    self.audioRecordFilePath = filePath;
    [self sendAudio];
}

- (void)sendAudio
{
    if ([self.audioRecordFilePath length] > 0)
    {
        HDAudioCellModel *model = [[HDAudioCellModel alloc] init];
        model.isUserSend = YES;
        model.audioURL = self.audioRecordFilePath;
        model.length = [NSString stringWithFormat:@"%2.f", self.recordTime];
        model.senderHeadURL = self.userEntity.userHeadURL;
        model.messageGuid = @"";
        model.sendType = MessageSending;
        model.messageGuid = [self messageRandomGuid];
        model.messageTime = [[NSDate date] string];
        model.isCompany = self.userEntity.isCompany;
        model.senderName = self.userEntity.userName;
        model.senderGuid = self.userEntity.userGuid;
        [self.dataSourceArray addObject:model];
        [self.tableView reloadData];
        [self.tableView scrollToBottom:NO];
        [self requestToSendAudio:model];
    }
}

- (void)postNotificationWhenSending:(NSDictionary *)userInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [dict setObject:@(MessageSending) forKey:@"HDSendType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDMessageSendTypeChange" object:nil userInfo:dict];
}

- (void)postNotificationWhenSendSuccess:(NSDictionary *)userInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [dict setObject:@(MessageSendSuccess) forKey:@"HDSendType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDMessageSendTypeChange" object:nil userInfo:dict];
}

- (void)postNotificationWhenSendFail:(NSDictionary *)userInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [dict setObject:@(MessageSendFailed) forKey:@"HDSendType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDMessageSendTypeChange" object:nil userInfo:dict];
}

- (NSString *)randomAudioName
{
    NSTimeInterval interval = [NSDate date].timeIntervalSince1970;
    return [NSString stringWithFormat:@"%f", interval];
}

- (NSString *)messageRandomGuid
{
    NSTimeInterval interval = [NSDate date].timeIntervalSince1970;
    NSString *guid = [NSString stringWithFormat:@"%f", interval];
    return [GWEncodeHelper md5:guid];
}


#pragma -mark sendMessageRequest

- (void)requestToSendText:(HDTextCellModel *)model
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *text = [model.text stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    HDSendMessageEntity *entity = [[HDSendMessageEntity alloc] init];
    entity.userGuid = self.userEntity.userGuid;
    entity.groupGuid = self.groupGuid;
    entity.gtype = self.groupProperty;
    
    entity.bodytype = @"0";
    entity.mtype = @"1";
    entity.url = self.baseURLStr;
    entity.content = text;
    entity.length = @"0";
    entity.messageGuid = model.messageGuid;
    entity.messageDate = model.messageTime;
    
    [[HDAutoServerManager shareManager] autoSendText:entity completeBlock:^(BOOL succeed, HDSendMsgResponseEntity *responseEntity) {
        if (succeed) {
            entity.messageGuid = responseEntity.msgGuid;
            entity.messageDate = responseEntity.sendDate;
            entity.sendType = MessageSendSuccess;
            [HDCoreDataManager deleteChatMessage:self.groupGuid messageId:model.messageGuid];
            model.messageGuid = responseEntity.msgGuid;
            model.sendType = MessageSendSuccess;
            [self postNotificationWhenSendSuccess: @{@"HDMsgGuid": model.messageGuid}];
        } else {
            entity.sendType = MessageSendFailed;
            model.sendType = MessageSendFailed;
            [self postNotificationWhenSendFail: @{@"HDMsgGuid": model.messageGuid}];
        }
        [HDCoreDataManager saveSendMessage:entity groupGuid:self.groupGuid];
    }];
}

- (void)requestToSendImage:(HDImageCellModel *)model
{
    HDSendMessageEntity *entity = [[HDSendMessageEntity alloc] init];
    entity.userGuid = self.userEntity.userGuid;
    entity.groupGuid = self.groupGuid;
    entity.gtype = self.groupProperty;
    
    entity.bodytype = @"1";
    entity.mtype = @"1";
    entity.url = self.baseURLStr;
    entity.content = model.imageURL;
    entity.length = @"0";
    entity.messageGuid = model.messageGuid;
    entity.messageDate = model.messageTime;
    
    [[HDAutoServerManager shareManager] autoSendImage:entity completeBlock:^(BOOL succeed, HDSendMsgResponseEntity *responseEntity) {
        if (succeed) {
            entity.messageGuid = responseEntity.msgGuid;
            entity.length = responseEntity.length;
            entity.content = responseEntity.content;
            entity.messageDate = responseEntity.sendDate;
            entity.sendType = 2;
            [HDCoreDataManager deleteChatMessage:self.groupGuid messageId:model.messageGuid];
            model.messageGuid = responseEntity.msgGuid;
            model.sendType = MessageSendSuccess;
            model.imageURL = entity.content;
            model.scanImageURL = entity.length;
            [self postNotificationWhenSendSuccess: @{@"HDMsgGuid": model.messageGuid}];
        } else {
            entity.sendType = 1;
            model.sendType = MessageSendFailed;
            [self postNotificationWhenSendFail: @{@"HDMsgGuid": model.messageGuid}];
        }
        [HDCoreDataManager saveSendMessage:entity groupGuid:self.groupGuid];
    }];
}

- (void)requestToSendAudio:(HDAudioCellModel *)model
{
    HDSendMessageEntity *entity = [[HDSendMessageEntity alloc] init];
    entity.userGuid = self.userEntity.userGuid;
    entity.groupGuid = self.groupGuid;
    entity.gtype = self.groupProperty;
    
    entity.bodytype = @"3";
    entity.mtype = @"1";
    entity.url = self.baseURLStr;
    entity.content = self.audioRecordFilePath;
    entity.length = [NSString stringWithFormat:@"%.0f", self.recordTime];
    entity.messageGuid = model.messageGuid;
    entity.messageDate = model.messageTime;
    [[HDAutoServerManager shareManager] autoSendAudio:entity completeBlock:^(BOOL succeed, HDSendMsgResponseEntity *responseEntity) {
        if (succeed) {
            entity.messageGuid = responseEntity.msgGuid;
            entity.content = responseEntity.content;
            entity.messageDate = responseEntity.sendDate;
            entity.sendType = MessageSendSuccess;
            [HDCoreDataManager deleteChatMessage:self.groupGuid messageId:model.messageGuid];
            model.messageGuid = responseEntity.msgGuid;
            model.sendType = MessageSendSuccess;
            [self postNotificationWhenSendSuccess: @{@"HDMsgGuid": model.messageGuid}];
        } else {
            entity.sendType = MessageSendFailed;
            model.sendType = MessageSendFailed;
            [self postNotificationWhenSendFail: @{@"HDMsgGuid": model.messageGuid}];
        }
        [HDCoreDataManager saveSendMessage:entity groupGuid:self.groupGuid];
    }];
}

- (void)requestToSendVideo:(HDVideoCellModel *)model
{
    HDSendMessageEntity *entity = [[HDSendMessageEntity alloc] init];
    entity.userGuid = self.userEntity.userGuid;
    entity.groupGuid = self.groupGuid;
    entity.gtype = self.groupProperty;
    
    entity.bodytype = @"2";
    entity.mtype = @"1";
    entity.url = self.baseURLStr;
    entity.content = model.videoURL;
    entity.length = @"1";
    entity.messageGuid = model.messageGuid;
    entity.messageDate = model.messageTime;

    [[HDAutoServerManager shareManager] autoSendVideo:entity completeBlock:^(BOOL succeed, HDSendMsgResponseEntity *responseEntity) {
        if (succeed) {
            entity.messageGuid = responseEntity.msgGuid;
            entity.content = responseEntity.content;
            entity.length = responseEntity.length;
            entity.messageDate = responseEntity.sendDate;
            entity.sendType = 2;
            model.sendType = MessageSendSuccess;
            [HDCoreDataManager deleteChatMessage:self.groupGuid messageId:model.messageGuid];
            model.messageGuid = responseEntity.msgGuid;
            model.contentImageURL = responseEntity.content;
            [self postNotificationWhenSendSuccess: @{@"HDMsgGuid": model.messageGuid, @"HDContentImageURL": model.contentImageURL}];
        } else {
            entity.sendType = MessageSendFailed;
            model.sendType = MessageSendFailed;
            [self postNotificationWhenSendFail: @{@"HDMsgGuid": model.messageGuid}];
        }
        [HDCoreDataManager saveSendMessage:entity groupGuid:self.groupGuid];
    }];
}

- (void)requestToSendLocation:(HDLocationCellModel *)model
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *newAddress = [model.address stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    NSString *length = [NSString stringWithFormat:@"%f=KHHCLHK=%f=KHHCLHK=%@", model.longitude, model.latitude, newAddress];
    
    HDSendMessageEntity *entity = [[HDSendMessageEntity alloc] init];
    entity.userGuid = self.userEntity.userGuid;
    entity.groupGuid = self.groupGuid;
    entity.gtype = self.groupProperty;
    entity.bodytype = @"4";
    entity.mtype = @"1";
    entity.url = self.baseURLStr;
    entity.content = model.contentImageURL;
    entity.length = length;
    entity.messageGuid = model.messageGuid;
    entity.messageDate = model.messageTime;
    [[HDAutoServerManager shareManager] autoSendLocation:entity completeBlock:^(BOOL succeed, HDSendMsgResponseEntity *responseEntity) {
        if (succeed) {
            entity.messageGuid = responseEntity.msgGuid;
            entity.content = responseEntity.content;
            entity.messageDate = responseEntity.sendDate;
            entity.sendType = MessageSendSuccess;
            model.sendType = MessageSendSuccess;
            [HDCoreDataManager deleteChatMessage:self.groupGuid messageId:model.messageGuid];
            model.messageGuid = responseEntity.msgGuid;
            model.contentImageURL = responseEntity.content;
            [self postNotificationWhenSendSuccess: @{@"HDMsgGuid": model.messageGuid}];
        } else {
            entity.sendType = MessageSendFailed;
            model.sendType = MessageSendFailed;
            [self postNotificationWhenSendFail: @{@"HDMsgGuid": model.messageGuid}];
        }
        [HDCoreDataManager saveSendMessage:entity groupGuid:self.groupGuid];
    }];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
