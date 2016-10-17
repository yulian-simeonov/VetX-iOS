//
//  PetModel.h
//  VetX
//
//  Created by YulianMobile on 3/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PetModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *petID;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, copy) NSString *petBreed;
@property (nonatomic, copy) NSString *petType;
@property (nonatomic, assign) BOOL isMale;
@property (nonatomic, assign) BOOL isFixed;
@property (nonatomic, copy) NSDate *petBirthday;
@property (nonatomic, copy) NSString *petImageUrl;
@property (nonatomic, copy) NSArray *certificateOfHealth;
@property (nonatomic, copy) NSArray *invoiceRecord;
@property (nonatomic, copy) NSArray *laboratoryResults;
@property (nonatomic, copy) NSArray *other;
@property (nonatomic, copy) NSArray *patientChart;
@property (nonatomic, copy) NSArray *vaccinationRecord;

@end
