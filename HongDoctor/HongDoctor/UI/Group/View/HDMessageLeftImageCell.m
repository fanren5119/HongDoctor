//
//  HDMessageLeftImageCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageLeftImageCell.h"
#import "HDImageCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+GIF.h"

@interface HDMessageLeftImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView    *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView    *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;
@property (weak, nonatomic) IBOutlet UILabel        *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) HDImageCellModel      *model;

@end

@implementation HDMessageLeftImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    HDImageCellModel *cellModel = (HDImageCellModel *)model;
    self.model = cellModel;
    NSURL *headImageURL = [NSURL URLWithString:cellModel.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    NSURL *url = [NSURL URLWithString:cellModel.imageURL];
    UIImage *placeholderImage = [UIImage imageNamed:@"Message_img_default.png"];
    self.contentImageView.image = placeholderImage;
    [self.contentImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
    
    UIImage *image = [UIImage imageNamed:@"Msg_bg_left"];
    self.backgroundImageView.image = [image resizableImage];
    
    self.timeLabel.text = cellModel.messageTime;
    self.nameLabel.text = cellModel.senderName;
    
    if (cellModel.isCompany == NO) {
        self.senderSignImageView.hidden = NO;
        self.senderSignImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.senderSignImageView.hidden = YES;
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
