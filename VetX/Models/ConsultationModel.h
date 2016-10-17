//
//  ConsultationModel.h
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserModel.h"

@interface ConsultationModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *consultationID;
@property (nonatomic, copy) NSString *transactionId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) UserModel *user;
@property (nonatomic, copy) UserModel *vet;
@property (nonatomic, copy) NSDate *createdDate;
@property (nonatomic, copy) NSNumber *finished;

@end
