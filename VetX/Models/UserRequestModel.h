//
//  UserRequestModel.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPassword;
@property (nonatomic, copy) NSString *vetLicenseID;
@property (nonatomic, copy) NSString *clinicID;
@property (nonatomic, copy) NSString *isVet;
@property (nonatomic, copy) NSString *userBio;

@end
