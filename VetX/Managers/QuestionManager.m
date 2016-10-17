//
//  QuestionManager.m
//  VetX
//
//  Created by Liam Dyer on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "QuestionManager.h"
#import "NetworkManager.h"
#import <Realm/Realm.h>
#import <RBQFetchedResultsController/RBQFRC.h>
#import "APIs.h"
#import "QuestionModel.h"
#import "QuestionResponseModel.h"
#import "Question.h"
#import "NSArray+BlocksKit.h"
#import "NSDictionary+WithoutNilValue.h"
#import "ConsultationResponseModel.h"
#import "ConsultationModel.h"
#import "Consultation.h"

@interface QuestionManager ()

@property (nonatomic) dispatch_queue_t realmQueue;
@property (nonatomic, strong) NSTimer *feedTimer;

@end

@implementation QuestionManager

+ (QuestionManager *)defaultManager {
    static QuestionManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[QuestionManager alloc] init];
        s_manager.realmQueue = dispatch_queue_create("com.vetx.realm.question", DISPATCH_QUEUE_SERIAL);
    });
    return s_manager;
}

- (void)getFeedWithParameter:(QuestionRequestModel *)requestModel {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil] withoutNilValue];
    [[NetworkManager defaultManager] getRequestFromURL:FEED andParameters:parameters withAuth:NO andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        QuestionResponseModel *list = [MTLJSONAdapter modelOfClass:QuestionResponseModel.class
                                                   fromJSONDictionary:responseDictionary error:&error];
        [self storeFeedRespModelToRealm:list];
    } andError:^(NSError *error) {
        
    }];
}

- (void)getSuggestionsWithParameter:(SuggestionRequestModel *)requestModel andSuccess:(void (^)(NSArray *questions))successBlock {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil] withoutNilValue];
    [[NetworkManager defaultManager] getRequestFromURL:SUGGEST andParameters:parameters withAuth:NO andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        QuestionResponseModel *response = [MTLJSONAdapter modelOfClass:QuestionResponseModel.class
                                                    fromJSONDictionary:responseDictionary error:&error];
        successBlock(response.questions);
        
    } andError:^(NSError *error) {
        
    }];
}

- (void)storeFeedRespModelToRealm:(QuestionResponseModel *)responseModel {
    dispatch_async(self.realmQueue, ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            for(QuestionModel *question in responseModel.questions){
                Question *questionRealm = [[Question alloc] initWithMantleQuestionModel:question];
                [realm addOrUpdateObject:questionRealm];
            }
            [realm commitWriteTransaction];
        }
    });
}

- (void)storeConsultationRespModelToRealm:(ConsultationResponseModel *)responseModel {
    dispatch_async(self.realmQueue, ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            for(ConsultationModel *consultation in responseModel.consultations){
                Consultation *consultationRealm = [[Consultation alloc] initWithMantleConsultationModel:consultation];
                [realm addOrUpdateObject:consultationRealm];
            }
            [realm commitWriteTransaction];
        }
    });
}

- (void)postQuestion:(PostQuestionRequestModel *)request andProfile:(NSData *)image {
   NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:request error:nil] withoutNilValue];
    [[NetworkManager defaultManager] postRequestToURL:QUESTION andParameter:parameters attachedData:image withAuth:YES andSuccess:^(id responseObject) {
    } andError:^(NSError *error) {
        NSLog(@"Fail to post question");
    }];
}


- (void)getUserQuestionsHistory:(QuestionRequestModel *)request complete:(void (^)(BOOL finished, NSError *error))completion {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:request error:nil] withoutNilValue];
    [[NetworkManager defaultManager] getRequestFromURL:QUESTION andParameters:parameters withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        QuestionResponseModel *list = [MTLJSONAdapter modelOfClass:QuestionResponseModel.class
                                                fromJSONDictionary:responseDictionary error:&error];
        [self storeFeedRespModelToRealm:list];
        completion(YES, nil);
    } andError:^(NSError *error) {
        NSLog(@"Fail to get response: %@", [error localizedDescription]);
        completion(NO, error);
    }];
}

- (void)answerQuestion:(NSString *)questionID answer:(QuestionRequestModel *)request complete:(void (^)(BOOL finished, NSError *error))completion {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:request error:nil] withoutNilValue];
    NSString *url = [NSString stringWithFormat:ANSWER_QUESTION, questionID];
    [[NetworkManager defaultManager] postRequestToURL:url andParameter:parameters withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        @try {
            NSDictionary *questionDic = [[responseDictionary objectForKey:@"data"] objectForKey:@"answers"][0];
            QuestionModel *question = [MTLJSONAdapter modelOfClass:QuestionModel.class fromJSONDictionary:questionDic error:nil];
            dispatch_async(self.realmQueue, ^{
                @autoreleasepool {
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    Question *questionRealm = [Question objectForPrimaryKey:questionID];
                    [realm deleteObject:questionRealm];
                    [realm commitWriteTransaction];
                }
            });
        } @catch (NSException *exception) {
            NSLog(@"Fail to store answer data: %@", exception);
        } @finally {
            if (error) {
                completion(YES, error);
            } else {
                completion(YES, nil);
            }
        }
    } andError:^(NSError *error) {
        NSLog(@"Error to post a new answer");
        completion(NO, error);
    }];
}

