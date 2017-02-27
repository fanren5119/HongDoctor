//
//  HDMessageRightVideoCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageRightVideoCell.h"
#import "HDVideoCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+fixOrientation.h"
#import "UIImage+GIF.h"

@interface HDMessageRightVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) HDMessageCellModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *sendFailButton;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;

@end

@implementation HDMessageRightVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorToMessageSendTypeChange:) name:@"HDMessageSendTypeChange" object:nil];
    
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
    
    HDVideoCellModel *cellModel = (HDVideoCellModel *)model;
    NSURL *headImageURL = [NSURL URLWithString:cellModel.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    NSURL *url = [NSURL URLWithString:cellModel.contentImageURL];
    self.contentImageView.image = [UIImage imageNamed:@"Message_img_default.png"];
    [self.contentImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image != nil) {
            self.contentImageView.image = [image fixOrientation];
        } else {
            self.contentImageView.image = [UIImage imageNamed:@"Message_img_default.png"];
        }
    }];
    
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
    NSString *contentImageURL = dict[@"HDContentImageURL"];
    if (contentImageURL != nil && contentImageURL.length > 0) {
        NSURL *url = [NSURL URLWithString:contentImageURL];
        [self.contentImageView sd_setImageWithURL:url];
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

- (IBAction)respondsToPlayVideoButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickToPlayVideo:)]) {
        [self.delegate didClickToPlayVideo:self.model];
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

