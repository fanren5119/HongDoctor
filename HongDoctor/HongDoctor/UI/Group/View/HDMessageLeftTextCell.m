//
//  HDMessageLeftTextCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/26.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDMessageLeftTextCell.h"
#import "HDTextCellModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+HDString.h"
#import "UIImage+GIF.h"
#import "HDMessageCellDelegate.h"

@interface HDMessageLeftTextCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;
@property (nonatomic, strong) HDTextCellModel *model;

@end

@implementation HDMessageLeftTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    
    UIImage *image = [UIImage imageNamed:@"Msg_bg_left"];
    self.textBackgroundView.image = [image resizableImage];
    
    self.timeLabel.text = textModel.messageTime;
    self.nameLabel.text = textModel.senderName;
    
    if (textModel.isCompany == NO) {
        self.senderSignImageView.hidden = NO;
        self.senderSignImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.senderSignImageView.hidden = YES;
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
