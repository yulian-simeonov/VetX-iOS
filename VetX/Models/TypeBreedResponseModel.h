//
//  TypeBreedResponseModel.h
//  VetX
//
//  Created by YulianMobile on 4/27/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TypeBreedResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSDictionary *typeBreed;
@property (nonatomic, copy) NSError *error;

@end
