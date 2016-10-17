//
//  AddPetRequestModel.m
//  VetX
//
//  Created by YulianMobile on 3/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AddPetRequestModel.h"

@implementation AddPetRequestModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"petID": @"id",
             @"petName": @"name",
             @"petType": @"type",
             @"petBreed": @"breed",
             @"petSex": @"sex",
             @"isFixed":@"isFixed",
             @"petBirthday": @"age"
             };
}

+ (NSValueTransformer *)petBirthdayJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
