//
//  AudioRecordingView.h
//  iTask
//
//  Created by Owen.Qin on 13-6-11.
//  Copyright (c) 2013年 Owen.Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioRecordingView : UIView

@property (nonatomic, strong) IBOutlet UIView               *contentView;
@property (nonatomic, strong) IBOutlet UIImageView          *bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView          *indicateImageView;
@property (nonatomic, strong) IBOutlet UIImageView          *volumeImageView;
@property (nonatomic, strong) IBOutlet UILabel              *textLabel;

- (void)updatePowerWithValue:(float)value;

@end
