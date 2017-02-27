//
//  HDMessageRightImageCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageRightImageCell.h"
#import "HDImageCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDImageManager.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+GIF.h"

@interface HDMessageRightImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) HDImageCellModel *model;
@property (weak, nonatomic) IBOutlet UIButton *sendFailButton;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;

@end

@implementation HDMessageRightImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToMessageSendTypeChange:) name:@"HDMessageSendTypeChange" object:nil];
    
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:tagGesture];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPressGesture)];
    [self.backgroundImageView addGestureRecognizer:longPressGes];
    self.backgroundImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToHeadTapGesture)];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:headTap];
}

- (void)resetCellWithModel:(HDMessageCellModel *)model
{
    HDImageCellModel *cellModel = (HDImageCellModel *)model;
    self.model = cellModel;
    NSURL *headImageURL = [NSURL URLWithString:cellModel.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    if (model.sendType == MessageSending || model.sendType == MessageSendFailed) {
        UIImage *image = [HDImageManager getImageWithName:cellModel.imageURL];
        self.contentImageView.image = image;
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        NSURL *url = [NSURL URLWithString:cellModel.imageURL];
        UIImage *placeholderImage = [UIImage imageNamed:@"Message_img_default.png"];
        self.contentImageView.image = placeholderImage;
        [self.contentImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
    }
    
    UIImage *image = [UIImage imageNamed:@"Msg_bg_right"];
    self.backgroundImageView.image = [image resizableImage];
    
    self.timeLabel.text = cellModel.messageTime;
    self.nameLabel.text = cellModel.senderName;
    
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
    if ([self.delegate respondsToSelector:@selector(didClickToScanImage:)]) {
        [self.delegate didClickToScanImage:self.model];
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
