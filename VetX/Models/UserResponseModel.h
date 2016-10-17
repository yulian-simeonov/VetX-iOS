//
//  UserResponseModel.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserModel.h"

@interface UserResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) UserModel *user;
@property (nonatomic, copy) NSArray *users;
@property (nonatomic, copy) NSError *error;

@end
