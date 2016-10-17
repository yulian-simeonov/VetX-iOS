//
//  QuestionManager.h
//  VetX
//
//  Created by Liam Dyer on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionRequestModel.h"
#import "SuggestionRequestModel.h"
#import "PostQuestionRequestModel.h"

@interface QuestionManager : NSObject

+ (QuestionManager *)defaultManager;

- (void)getFeedWithParameter:(QuestionRequestModel *)requestModel;
- (void)getSuggestionsWithParameter:(SuggestionRequestModel *)requestModel
                         andSuccess:(void (^)(NSArray *questions))successBlock;
- (void)postQuestion:(PostQuestionRequestModel *)request andProfile:(NSData *)image;
- (void)getUserQuestionsHistory:(QuestionRequestModel *)request complete:(void (^)(BOOL finished, NSError *error))completion;

- (void)answerQuestion:(NSString *)questionID answer:(QuestionRequestModel *)request complete:(void (^)(BOOL finished, NSError *error))completion;
- (void)getVetOwnAnswersComplete:(void (^)(BOOL finished, NSError *error))complete;

- (void)rotateFeedQuestions;
- (void)stopRotateFeedQuestions;

- (void)getUnansweredChatGroup:(NSString *)userID complete:(void (^)(BOOL finished, NSError *error))completion;
- (void)getConsultationHistory:(NSString *)userID complete:(void (^)(BOOL finished, NSError *error))completion;
- (void)endConsultation:(NSString *)group
               withUser:(NSString *)userID
             andSuccess:(void (^)(BOOL finished))successBlock
               andError:(void (^)(NSError *error))errorBlock;;

- (void)removeQuestions;

@end
