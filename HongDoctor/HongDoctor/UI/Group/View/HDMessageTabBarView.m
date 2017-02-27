//
//  HDMessageTabBarView.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/16.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageTabBarView.h"
#import <AVFoundation/AVFoundation.h>
#import "TaskUtility.h"

@interface HDMessageTabBarView () <UITextViewDelegate>

@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIButton              *changeAudioButton;
@property (nonatomic, strong) UIButton              *audioButton;
@property (nonatomic, strong) UITextView            *textView;
@property (nonatomic, strong) UIButton              *changeFaceButton;
@property (nonatomic, strong) UIButton              *addOtherButton;
@property (nonatomic, strong) UIButton              *sendButton;
@property (nonatomic, strong) UIView                *inputBackgroundView;

@property (nonatomic, strong) AVAudioRecorder       *audioRecorder;
@property (nonatomic, strong) NSTimer               *timer;
@property (nonatomic, assign) NSTimeInterval        recordTime;
@property (nonatomic, strong) NSMutableArray        *reuserImageViewArray;
@property (nonatomic, strong) NSMutableArray        *animateImageViewArray;
@property (nonatomic, strong) NSString              *audioRecordFilePath;
@property (nonatomic, assign) BOOL                  isManualStopRecording;

@end

@implementation HDMessageTabBarView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self registerNotification];
    }
    return self;
}

- (void)createUI
{
    [self createLineView];
    [self createChangeAudioButton];
    [self createChangeFaceButton];
    [self createAddOtherButton];
//    [self createSendButton];
    
    [self createInputBackgroundView];
    [self createAudioButton];
    [self createTextView];
}

- (void)createLineView
{
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ColorFromRGB(0xdddddd);
    [self addSubview:self.lineView];
}

