//
//  UserModel.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSArray *pets;
@property (nonatomic, copy) NSString *vetLicenseID;
@property (nonatomic, copy) NSString *vetClinicID;
@property (nonatomic, copy) NSString *userBio;

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject;

@end
