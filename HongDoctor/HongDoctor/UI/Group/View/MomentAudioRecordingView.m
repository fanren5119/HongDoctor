//
//  MomentAudioRecordingView.m
//  TalkTime
//
//  Created by yongyang on 13-11-13.
//  Copyright (c) 2013年 yipinapp.ibrand. All rights reserved.
//

#import "MomentAudioRecordingView.h"

@implementation MomentAudioRecordingView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgImageView.image = [UIImage imageNamed:@"icon_audio_record_bg.png"];
    self.indicateImageView.image = [UIImage imageNamed:@"icon_audio_record_indicator.png"];
    self.volumeImageView.image = [UIImage imageNamed:@"icon_audio_record_volume1.png"];
    self.textLabel.text = @"手指上滑，取消发送";
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self.recoredPressButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.recoredPressButton setTitleColor:[UIColor colorWithRed:255/255.0f green:149/255.0f blue:23/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.recoredPressButton setBackgroundImage:[UIImage imageNamed:@"icon_msg_add_presstalk_hl.png"] forState:UIControlStateHighlighted];
    self.textLabel.hidden = YES;
}


#pragma mark - Recrod Press Button

- (IBAction)responseToRecordPressButtonTouchDown:(id)sender
{
    self.textLabel.hidden = NO;
    if (self.delegateMomentAudioView && [self.delegateMomentAudioView respondsToSelector:@selector(recordPressButtonTouchDown:)]) {
        [self.delegateMomentAudioView recordPressButtonTouchDown:self];
    }
}

- (IBAction)responseToRecordPressButtonTouchCancel:(id)sender
{
}

- (IBAction)responseToRecordPressButtonTouchDragInside:(id)sender
{
}

- (IBAction)responseToRecordPressButtonTouchDragExit:(id)sender
{
    
}

- (IBAction)responseToRecordPressButtonTouchDragEnter:(id)sender
{
    if (_delegateMomentAudioView && [_delegateMomentAudioView respondsToSelector:@selector(recordPressButtonTouchDragEnter:)]) {
        [_delegateMomentAudioView recordPressButtonTouchDragEnter:self];
    }
}

- (IBAction)responseToRecordPressButtonTouchDragOutside:(id)sender
{
    if (_delegateMomentAudioView && [_delegateMomentAudioView respondsToSelector:@selector(recordPressButtonTouchDragOutside:)]) {
        [_delegateMomentAudioView recordPressButtonTouchDragOutside:self];
    }
}

- (IBAction)responseToRecordPressButtonTouchUpInside:(id)sender
{
    if (_delegateMomentAudioView && [_delegateMomentAudioView respondsToSelector:@selector(recordPressButtonTouchUpInside:)]) {
        [_delegateMomentAudioView recordPressButtonTouchUpInside:self];
    }
}

- (IBAction)responseToRecordPressButtonTouchUpOutside:(id)sender {
    if (_delegateMomentAudioView && [_delegateMomentAudioView respondsToSelector:@selector(recordPressButtonTouchUpOutside:)]) {
        [_delegateMomentAudioView recordPressButtonTouchUpOutside:self];
    }

}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.center = self.center;
    self.recoredPressButton.center = CGPointMake(self.center.x, self.contentView.center.y + self.contentView.frame.size.height/2+self.recoredPressButton.frame.size.height/2+24);
}

- (void)updatePowerWithValue:(float)value
{
    //-160表示完全安静，0表示最大输入值
    int volumeImageIndex = 1;
    if (-160 <= value && value < -120) {
        volumeImageIndex = 1;
    }
    else if (-120 <= value && value < -43) {
        volumeImageIndex = 2;
    }
    else if (-42 <= value && value < -40) {
        volumeImageIndex = 3;
    }
    else if (-40 <= value && value < -30) {
        volumeImageIndex = 4;
    }
    else if (-30 <= value && value <= 0) {
        volumeImageIndex = 5;
    }
    
    self.volumeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_audio_record_volume%d.png", volumeImageIndex]];
}

@end
