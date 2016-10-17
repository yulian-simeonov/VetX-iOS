//
//  Answer.h
//  VetX
//
//  Created by YulianMobile on 2/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Realm/Realm.h>
#import "User.h"
#import "AnswerModel.h"

@interface Answer : RLMObject

@property User *answerVet;
@property NSString *answerID;
@property NSDate *answerTime;
@property NSNumber<RLMInt> *upVotes;
@property NSString *answerDetail;

- (id)initWithMantleAnswerModel:(AnswerModel *)answerModel;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Answer>
RLM_ARRAY_TYPE(Answer)
