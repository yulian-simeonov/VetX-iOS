//
//  QuestionModel.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "QuestionModel.h"
#import "AnswerModel.h"

@interface QuestionModel ()

@end

@implementation QuestionModel


+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"questionTitle":@"title",
             @"category":@"category",
             @"score":@"score",
             @"questionPublished":@"published",
             @"user":@"user",
             @"answers":@"answers",
             @"questionID":@"id",
             @"questionDetails":@"detail",
             @"questionPetID":@"pet",
             @"questionImage":@"image"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UserModel.class];
}

+ (NSValueTransformer *)answersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:AnswerModel.class];
}

+ (NSValueTransformer *)questionPublishedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}
//- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
//    if (self = [super init]) {
//        self.questionTitle = [responseObject objectForKey:@"text"];
//        self.category = [responseObject objectForKey:@"category"];
//        self.score = [(NSNumber *)[responseObject objectForKey:@"score"] integerValue];
//        self.published = [responseObject objectForKey:@"published"];
//        self.answers = [responseObject objectForKey:@"answers"];
//        self.user = [[UserModel alloc] initWithResponseObject:[responseObject objectForKey:@"user"]];
//    }
//    
//    return self;
//}

@end
