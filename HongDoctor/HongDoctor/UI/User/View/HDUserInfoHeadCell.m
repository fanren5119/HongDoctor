//
//  HDUserInfoHeadCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserInfoHeadCell.h"
#import "HDUserInfoCellModel.h"
#import "UIImageView+WebCache.h"
#import "HDImageManager.h"

@interface HDUserInfoHeadCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@end

@implementation HDUserInfoHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithModel:(HDUserInfoCellModel *)model
{
    self.titleLabel.text = model.title ? model.title : @"";
    if (model.content) {
        UIImage *image = [HDImageManager getImageWithName:model.content];
        if (image) {
            self.headImageView.image = image;
            return;
        }
        NSURL *headImageURL = [NSURL URLWithString:model.content];
        [self.headImageView sd_setImageWithURL:headImageURL placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    }
}
@end
