//
//  HDUserHeaderCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserHeaderCell.h"
#import "HDUserCellModel.h"
#import "UIImageView+WebCache.h"

@interface HDUserHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation HDUserHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithEntity:(HDUserCellModel *)entity
{
    NSURL *url = [NSURL URLWithString:entity.headImage];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    self.nameLabel.text = entity.title;
    self.arrowImageView.hidden = !entity.isShowArrow;
}

@end
