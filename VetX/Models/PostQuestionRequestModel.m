//
//  PostQuestionRequestModel.m
//  VetX
//
//  Created by YulianMobile on 3/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "PostQuestionRequestModel.h"

@implementation PostQuestionRequestModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"questionTitle": @"title",
             @"questionDetails": @"detail",
             @"questionCategory": @"category",
             @"questionPetID": @"pet"
             };
}



@end
