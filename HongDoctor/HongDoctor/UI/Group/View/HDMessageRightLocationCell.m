//
//  HDMessageRightLocationCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/28.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageRightLocationCell.h"
#import "HDMessageCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDLocationCellModel.h"
#import "UIImage+resizable.h"
#import "HDMessageCellDelegate.h"
#import "HDImageManager.h"
#import "UIImage+GIF.h"

@interface HDMessageRightLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) HDMessageCellModel    *model;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *sendFailButton;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;

@end

@implementation HDMessageRightLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToMessageSendTypeChange:) name:@"HDMessageSendTypeChange" object:nil];
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    self.contentImageView.userInteractionEnabled = YES;
    [self.contentImageView addGestureRecognizer:tagGesture];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPressGesture)];
    [self.contentImageView addGestureRecognizer:longPressGes];
    self.contentImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToHeadTapGesture)];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:headTap];
}

- (void)resetCellWithModel:(HDMessageCellModel *)model
{
    self.model = model;
    HDLocationCellModel *cellModel = (HDLocationCellModel *)model;
    self.timeLabel.text = cellModel.messageTime;
    self.addressLabel.text = cellModel.address;
    self.nameLabel.text = cellModel.senderName;
    
    NSURL *headImageURL = [NSURL URLWithString:cellModel.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    if (model.sendType == MessageSending || model.sendType == MessageSendFailed) {
        UIImage *image = [HDImageManager getImageWithName:cellModel.contentImageURL];
        self.contentImageView.image = image;
    } else {
        NSURL *url = [NSURL URLWithString:cellModel.contentImageURL];
        [self.contentImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Message_img_default.png"]];
    }
    
    UIImage *image = [UIImage imageNamed:@"Msg_bg_right"];
    self.backgroundImageView.image = [image resizableImage];
    
    if (cellModel.isCompany == NO) {
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
        SendType type = (SendType)[dict[@"HDSendType"] integerValue];
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

- (void)respondsToTapGesture
{
    if ([self.delegate respondsToSelector:@selector(didClickToScanLocation:)]) {
        [self.delegate didClickToScanLocation:self.model];
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
