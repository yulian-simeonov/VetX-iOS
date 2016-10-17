//
//  Question.h
//  VetX
//
//  Created by YulianMobile on 2/9/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Realm/Realm.h>
#import "QuestionModel.h"
#import "User.h"
#import "Answer.h"

@interface Question : RLMObject

@property NSString *questionTitle;
@property NSString *questionDetails;
@property NSString *category;
@property User *user;
@property NSNumber<RLMFloat> *score;
@property NSDate *published;
@property RLMArray <Answer *><Answer> *answers;
@property NSString *questionID;
@property NSString *questionPetID;
@property NSString *questionImage;

- (id)initWithMantleQuestionModel:(QuestionModel *)questionModel;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<QuestionModel>
RLM_ARRAY_TYPE(Question)
