//
//  HDGroupMemberFootCell.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/20.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDGroupMemberFootCellDelegate;

@interface HDGroupMemberFootCell : UICollectionViewCell

@property (nonatomic, weak) id <HDGroupMemberFootCellDelegate> delegate;

@end

@protocol HDGroupMemberFootCellDelegate <NSObject>

- (void)didClickToExistGroup;

@end
