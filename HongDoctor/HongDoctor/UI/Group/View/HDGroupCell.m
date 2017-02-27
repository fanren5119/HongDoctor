//
//  HDGroupCell.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupCell.h"
#import "HDGroupCellModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+HDString.h"

@interface HDGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *headImageViewArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *threeHeadImageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *fourHeadBackView;
@property (weak, nonatomic) IBOutlet UIView *threeHeadBackView;

@property (nonatomic, strong) HDGroupCellModel  *model;
@property (weak, nonatomic) IBOutlet UIImageView *exportSignImageView;


@end

@implementation HDGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithEntity:(HDGroupCellModel *)model
{
    self.model = model;
    [self resetImageViews];
    [self resetLabels];
    [self resetCountLabel];
    [self resetSignImageView];
}

- (void)resetImageViews
{
    NSArray *imageURLs = [self.model.groupHeaderURl componentsSeparatedByString:@","];
    if (imageURLs.count == 1) {
        NSURL *url = [NSURL URLWithString:self.model.groupHeaderURl];
        [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
        self.headImageView.hidden = NO;
        self.fourHeadBackView.hidden = YES;
        self.threeHeadBackView.hidden = YES;
    } else if (imageURLs.count == 3) {
        self.headImageView.hidden = YES;
        self.threeHeadBackView.hidden = NO;
        self.fourHeadBackView.hidden = YES;
        for (int i = 0; i < self.threeHeadImageViews.count; i ++) {
            UIImageView *imageView = self.threeHeadImageViews[i];
            int tag = (int)imageView.tag - 10;
            if (tag < imageURLs.count) {
                NSString *imageURL = imageURLs[tag];
                NSURL *url = [NSURL URLWithString:imageURL];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
            }
        }
    } else {
        self.headImageView.hidden = YES;
        self.fourHeadBackView.hidden = NO;
        self.threeHeadBackView.hidden = YES;
        for (int i = 0; i < self.headImageViewArray.count; i ++) {
            UIImageView *imageView = self.headImageViewArray[i];
            int tag = (int)imageView.tag;
            if (tag < imageURLs.count) {
                NSString *imageURL = imageURLs[tag];
                NSURL *url = [NSURL URLWithString:imageURL];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
            }
        }
    }
}

- (void)resetCountLabel
{
    NSInteger value = [self.model.msgUnReadCount integerValue];
    if (value > 0) {
        self.countLabel.hidden = NO;
        if (value < 100) {
            self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
        } else {
            self.countLabel.text = @"99+";
        }
    } else {
        self.countLabel.hidden = YES;
    }

}

- (void)resetLabels
{
    self.titleLabel.text = self.model.groupdName ? self.model.groupdName : @"";
    if ([self.model.groupNewMsgType isEqualToString:@"0"]) {
        self.contentLabel.attributedText = [self.model.groupNewMessage messageAttribute];
    } else if ([self.model.groupNewMsgType isEqualToString:@"1"]) {
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"[图片]"];
    } else if ([self.model.groupNewMsgType isEqualToString:@"2"]) {
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"[视频]"];
    } else if ([self.model.groupNewMsgType isEqualToString:@"3"]){
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"[语音]"];
    } else {
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"[位置]"];
    }
    self.timeLabel.text = self.model.groupNewDate;
}

- (void)resetSignImageView
{
    self.exportSignImageView.hidden = !self.model.isExportGroup;
}

- (void)hideLineView:(BOOL)isHide
{
    self.lineView.hidden = isHide;
}

@end
