//
//  QuestionResponseModel.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "QuestionResponseModel.h"
#import "QuestionModel.h"
#import "AnswerModel.h"

@implementation QuestionResponseModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"questions" : @"data",
             @"error" : @"error"
             };
}

+ (NSValueTransformer *)questionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:QuestionModel.class];
}


@end
