//
//  HDUserInfoNormalCell.m
//  
//
//  Created by 王磊 on 2016/12/21.
//
//

#import "HDUserInfoNormalCell.h"
#import "HDUserInfoCellModel.h"

@interface HDUserInfoNormalCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation HDUserInfoNormalCell

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
