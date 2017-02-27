//
//  HDMessageLeftVideoCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageLeftVideoCell.h"
#import "HDVideoCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDMessageCellDelegate.h"
#import "UIImage+GIF.h"
#import "UIImage+fixOrientation.h"

@interface HDMessageLeftVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) HDMessageCellModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;

@end

@implementation HDMessageLeftVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPressGesture)];
    [self.backgroundImageView addGestureRecognizer:longPressGes];
    self.backgroundImageView.userInteractionEnabled = YES;
    
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
    self.mainImageView.image = [UIImage imageNamed:@"Message_img_default.png"];
    [self.mainImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.mainImageView.image = [image fixOrientation];
    }];
    
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

- (IBAction)respondsToPlayVideoButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickToPlayVideo:)]) {
        [self.delegate didClickToPlayVideo:self.model];
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
