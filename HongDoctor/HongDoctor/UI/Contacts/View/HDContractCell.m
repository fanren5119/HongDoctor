//
//  HDContractCell.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDContractCell.h"
#import "HDContractEntity.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@interface HDContractCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *gradeImageViewArray;
@property (nonatomic, strong) HDContractEntity *entity;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@end

@implementation HDContractCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithEntity:(HDContractBaseEntity *)entity;
{
    HDContractEntity *cellEntity = (HDContractEntity *)entity;
    NSURL *url = [NSURL URLWithString:cellEntity.headImageURL];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    self.nameLabel.text = cellEntity.name;
    NSInteger grade = [cellEntity.grade integerValue];
    for (UIImageView *imageView in self.gradeImageViewArray) {
        if (imageView.tag < grade) {
            imageView.image = [UIImage imageNamed:@"User_star.png"];
        } else {
            imageView.image = [UIImage imageNamed:@""];
        }
    }
    if (cellEntity.isSign) {
        self.signImageView.hidden = NO;
        self.signImageView.image = [UIImage imageNamed:@"member_yun.png"];
    } else {
        self.signImageView.hidden = YES;
    }
}



@end
