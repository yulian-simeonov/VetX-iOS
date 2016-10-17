//
//  AddPetRequestModel.h
//  VetX
//
//  Created by YulianMobile on 3/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AddPetRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *petID;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, copy) NSString *petType;
@property (nonatomic, copy) NSString *petBreed;
@property (nonatomic, copy) NSString *petSex;
@property (nonatomic, assign) BOOL isFixed;
@property (nonatomic, copy) NSDate *petBirthday;

@end
