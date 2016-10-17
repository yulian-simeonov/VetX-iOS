//
//  Pet.h
//  VetX
//
//  Created by YulianMobile on 3/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Realm/Realm.h>
#import "PetModel.h"
#import "Record.h"

typedef enum : NSUInteger {
    MaleNeutered,
    MaleNotNeutered,
    FemaleSpayed,
    FemaleNotSpayed
} PetSex;

@interface Pet : RLMObject

@property NSString *petID;
@property NSString *name;
@property NSString *breed;
@property NSString *type;
@property BOOL isMale;
@property BOOL isFixed;
@property NSString *imageURL;
@property NSDate *birthday;
@property RLMArray <Record *><Record> *certificateOfHealth;
@property RLMArray <Record *><Record> *invoiceRecord;
@property RLMArray <Record *><Record> *laboratoryResults;
@property RLMArray <Record *><Record> *other;
@property RLMArray <Record *><Record> *patientChart;
@property RLMArray <Record *><Record> *vaccinationRecord;

@property NSString *createdDate;
@property NSString *lastUpdateTime;
@property (readonly) NSArray *owners;

- (id)initWithMantlePetModel:(PetModel *)petModel;

- (PetSex)getSexType;

- (NSString *)getPetBirthday;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Pet>
RLM_ARRAY_TYPE(Pet)
