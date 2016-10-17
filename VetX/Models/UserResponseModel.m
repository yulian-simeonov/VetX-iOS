//
//  UserResponseModel.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "UserResponseModel.h"

@implementation UserResponseModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"user": @"data",
             @"error": @"error",
             @"users":@"data.users"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *userDict, BOOL *success, NSError *__autoreleasing *error) {
        NSError *err = nil;
        return [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:userDict error:&err];
    } reverseBlock:^id(UserModel *user, BOOL *success, NSError *__autoreleasing *error) {
        NSError *err = nil;
        return [MTLJSONAdapter JSONDictionaryFromModel:user error:&err];
    }];
}

@end
