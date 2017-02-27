//
//  HDMessageLeftAudioCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageLeftAudioCell.h"
#import "HDAudioCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDMessageCellDelegate.h"
#import "ZGAudioManager.h"
#import "UIImage+GIF.h"

@interface HDMessageLeftAudioCell ()

@property (weak, nonatomic) IBOutlet UIImageView        *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel            *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;
@property (nonatomic, strong) HDMessageCellModel        *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) E_AudioStatus stauts;
@property (weak, nonatomic) IBOutlet UIView *noReadSignView;

@end

@implementation HDMessageLeftAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray *imageArray = @[[UIImage imageNamed:@"audio_play_left_1.png"],
                            [UIImage imageNamed:@"audio_play_left_2.png"],
                            [UIImage imageNamed:@"audio_play_left_3.png"]];
    self.playerImageView.animationImages = imageArray;
    self.playerImageView.animationDuration = 1;
    self.playerImageView.animationRepeatCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToPlayAudioNotification:) name:k_Notification_Playudio object:nil];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPressGesture)];
    [self.backgroundImageView addGestureRecognizer:longPressGes];
    self.backgroundImageView.userInteractionEnabled = YES;
    
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
    
    NSURL *headURL = [NSURL URLWithString:model.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    self.lengthLabel.text = [NSString stringWithFormat:@"%@'", cellModel.length];
    UIImage *image = [UIImage imageNamed:@"Msg_bg_left"];
    self.backgroundImageView.image = [image resizableImage];
    
    self.timeLabel.text = cellModel.messageTime;
    self.nameLabel.text = cellModel.senderName;
    
    if (cellModel.isCompany == NO) {
        self.senderSignImageView.hidden = NO;
        self.senderSignImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.senderSignImageView.hidden = YES;
    }
    
    self.noReadSignView.hidden = cellModel.hasRead;
}

- (IBAction)respondsToPlayAudioButton:(id)sender
{
    self.noReadSignView.hidden = YES;
    [self.model setValue:@(YES) forKey:@"hasRead"];
    if ([self.delegate respondsToSelector:@selector(didClickToPlayAudio:stauts:)]) {
        [self.delegate didClickToPlayAudio:self.model stauts:self.stauts];
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
