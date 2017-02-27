//
//  HDUserInfoGradeCell.m
//  HongDoctor
//
//  Created by 王磊 on 2016/12/21.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDUserInfoGradeCell.h"
#import "HDUserInfoCellModel.h"

@interface HDUserInfoGradeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;


@end

@implementation HDUserInfoGradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithModel:(HDUserInfoCellModel *)model
{
    self.titleLabel.text = model.title ? model.title : @"";
    if (model.content) {
        NSInteger grade = [model.content integerValue];
        for (UIImageView *imageView in self.imageViewArray) {
            if (imageView.tag < grade) {
                imageView.image = [UIImage imageNamed:@"User_star.png"];
            } else {
                imageView.image = [UIImage imageNamed:@""];
            }
        }
    }
}

@end
