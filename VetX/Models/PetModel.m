//
//  PetModel.m
//  VetX
//
//  Created by YulianMobile on 3/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "PetModel.h"

@implementation PetModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"petID":@"id",
             @"petName":@"name",
             @"petBreed":@"breed",
             @"petType":@"type",
             @"petBirthday":@"age",
             @"petImageUrl":@"image",
             @"isMale":@"isMale",
             @"isFixed":@"isFixed",
             @"certificateOfHealth": @"records.certificateOfHealth",
             @"invoiceRecord": @"records.invoiceRecord",
             @"laboratoryResults": @"records.laboratoryResults",
             @"other": @"records.other",
             @"patientChart": @"records.patientChart",
             @"vaccinationRecord": @"records.vaccinationRecord"
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