- (void)createChangeAudioButton
{
    self.changeAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeAudioButton addTarget:self action:@selector(respondsToChangeVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *normalImage = [UIImage imageNamed:@"Msg_bg_normal"];
    UIImage *selectImage = [UIImage imageNamed:@"Msg_btn_audio"];
    [self.changeAudioButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.changeAudioButton setBackgroundImage:selectImage forState:UIControlStateSelected];
    [self addSubview:self.changeAudioButton];
}

- (void)createChangeFaceButton
{
    self.changeFaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [[UIImage imageNamed:@"Msg_btn_face"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [[UIImage imageNamed:@"Msg_btn_face_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.changeFaceButton setImage:image forState:UIControlStateNormal];
    [self.changeFaceButton setImage:selectImage forState:UIControlStateHighlighted];
    [self.changeFaceButton addTarget:self action:@selector(respondsToFaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changeFaceButton];
}

- (void)createAddOtherButton
{
    self.addOtherButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [[UIImage imageNamed:@"Msg_btn_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [[UIImage imageNamed:@"Msg_btn_add_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.addOtherButton setImage:image forState:UIControlStateNormal];
    [self.addOtherButton setImage:selectImage forState:UIControlStateHighlighted];
    [self.addOtherButton addTarget:self action:@selector(respondsToAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addOtherButton];
    self.addOtherButton.hidden = NO;
}

- (void)createSendButton
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.backgroundColor = ColorFromRGB(0x00a0e9);
    [self.sendButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(respondsToSendButton) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.sendButton];
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.hidden = YES;
}

- (void)createInputBackgroundView
{
    self.inputBackgroundView = [[UIView alloc] init];
    self.inputBackgroundView.layer.cornerRadius = 5;
    self.inputBackgroundView.layer.borderColor = ColorFromRGB(0xdddddd).CGColor;
    self.inputBackgroundView.layer.borderWidth = 1;
    self.inputBackgroundView.layer.masksToBounds = YES;
    [self addSubview:self.inputBackgroundView];
}

- (void)createAudioButton
{
    self.audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioButton setTitle:@"按住 录音" forState:UIControlStateNormal];
    [self.audioButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.audioButton addTarget:self action:@selector(respondsToRecordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.audioButton addTarget:self action:@selector(respondsToRecordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.audioButton addTarget:self action:@selector(respondsToRecordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.audioButton addTarget:self action:@selector(respondsToRecordButtonDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [self.audioButton addTarget:self action:@selector(respondsToRecordButtonDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self.inputBackgroundView addSubview:self.audioButton];
    self.audioButton.hidden = YES;
}

- (void)createTextView
{
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:16.0];
    [self.inputBackgroundView addSubview:self.textView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    self.lineView.frame = CGRectMake(0, 0, width, 1);
    self.changeAudioButton.frame = CGRectMake(10, (height - 30)/2, 30, 30);
    self.addOtherButton.frame = CGRectMake(width - 40, (height - 30)/2, 30, 30);
//    self.sendButton.frame = CGRectMake(width - 40, (height - 30)/2, 35, 30);
    self.changeFaceButton.frame = CGRectMake(width - 80, (height - 30)/2, 30, 30);
    self.inputBackgroundView.frame = CGRectMake(50, (height - 40)/2, width - 140, 40);
    self.textView.frame = CGRectMake(2, 8, self.inputBackgroundView.frame.size.width - 4, 25);
    self.audioButton.frame = self.inputBackgroundView.bounds;
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToTextFieldChange:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma -mark public

- (void)insertAttachment:(EmojiTextAttachment *)attachment
{
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.length > 0) {
        [self.textView.textStorage deleteCharactersInRange:selectedRange];
    }
    //Insert emoji image
    [self.textView.textStorage insertAttributedString:str atIndex:self.textView.selectedRange.location];
    
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location+1, 0);
    
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    
    [self.textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [self.textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:wholeRange];
    
//    self.sendButton.hidden = NO;
//    self.addOtherButton.hidden = YES;
}

- (void)deleteLastAttachment
{
    [self.textView deleteBackward];
}

- (void)textFieldBecomeFirstResponder
{
    [self.textView becomeFirstResponder];
}

- (void)textFieldRegisnFirstResponder
{
    [self.textView resignFirstResponder];
}

#pragma -mark responds

- (void)respondsToChangeVideoButton:(UIButton *)sender
{
    if (sender.selected) {
        self.textView.hidden = NO;
        self.audioButton.hidden = YES;
    } else {
        self.textView.hidden = YES;
        self.audioButton.hidden = NO;
        [self endEditing:YES];
        if ([self.delegate respondsToSelector:@selector(didSelectToChangeToVideo)]) {
            [self.delegate didSelectToChangeToVideo];
        }
    }
    sender.selected = !sender.selected;
}

- (void)respondsToFaceButton:(UIButton *)sender
{
    self.textView.hidden = NO;
    self.audioButton.hidden = YES;
    self.changeAudioButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSelectToChangeInputFace)]) {
        [self.delegate didSelectToChangeInputFace];
    }
}

- (void)respondsToAddButton:(UIButton *)sender
{
    self.textView.hidden = NO;
    self.audioButton.hidden = YES;
    self.changeAudioButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSelectToInputOther)]) {
        [self.delegate didSelectToInputOther];
    }
}

- (void)respondsToSendButton
{
//    if ([self.delegate respondsToSelector:@selector(didSelectToSendMessage:)]) {
//        NSString *text = [self.textView.textStorage getPlainString];
//        [self.delegate didSelectToSendMessage:text];
//        self.textView.text = @"";
//        self.sendButton.hidden = YES;
//        self.addOtherButton.hidden = NO;
//    }
}

- (void)respondsToRecordButtonTouchDown
{
    if ([self.delegate respondsToSelector:@selector(respondsToAudioButtonTouchDown)]) {
        [self.delegate respondsToAudioButtonTouchDown];
    }
}

- (void)respondsToRecordButtonDragOutside
{
    if ([self.delegate respondsToSelector:@selector(respondsToAudioButtonDragOutside)]) {
        [self.delegate respondsToAudioButtonDragOutside];
    }
}

- (void)respondsToRecordButtonDragEnter
{
    if ([self.delegate respondsToSelector:@selector(respondsToAudioButtonDragEnter)]) {
        [self.delegate respondsToAudioButtonDragEnter];
    }
}

- (void)respondsToRecordButtonTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(respondsToAudioButtonTouchUpInside)]) {
        [self.delegate respondsToAudioButtonTouchUpInside];
    }
}

- (void)respondsToRecordButtonTouchUpOutside
{
    if ([self.delegate respondsToSelector:@selector(respondsToAudioButtonTouchUpOutside)]) {
        [self.delegate respondsToAudioButtonTouchUpOutside];
    }
}

- (void)selectorToTextFieldChange:(NSNotification *)not
{
//    NSString *text = [self.textView.textStorage getPlainString];
//    if (text.length > 0) {
//        self.sendButton.hidden = NO;
//        self.addOtherButton.hidden = YES;
//    } else {
//        self.sendButton.hidden = YES;
//        self.addOtherButton.hidden = NO;
//    }
}


#pragma -mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSelectToSendMessage:)]) {
            NSString *text = [self.textView.textStorage getPlainString];
            [self.delegate didSelectToSendMessage:text];
        }
        self.textView.text = @"";
        [self endEditing:YES];
        return NO;
    }
    if ([text containsString:@"<img src="]) {
        NSAttributedString *str = [text messageAttribute];
        NSRange selectedRange = self.textView.selectedRange;
        if (selectedRange.length > 0) {
            [self.textView.textStorage deleteCharactersInRange:selectedRange];
        }
        //Insert emoji image
        [self.textView.textStorage insertAttributedString:str atIndex:self.textView.selectedRange.location];
        
        self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location+str.length, 0);
        
        NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
        
        [self.textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
        
        [self.textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:wholeRange];
        return NO;
    }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


@end
