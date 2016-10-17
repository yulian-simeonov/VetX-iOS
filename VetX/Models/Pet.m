//
//  Pet.m
//  VetX
//
//  Created by YulianMobile on 3/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "Pet.h"
#import "Record.h"
#import "User.h"

@implementation Pet

+ (NSString *)primaryKey {
    return @"petID";
}

+ (NSArray<NSString *> *)requiredProperties {
    return @[@"name", @"breed", @"type", @"age", @"owner", @"isMale", @"isFixed"];
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[@"petID", @"name"];
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"imageURL": @""
             };
}


- (id)initWithMantlePetModel:(PetModel *)petModel {
    self = [super init];
    if(!self) return nil;
    
    self.petID    = petModel.petID;
    self.name     = petModel.petName;
    self.breed    = petModel.petBreed;
    self.type     = petModel.petType;
    self.imageURL = petModel.petImageUrl;
    self.birthday      = petModel.petBirthday;
    self.isMale   = petModel.isMale;
    self.isFixed  = petModel.isFixed;
    for (NSString *recordURL in petModel.certificateOfHealth) {
        Record *record = [[Record alloc] initWithMantleRecordURL:recordURL];
        [self.certificateOfHealth addObject:record];
    }
    for (NSString *recordURL in petModel.invoiceRecord) {
        Record *record = [[Record alloc] initWithMantleRecordURL:recordURL];
        [self.invoiceRecord addObject:record];
    }
    for (NSString *recordURL in petModel.laboratoryResults) {
        Record *record = [[Record alloc] initWithMantleRecordURL:recordURL];
        [self.laboratoryResults addObject:record];
    }
    for (NSString *recordURL in petModel.other) {
        Record *record = [[Record alloc] initWithMantleRecordURL:recordURL];
        [self.other addObject:record];
    }
    for (NSString *recordURL in petModel.patientChart) {
        Record *record = [[Record alloc] initWithMantleRecordURL:recordURL];
        [self.patientChart addObject:record];
    }
    for (NSString *recordURL in petModel.vaccinationRecord) {
        Record *record = [[Record alloc] initWithMantleRecordURL:recordURL];
        [self.vaccinationRecord addObject:record];
    }
    
    return self;
}

+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"owners": [RLMPropertyDescriptor descriptorWithClass:User.class propertyName:@"pets"],
             };
}
//
//- (NSArray *)owners {
//    return [self linkingObjectsOfClass:@"User" forProperty:@"pets"];
//}

- (NSString *)getPetBirthday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.mmm'Z'";
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self.birthday];
}

- (PetSex)getSexType {
    if (!self.isMale && !self.isFixed) {
        return FemaleNotSpayed;
    } else if (!self.isMale && self.isFixed) {
        return FemaleSpayed;
    } else if (self.isMale && self.isFixed) {
        return MaleNeutered;
    } else {
        return MaleNotNeutered;
    }
}

@end
