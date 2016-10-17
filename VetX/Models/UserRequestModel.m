//
//  UserRequestModel.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "UserRequestModel.h"

@implementation UserRequestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"firstName": @"firstName",
             @"lastName": @"lastName",
             @"email": @"email",
             @"password": @"password",
             @"confirmPassword": @"repeatPassword",
             @"userID": @"userID",
             @"vetLicenseID":@"licenseId",
             @"clinicID":@"clinicId",
             @"isVet":@"isVet",
             @"userBio":@"bio"
             };
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

#pragma mark - JSON Transformers


@end
