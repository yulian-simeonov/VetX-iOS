//
//  QuestionDetailViewController.h
//  VetX
//
//  Created by YulianMobile on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "VTXViewController.h"

@interface QuestionDetailViewController : VTXViewController

- (instancetype)initWithData:(Question *)question;

@end
