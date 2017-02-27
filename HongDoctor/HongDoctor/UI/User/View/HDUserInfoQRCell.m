//
//  HDUserInfoQRCell.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/22.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDUserInfoQRCell.h"
#import "HDUserInfoCellModel.h"
#import "UIImageView+WebCache.h"

@interface HDUserInfoQRCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HDUserInfoQRCell

- (void)resetCellWithModel:(HDUserInfoCellModel *)model
{
    self.titleLabel.text = model.title ? model.title : @"";
    
    NSURL *imageURL = [NSURL URLWithString:model.content];
    UIImage *placeholderImage = [UIImage imageNamed:@"User_QR.png"];
    [self.contentImageView sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
}

@end
