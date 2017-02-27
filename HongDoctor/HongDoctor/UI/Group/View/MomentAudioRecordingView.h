//
//  MomentAudioRecordingView.h
//  TalkTime
//
//  Created by yongyang on 13-11-13.
//  Copyright (c) 2013年 yipinapp.ibrand. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MomentAudioRecordingViewDelegate;
@interface MomentAudioRecordingView : UIView

@property (nonatomic, strong) IBOutlet UIView               *contentView;
@property (nonatomic, strong) IBOutlet UIImageView          *bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView          *indicateImageView;
@property (nonatomic, strong) IBOutlet UIImageView          *volumeImageView;
@property (nonatomic, strong) IBOutlet UILabel              *textLabel;

@property (strong, nonatomic) IBOutlet UIButton *recoredPressButton;
@property (nonatomic, weak)   id<MomentAudioRecordingViewDelegate>          delegateMomentAudioView;

- (IBAction)responseToRecordPressButtonTouchDown:(id)sender;
- (IBAction)responseToRecordPressButtonTouchCancel:(id)sender;
- (IBAction)responseToRecordPressButtonTouchDragInside:(id)sender;
- (IBAction)responseToRecordPressButtonTouchDragExit:(id)sender;
- (IBAction)responseToRecordPressButtonTouchDragEnter:(id)sender;
- (IBAction)responseToRecordPressButtonTouchDragOutside:(id)sender;
- (IBAction)responseToRecordPressButtonTouchUpInside:(id)sender;
- (IBAction)responseToRecordPressButtonTouchUpOutside:(id)sender;


- (void)updatePowerWithValue:(float)value;
@end


@protocol MomentAudioRecordingViewDelegate <NSObject>
- (void)recordPressButtonTouchDown:(MomentAudioRecordingView*)soundView;
- (void)recordPressButtonTouchDragOutside:(MomentAudioRecordingView*)soundView;
- (void)recordPressButtonTouchDragEnter:(MomentAudioRecordingView *)soundView;
- (void)recordPressButtonTouchUpInside:(MomentAudioRecordingView*)soundView;
- (void)recordPressButtonTouchUpOutside:(MomentAudioRecordingView*)soundView;
@end

