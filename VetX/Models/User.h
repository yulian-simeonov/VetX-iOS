//
//  User.h
//  VetX
//
//  Created by YulianMobile on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserModel.h"
#import "PetModel.h"
#import "Pet.h"

@interface User : RLMObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *emailAddress;
@property NSString *token;
@property NSString *profileURL;
@property NSString *userID;
@property NSString *customerID;
@property NSString *licenseID;
@property NSString *clinicID;
@property NSString *bio;
@property RLMArray <Pet *><Pet> *pets;
@property NSString *createdDate;
@property NSString *lastUpdateTime;

- (id)initWithMantleUserModel:(UserModel *)userModel;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<User>
RLM_ARRAY_TYPE(User)
