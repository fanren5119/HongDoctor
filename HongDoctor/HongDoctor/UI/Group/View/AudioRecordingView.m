//
//  AudioRecordingView.m
//  iTask
//
//  Created by Owen.Qin on 13-6-11.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import "AudioRecordingView.h"

@implementation AudioRecordingView

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
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.center = self.center;
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
