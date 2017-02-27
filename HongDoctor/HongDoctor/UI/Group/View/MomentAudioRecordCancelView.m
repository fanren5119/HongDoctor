
//
//  MomentAudioRecordCancelView.m
//  TalkTime
//
//  Created by yongyang on 13-11-27.
//  Copyright (c) 2013年 yipinapp.ibrand. All rights reserved.
//

#import "MomentAudioRecordCancelView.h"

@implementation MomentAudioRecordCancelView

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
    self.indicateImageView.image = [UIImage imageNamed:@"icon_audio_record_cancel.png"];
    self.textLabel.text = @"松开手指，取消发送";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.center = self.center;
}


@end
