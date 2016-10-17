//
//  Question.m
//  VetX
//
//  Created by YulianMobile on 2/9/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "Question.h"

@implementation Question

+ (NSString *)primaryKey {
    return @"questionID";
}

+ (NSArray *)requiredProperties {
    return @[@"score", @"published", @"questionID", @"questionTitle"];
}

+ (NSArray *)indexedProperties {
    return @[@"questionTitle", @"questionID"];
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"questionDetails": @"",
             @"category": @"",
             @"score": [NSNumber numberWithFloat:0.0f],
             @"published": [NSDate date],
             @"questionID": @"",
             @"questionPetID":@""
             };
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

- (id)initWithMantleQuestionModel:(QuestionModel *)questionModel {
    self = [super init];
    if(!self) return nil;
    
    self.questionID      = questionModel.questionID;
    self.questionTitle   = questionModel.questionTitle;
    self.questionDetails = questionModel.questionDetails;
    self.category        = questionModel.category;
    self.user            = [[User alloc] initWithMantleUserModel:questionModel.user];
    self.score           = questionModel.score;
    self.questionPetID   = questionModel.questionPetID;
    self.published       = questionModel.questionPublished;
    self.questionImage   = questionModel.questionImage;
    for (AnswerModel *answerModel in questionModel.answers) {
        Answer *answer = [[Answer alloc] initWithMantleAnswerModel:answerModel];
        [self.answers addObject:answer];
    }
    
    return self;
}

@end
