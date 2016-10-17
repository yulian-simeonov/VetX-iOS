//
//  User.m
//  VetX
//
//  Created by YulianMobile on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSString *)primaryKey {
    return @"userID";
}

+ (NSArray *)requiredProperties {
    return @[@"firstName", @"lastName", @"userID"];
}

+ (NSArray *)indexedProperties {
    return @[@"firstName", @"lastName", @"emailAddress", @"userID"];
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"firstName": @"",
             @"lastName": @"",
             @"emailAddress": @"",
             @"userID": @"",
             @"customerID": @"",
             @"clinicID":@"",
             @"licenseID":@"",
             @"bio":@"",
             @"emailAddress": @""
             };
}

// Specify properties to ignore (Realm won't persist these)

- (id)initWithMantleUserModel:(UserModel *)userModel{
    self = [super init];
    if(!self) return nil;

    self.firstName    = userModel.firstName;
    self.lastName     = userModel.lastName;
    self.emailAddress = userModel.email;
    self.userID       = userModel.userID;
    self.profileURL   = userModel.imageURL;
    self.customerID   = userModel.customerID;
    self.token        = userModel.token;
    self.licenseID    = userModel.vetLicenseID;
    self.clinicID     = userModel.vetClinicID;
    self.bio          = userModel.userBio;
    for (PetModel *petModel in userModel.pets) {
        Pet *pet = [[Pet alloc] initWithMantlePetModel:petModel];
        [self.pets addObject:pet];
    }
    
    
    return self;
}

@end
