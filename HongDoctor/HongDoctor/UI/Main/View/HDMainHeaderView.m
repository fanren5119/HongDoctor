//
//  HDMainHeaderView.m
//  HongDoctor
//
//  Created by 王磊 on 2017/1/10.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "HDMainHeaderView.h"
#import "HDUserEntity.h"
#import "UIImageView+WebCache.h"

@interface HDMainHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation HDMainHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    HDUserEntity *userEntity = [HDLocalDataManager getUserEntity];
    NSURL *url = [NSURL URLWithString:userEntity.userHeadURL];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User_defalut.png"]];
    
    self.textField.textColor = [UIColor whiteColor];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attributes];
    self.textField.attributedPlaceholder = attStr;
}

- (IBAction)respondsToSearchButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectToSearchWithText:)]) {
        [self.delegate didSelectToSearchWithText: self.textField.text];
    }
}

- (IBAction)respondsToUserButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectHeadImageView)]) {
        [self.delegate didSelectHeadImageView];
    }
}

- (IBAction)respondsToAddButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectToAddButton)]) {
        [self.delegate didSelectToAddButton];
    }
}

@end
