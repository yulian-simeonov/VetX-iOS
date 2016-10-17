//
//  Answer.m
//  VetX
//
//  Created by YulianMobile on 2/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "Answer.h"

@implementation Answer

+ (NSString *)primaryKey {
    return @"answerID";
}

+ (NSArray *)indexedProperties {
    return @[@"answerID", @"answerDetail"];
}

+ (NSArray *)requiredProperties {
    return @[@"answerID", @"answerDetail"];
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"upVotes":[NSNumber numberWithInt:0],
             @"answerDetail":@"",
             @"answerTime":[NSDate date]};
}

- (id)initWithMantleAnswerModel:(AnswerModel *)answerModel {
    self = [super init];
    if(!self) return nil;
    
    self.answerID       = answerModel.answerID;
    self.answerVet      = [[User alloc] initWithMantleUserModel:answerModel.user];
    self.upVotes        = answerModel.score;
    self.answerTime     = answerModel.published;
    self.answerDetail   = answerModel.answerText;
    
    return self;
}

@end
