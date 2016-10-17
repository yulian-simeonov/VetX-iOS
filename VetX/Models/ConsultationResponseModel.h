//
//  ConsultationResponseModel.h
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserModel.h"

@interface ConsultationResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *consultations;
@property (nonatomic, copy) NSError *error;

@end
