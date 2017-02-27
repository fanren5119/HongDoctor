//
//  HDMessageRightAudioCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageRightAudioCell.h"
#import "HDAudioCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+GIF.h"
#import "ZGAudioManager.h"

@interface HDMessageRightAudioCell ()

@property (weak, nonatomic) IBOutlet UIImageView        *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel            *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageViewWidth;
@property (nonatomic, strong) HDMessageCellModel        *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *sendFailButton;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;
@property (nonatomic, assign) E_AudioStatus stauts;

@end

@implementation HDMessageRightAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSArray *imageArray = @[[UIImage imageNamed:@"audio_play_right_1.png"],
                            [UIImage imageNamed:@"audio_play_right_2.png"],
                            [UIImage imageNamed:@"audio_play_right_3.png"]];
    self.playerImageView.animationImages = imageArray;
    self.playerImageView.animationDuration = 1;
    self.playerImageView.animationRepeatCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToPlayAudioNotification:) name:k_Notification_Playudio object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToMessageSendTypeChange:) name:@"HDMessageSendTypeChange" object:nil];
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPressGesture)];
    [self.contentImageView addGestureRecognizer:longPressGes];
    self.contentImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToHeadTapGesture)];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:headTap];
}

- (void)resetCellWithModel:(HDMessageCellModel *)model
{
    self.model = model;
    HDAudioCellModel *cellModel = (HDAudioCellModel *)model;
    NSInteger length = [cellModel.length integerValue];
    length = MIN(length, 10);
    length = MAX(length, 1);
    self.contentImageViewWidth.constant = length * 20;
    
    NSURL *headImageURL = [NSURL URLWithString:model.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    self.lengthLabel.text = [NSString stringWithFormat:@"%@'", cellModel.length];
    UIImage *image = [UIImage imageNamed:@"Msg_bg_right"];
    self.contentImageView.image = [image resizableImage];
    
    self.timeLabel.text = cellModel.messageTime;
    self.nameLabel.text = cellModel.senderName;
    
    if (cellModel.isCompany == NO) {
        self.senderSignImageView.hidden = NO;
        self.senderSignImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.senderSignImageView.hidden = YES;
    }
    
    [self resetIndicatorView:model.sendType];
}

- (void)selectorToMessageSendTypeChange:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSString *msgGuid = dict[@"HDMsgGuid"];
    if ([msgGuid isEqualToString:self.model.messageGuid]) {
        SendType type = (SendType)[dict[@"HDSendType"] integerValue];
        [self resetIndicatorView:type];
    }
}

- (void)selectorToPlayAudioNotification:(NSNotification *)not
{
    NSString *messageId = [not.userInfo objectForKey:@"messageId"];
    if (![messageId isEqual:self.model.messageGuid]) {
        return;
    }
    self.stauts = (E_AudioStatus)[[not.userInfo objectForKey:@"status"] integerValue];
    if (self.stauts == E_AudioStatus_Play) {
        [self.playerImageView startAnimating];
    } else if (self.stauts == E_AudioStatus_Stop) {
        [self.playerImageView stopAnimating];
    }
}


- (void)resetIndicatorView:(SendType)type
{
    if (type == MessageSending) {
        self.indicatorView.hidden = NO;
        self.sendFailButton.hidden = YES;
        [self.indicatorView startAnimating];
    } else if (type == MessageSendFailed) {
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
        self.sendFailButton.hidden = NO;
    } else {
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
        self.sendFailButton.hidden = YES;
    }
}


- (IBAction)respondsToPlayAudioButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickToPlayAudio:stauts:)]) {
        [self.delegate didClickToPlayAudio:self.model stauts:self.stauts];
    }
}
- (IBAction)respondsToSendFailButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickToReSendMessage:)]) {
        [self.delegate didClickToReSendMessage:self.model];
    }
}

- (void)respondsToLongPressGesture
{
    if ([self.delegate respondsToSelector:@selector(didClickToPressCell:messsage:)]) {
        [self.delegate didClickToPressCell:self messsage:self.model];
    }
}

- (void)respondsToHeadTapGesture
{
    if ([self.delegate respondsToSelector:@selector(didClickHeadImage:)]) {
        [self.delegate didClickHeadImage:self.model];
    }
}

@end
