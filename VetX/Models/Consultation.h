//
//  Consultation.h
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Realm/Realm.h>
#import "User.h"
#import "ConsultationModel.h"

@interface Consultation : RLMObject

@property NSString *consultationID;
@property User *user;
@property User *vet;
@property NSString *type;
@property NSString *transactionID;
@property NSString *consultationTitle;
@property NSDate *created;
@property NSNumber<RLMBool> *finished;

- (id)initWithMantleConsultationModel:(ConsultationModel *)consultationModel;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<Consultation>
RLM_ARRAY_TYPE(Consultation)
