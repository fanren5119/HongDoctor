//
//  HDUserInfoCanEditCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserInfoCanEditCell.h"
#import "HDUserInfoCellModel.h"

@interface HDUserInfoCanEditCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation HDUserInfoCanEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithModel:(HDUserInfoCellModel *)model
{
    self.titleLabel.text = model.title ? model.title : @"";
    self.contentLabel.text = model.content ? model.content : @"";
}

@end
