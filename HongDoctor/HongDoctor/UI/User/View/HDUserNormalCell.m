//
//  HDUserNormalCell.m
//  
//
//  Created by 王磊 on 2016/12/14.
//
//

#import "HDUserNormalCell.h"
#import "HDUserCellModel.h"


@interface HDUserNormalCell ()

@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView         *lineView;
@property (weak, nonatomic) IBOutlet UIImageView    *contentImageView;

@end

@implementation HDUserNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCellWithEntity:(HDUserCellModel *)entity
{
    self.contentImageView.image = [UIImage imageNamed:entity.headImage];
    self.titleLabel.text = entity.title;
    self.arrowImageView.hidden = !entity.isShowArrow;
    self.lineView.hidden = !entity.isShowLine;
}

@end
