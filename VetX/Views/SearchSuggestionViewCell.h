//
//  SearchSuggestionViewCell.h
//  VetX
//
//  Created by Liam Dyer on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface SearchSuggestionViewCell : UITableViewCell

- (void)bindQuestionData:(QuestionModel *)question;

@end
