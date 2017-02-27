//
//  HDCreateGroupCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/19.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDCreateGroupCell.h"
#import "HDContractEntity.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@interface HDCreateGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@property (nonatomic, strong) HDContractEntity *entity;


@end

@implementation HDCreateGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellWithEntity:(HDContractEntity *)entity;
{
    self.entity = entity;
    NSURL *url = [NSURL URLWithString:entity.headImageURL];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    self.nameLabel.text = entity.name;
    if (entity.isSelect) {
        self.selectImageView.image = [UIImage imageNamed:@"Con_bt_select"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"Con_bt_select_no"];
    }
    
    if (entity.isSign) {
        self.signImageView.hidden = NO;
        self.signImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.signImageView.hidden = YES;
    }
}


@end
