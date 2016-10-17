//
//  QuestionDetailsCell.h
//  VetX
//
//  Created by YulianMobile on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "User.h"

@protocol QuestionDetailsCellDelegate <NSObject>

- (void)shareQuestion:(Question *)questionObj;

@end

@interface QuestionDetailsCell : UITableViewCell

@property (nonatomic, assign) id<QuestionDetailsCellDelegate> delegate;

- (void)bindData:(Question *)question;

@end
