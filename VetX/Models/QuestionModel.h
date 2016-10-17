//
//  QuestionModel.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserModel.h"

@interface QuestionModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *questionPetID;
@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSString *questionDetails;
@property (nonatomic, copy) NSString *questionImage;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) UserModel *user;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSDate *questionPublished;
@property (nonatomic, copy) NSArray *answers;

//- (instancetype)initWithResponseObject:(NSDictionary *)responseObject;

@end
