//
//  HDMessageTabBarView.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/16.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AudioRecordStatus) {
    AudioRecordStatus_Start     = 0,
    AudioRecordStatus_Ongoing   = 1,
    AudioRecordStatus_End       = 2
};

@protocol HDMessageTabBarViewDelegate;

@interface HDMessageTabBarView : UIView

@property (nonatomic, strong) id <HDMessageTabBarViewDelegate> delegate;
@property (nonatomic, strong) void (^audioRecord) (AudioRecordStatus status);

- (void)insertAttachment:(EmojiTextAttachment *)attachment;
- (void)deleteLastAttachment;
- (void)textFieldBecomeFirstResponder;
- (void)textFieldRegisnFirstResponder;

@end

@protocol HDMessageTabBarViewDelegate <NSObject>

- (void)didSelectToChangeToVideo;
- (void)didSelectToChangeInputFace;
- (void)didSelectToInputOther;
- (void)didSelectToSendMessage:(NSString *)text;

- (void)respondsToAudioButtonTouchDown;
- (void)respondsToAudioButtonDragOutside;
- (void)respondsToAudioButtonDragEnter;
- (void)respondsToAudioButtonTouchUpInside;
- (void)respondsToAudioButtonTouchUpOutside;

@end
