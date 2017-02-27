//
//  HDMessageLeftLocationCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/28.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageLeftLocationCell.h"
#import "HDMessageCellModel.h"
#import "HDLocationCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+resizable.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+GIF.h"

@interface HDMessageLeftLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;
@property (nonatomic, strong) HDMessageCellModel    *model;


@end

@implementation HDMessageLeftLocationCell

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
    self.model = model;
    HDLocationCellModel *cellModel = (HDLocationCellModel *)model;
    self.timeLabel.text = cellModel.messageTime;
    self.addressLabel.text = cellModel.address;
    self.nameLabel.text = cellModel.senderName;
    
    NSURL *headImageURL = [NSURL URLWithString:cellModel.senderHeadURL];
    [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    NSURL *url = [NSURL URLWithString:cellModel.contentImageURL];
    [self.contentImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Message_img_default.png"]];
    
    UIImage *image = [UIImage imageNamed:@"Msg_bg_left"];
    self.backgroundImageView.image = [image resizableImage];
    
    if (cellModel.isCompany == NO) {
        self.senderSignImageView.hidden = NO;
        self.senderSignImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.senderSignImageView.hidden = YES;
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
