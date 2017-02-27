//
//  HDMessageRightTextCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageRightTextCell.h"
#import "HDTextCellModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+HDString.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+GIF.h"

@interface HDMessageRightTextCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *sendFailButton;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;
@property (nonatomic, strong) HDTextCellModel *model;

@end

@implementation HDMessageRightTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToMessageSendTypeChange:) name:@"HDMessageSendTypeChange" object:nil];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPressGesture)];
    [self.textBackgroundView addGestureRecognizer:longPressGes];
    self.textBackgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToHeadTapGesture)];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:headTap];
}

- (void)resetCellWithModel:(HDMessageCellModel *)model
{
    HDTextCellModel *textModel = (HDTextCellModel *)model;
    self.model = textModel;
    NSURL *headImageURL = [NSURL URLWithString:textModel.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    self.titleLabel.attributedText = [textModel.text messageAttribute];
    
    UIImage *image = [UIImage imageNamed:@"Msg_bg_right"];
    self.textBackgroundView.image = [image resizableImage];
    
    self.timeLabel.text = textModel.messageTime;
    self.nameLabel.text = textModel.senderName;
    
    if (textModel.isCompany == NO) {
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
        NSNumber *num = dict[@"HDSendType"];
        SendType type = (SendType)[num integerValue];
        [self resetIndicatorView:type];
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
