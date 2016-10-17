//
//  PendingChatTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 4/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consultation.h"

@protocol PendingChatTableViewCellDelegate <NSObject>

- (void)didClickEndChatBtn:(NSIndexPath *)indexPath;
- (void)didClickReplyBtn:(NSIndexPath *)indexPath;

@end

@interface PendingChatTableViewCell : UITableViewCell

@property (nonatomic, assign) id<PendingChatTableViewCellDelegate> delegate;
- (void)bindData:(Consultation *)consultation indexPath:(NSIndexPath *)indexPath;
- (void)bindWithUserData:(Consultation *)consultation indexPath:(NSIndexPath *)indexPath;
- (void)finishedConsultation;
@end
