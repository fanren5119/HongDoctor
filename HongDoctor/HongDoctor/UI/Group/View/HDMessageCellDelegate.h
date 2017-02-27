//
//  HDMessageCellProtocol.h
//  HongDoctor
//
//  Created by 王磊 on 2016/12/22.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDMessageCellModel.h"
#import "ZGAudioManager.h"

@protocol HDMessageCellDelegate <NSObject>


- (void)didClickHeadImage:(HDMessageCellModel *)model;
- (void)didClickToPlayAudio:(HDMessageCellModel *)model stauts:(E_AudioStatus)status;
- (void)didClickToPlayVideo:(HDMessageCellModel *)model;
- (void)didClickToReSendMessage:(HDMessageCellModel *)model;

- (void)didClickToPressCell:(UITableViewCell *)cell messsage:(HDMessageCellModel *)model;
- (void)didClickToScanImage:(HDMessageCellModel *)model;
- (void)didClickToScanLocation:(HDMessageCellModel *)model;

@end
