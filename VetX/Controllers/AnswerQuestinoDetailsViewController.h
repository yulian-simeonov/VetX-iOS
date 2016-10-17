//
//  AnswerQuestinoDetailsViewController.h
//  VetX
//
//  Created by YulianMobile on 5/21/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "VTXViewController.h"

@interface AnswerQuestinoDetailsViewController : VTXViewController

- (instancetype)initWithData:(Question *)question;

@end
