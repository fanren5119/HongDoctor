//
//  HDGroupMemberNormalCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupMemberNormalCell.h"
#import "HDGroupMemberNormalCellModel.h"

@interface HDGroupMemberNormalCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *editContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@end

@implementation HDGroupMemberNormalCell

- (void)resetCellWithModel:(HDGroupMemberNormalCellModel *)model
{
    self.titleLabel.text = model.title;
    self.lineView.hidden = model.isHideLine;
    if (model.isCanSelect) {
        self.contentLabel.hidden = YES;
        self.editContentLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.editContentLabel.text = model.content;
    } else {
        self.contentLabel.hidden = NO;
        self.editContentLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.contentLabel.text = model.content;
    }
}

@end
