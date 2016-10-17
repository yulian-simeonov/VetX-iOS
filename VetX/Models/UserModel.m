//
//  UserModel.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "UserModel.h"
#import "PetModel.h"

@implementation UserModel

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"firstName":@"firstName",
             @"lastName":@"lastName",
             @"email":@"email",
             @"imageURL":@"image",
             @"userID":@"id",
             @"token":@"token",
             @"customerID":@"customerID",
             @"pets":@"pets",
             @"vetLicenseID":@"licenseId",
             @"vetClinicID":@"clinicId",
             @"userBio":@"bio"
             };
}


- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
    if (self = [super init]) {
        self.firstName  = [responseObject objectForKey:@"firstName"];
        self.lastName   = [responseObject objectForKey:@"lastName"];
        self.email      = [responseObject objectForKey:@"email"];
        self.imageURL   = [responseObject objectForKey:@"image"];
        self.customerID = [responseObject objectForKey:@"customerID"];
        self.userID     = [responseObject objectForKey:@"_id"];
        self.token      = [responseObject objectForKey:@"token"];
        self.vetClinicID = [responseObject objectForKey:@"clinicId"];
        self.vetLicenseID = [responseObject objectForKey:@"licenseId"];
        self.userBio = [responseObject objectForKey:@"bio"];
    }
    
    return self;
}

+ (NSValueTransformer *)petsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *petsArray, BOOL *success, NSError *__autoreleasing *error) {
        NSError *err = nil;
        return [MTLJSONAdapter modelsOfClass:[PetModel class] fromJSONArray:petsArray error:&err];
    } reverseBlock:^id(NSArray *pets, BOOL *success, NSError *__autoreleasing *error) {
        NSError *err = nil;
        return [MTLJSONAdapter JSONArrayFromModels:pets error:&err];
    }];
}

@end
