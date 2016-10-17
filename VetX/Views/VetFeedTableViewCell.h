//
//  VetFeedTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 5/20/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol VetFeedTableViewCellDelegate <NSObject>

- (void)didClickAnswerButton:(NSIndexPath *)indexPath;

@end

@interface VetFeedTableViewCell : UITableViewCell

@property (nonatomic, assign) id<VetFeedTableViewCellDelegate> delegate;

- (void)bindQuestionData:(Question *)questionObj indexPath:(NSIndexPath *)indexPath;

@end
