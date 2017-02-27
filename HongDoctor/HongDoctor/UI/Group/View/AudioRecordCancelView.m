//
//  AudioRecordCancelView.m
//  iTask
//
//  Created by Owen.Qin on 13-6-11.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import "AudioRecordCancelView.h"

@implementation AudioRecordCancelView

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
