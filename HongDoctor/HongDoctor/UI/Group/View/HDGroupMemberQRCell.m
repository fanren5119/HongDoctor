//
//  HDGroupMemberQRCell.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDGroupMemberQRCell.h"
#import "HDGroupMemberNormalCellModel.h"
#import "UIImageView+WebCache.h"

@interface HDGroupMemberQRCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation HDGroupMemberQRCell

- (void)resetCellWithModel:(HDGroupMemberNormalCellModel *)model
{
    self.titleLabel.text = model.title ? model.title : @"";
    
    NSURL *imageURL = [NSURL URLWithString:model.content];
    UIImage *placeholderImage = [UIImage imageNamed:@"User_QR.png"];
    [self.contentImageView sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
    self.lineView.hidden = model.isHideLine;
}

@end
