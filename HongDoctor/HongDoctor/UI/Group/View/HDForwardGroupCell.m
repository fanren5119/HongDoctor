//
//  HDForwardGroupCell.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/23.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDForwardGroupCell.h"
#import "HDForwardGroupCellModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+HDString.h"

@interface HDForwardGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *headImageViewArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *threeHeadImageViews;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *fourHeadBackView;
@property (weak, nonatomic) IBOutlet UIView *threeHeadBackView;

@property (nonatomic, strong) HDForwardGroupCellModel  *model;
@property (weak, nonatomic) IBOutlet UIImageView *exportSignImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HDForwardGroupCell

- (void)resetCellWithEntity:(HDForwardGroupCellModel *)model
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
    
    if (self.model.isSelect) {
        self.selectImageView.image = [UIImage imageNamed:@"Con_bt_select"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"Con_bt_select_no"];
    }
}

- (void)resetCountLabel
{
    self.countLabel.hidden = YES;
}

- (void)resetLabels
{
    self.contentLabel.text = [NSString stringWithFormat:@"(%@人)", self.model.groupMemberCount];
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
