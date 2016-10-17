//
//  Consultation.m
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "Consultation.h"

@implementation Consultation

+ (NSString *)primaryKey {
    return @"consultationID";
}

+ (NSArray *)requiredProperties {
    return @[@"created", @"consultationID", @"transactionID"];
}


+ (NSArray *)indexedProperties {
    return @[@"consultationID"];
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"transactionID": @"",
             @"consultationID": @"",
             @"type": @"text",
             @"consultationTitle": @"",
             @"created": [NSDate date],
             @"finished": @0
             };
}

- (id)initWithMantleConsultationModel:(ConsultationModel *)consultationModel {
    self = [super init];
    if(!self) return nil;
    
    self.consultationID = consultationModel.consultationID;
    self.type = consultationModel.type;
    self.transactionID = consultationModel.transactionId;
    self.consultationTitle = consultationModel.question;
    self.finished = consultationModel.finished;
    self.user = [[User alloc] initWithMantleUserModel:consultationModel.user];
    if (consultationModel.vet) {
        self.vet = [[User alloc] initWithMantleUserModel:consultationModel.vet];
    }
    self.created = consultationModel.createdDate;
    
    return self;
}

@end