- (void)getVetOwnAnswersComplete:(void (^)(BOOL, NSError *error))complete {
    [[NetworkManager defaultManager] getRequestFromURL:VET_ANSWERS andParameters:@{} withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        QuestionResponseModel *list = [MTLJSONAdapter modelOfClass:QuestionResponseModel.class
                                                fromJSONDictionary:responseDictionary error:&error];
        [self storeFeedRespModelToRealm:list];
        NSLog(@"Success to get all the answers of one vet: %@", responseObject);
        complete(YES, nil);
    } andError:^(NSError *error) {
        NSLog(@"Error to get all the answers of the vet");
        complete(NO, error);
    }];
}

- (void)getUnansweredChatGroup:(NSString *)userID complete:(void (^)(BOOL finished, NSError *error))completion {
    NSDictionary *params;
    if (userID) {
        params = @{@"userID": userID};
    } else {
        params = @{};
    }
    
    [[NetworkManager defaultManager] getRequestFromURL:UNANSWERED_CHAT_GROUP andParameters:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        NSLog(@"response: %@", responseDictionary);
        ConsultationResponseModel *list = [MTLJSONAdapter modelOfClass:ConsultationResponseModel.class
                                                fromJSONDictionary:responseDictionary error:&error];
        [self storeConsultationRespModelToRealm:list];
        completion(YES, nil);
    } andError:^(NSError *error) {
        NSLog(@"error to get group: %@", [error localizedDescription]);
        completion(NO, error);
    }];
}

- (void)getConsultationHistory:(NSString *)userID complete:(void (^)(BOOL finished, NSError *error))completion {
    NSDictionary *params;
    if (userID) {
        params = @{@"userID": userID};
    } else {
        params = @{};
    }
    
    [[NetworkManager defaultManager] getRequestFromURL:CHAT_HISTORY andParameters:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        ConsultationResponseModel *list = [MTLJSONAdapter modelOfClass:ConsultationResponseModel.class
                                                    fromJSONDictionary:responseDictionary error:&error];
        [self storeConsultationRespModelToRealm:list];
        completion(YES, nil);
    } andError:^(NSError *error) {
        NSLog(@"error to get group: %@", [error localizedDescription]);
        completion(NO, error);
    }];
}

- (void)endConsultation:(NSString *)group withUser:(NSString *)userID andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock{
    NSDictionary *params;
    if (userID && group) {
        params = @{@"userID":userID, @"groupID":group};
    } else {
        params = @{};
    }
    [[NetworkManager defaultManager] postRequestToURL:END_CONSULTATION andParameter:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        @try {
            ConsultationResponseModel *list = [MTLJSONAdapter modelOfClass:ConsultationResponseModel.class
                                                        fromJSONDictionary:responseDictionary error:&error];
            [self storeConsultationRespModelToRealm:list];
        } @catch (NSException *exception) {
            NSLog(@"Error to end consultation: %@", exception);
        }
        successBlock(YES);
    } andError:^(NSError *error) {
        NSLog(@"end consultation error: %@", error);
        errorBlock(error);
    }];
}

- (void)rotateFeedQuestions {
    self.feedTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(rotateQuestion) userInfo:nil repeats:YES];
}

- (void)rotateQuestion {
    dispatch_async(self.realmQueue, ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"score"
                                                                                    ascending:NO];
            RLMSortDescriptor *sortDescriptor2 = [RLMSortDescriptor sortDescriptorWithProperty:@"published" ascending:NO];
            RLMResults <Question *> *questions = [[Question allObjectsInRealm:realm] sortedResultsUsingDescriptors:@[sortDescriptor, sortDescriptor2]];
            if (questions.count != 0) {
                NSLog(@"rotate question");
                Question *last = [questions lastObject];
                [realm beginWriteTransaction];
                last.published = [NSDate date];
                [realm commitWriteTransaction];
            }
        }
    });
}

- (void)stopRotateFeedQuestions {
    [self.feedTimer invalidate];
    self.feedTimer = nil;
}

- (void)removeQuestions {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:[Consultation allObjects]];
        [realm commitWriteTransaction];
    }
}

@end
