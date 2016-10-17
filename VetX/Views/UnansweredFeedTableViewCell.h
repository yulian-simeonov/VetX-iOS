//
//  UnansweredFeedTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 3/15/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol UnansweredFeedCellDelegate <NSObject>

- (void)shareQuestion:(Question *)question;
- (void)clickAnswerBtn:(NSIndexPath *)indexPath answer:(NSString *)answerStr;

@end

@interface UnansweredFeedTableViewCell : UITableViewCell

@property (nonatomic, assign) id<UnansweredFeedCellDelegate> delegate;
@property (nonatomic, strong) UITextView *answerField;

- (void)bindQuestionData:(Question *)questionObj indexPath:(NSIndexPath *)indexPath;
- (void)setSelectedCell:(BOOL)isSelected;

@end
