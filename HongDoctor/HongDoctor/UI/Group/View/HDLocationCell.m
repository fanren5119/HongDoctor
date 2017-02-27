//
//  HDLocationCell.m
//  HongDoctor
//
//  Created by wanglei on 2017/1/14.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDLocationCell.h"
#import "HDLocationCellEntity.h"

@interface HDLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@end

@implementation HDLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellWithEntity:(HDLocationCellEntity *)entity
{
    self.nameLabel.text = entity.name;
    self.addressLabel.text = entity.address;
    self.selectImageView.hidden = !entity.isSelect;
}

@end
