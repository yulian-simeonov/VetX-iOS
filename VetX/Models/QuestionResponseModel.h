//
//  QuestionResponseModel.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserModel.h"

@interface QuestionResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSError *error;

@end
