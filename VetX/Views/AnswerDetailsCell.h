//
//  AnswerDetailsCell.h
//  VetX
//
//  Created by YulianMobile on 2/9/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AnswerDetailsCell : UITableViewCell

- (void)bindData:(Answer *)answer;

@end
