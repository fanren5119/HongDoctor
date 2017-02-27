//
//  HDGroupMemberCell.m
//  HongDoctor
//
//  Created by wanglei on 2016/12/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "HDGroupMemberCell.h"
#import "UIImageView+WebCache.h"
#import "HDGroupMemberCellModel.h"
#import "UIImage+GIF.h"

@interface HDGroupMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *senderSignImageView;

@end

@implementation HDGroupMemberCell

- (void)resetCellWithModel:(HDGroupMemberCellModel *)model
{
    self.nameLabel.text = model.memberName ? model.memberName : @"";
    if (model.type == EmptyCell) {
        self.contentImageView.hidden = YES;
        self.senderSignImageView.hidden = YES;
    } else if (model.type == AddMemberCell) {
        self.contentImageView.hidden = NO;
        self.contentImageView.image = [UIImage imageNamed:@"Group_bt_add"];
        self.senderSignImageView.hidden = YES;
    } else {
        self.contentImageView.hidden = NO;
        NSURL *url = [NSURL URLWithString:model.memberHeadURL];
        [self.contentImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
        
        if (model.isCompany == NO) {
            self.senderSignImageView.hidden = NO;
            self.senderSignImageView.image = [UIImage imageNamed:@"member_yun.png"];
        } else {
            self.senderSignImageView.hidden = YES;
        }
    }
}

@end
