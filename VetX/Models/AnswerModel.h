//
//  AnswerModel.h
//  VetX
//
//  Created by YulianMobile on 4/13/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserModel.h"

@interface AnswerModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) UserModel *user;
@property (nonatomic, copy) NSString *answerID;
@property (nonatomic, copy) NSString *answerText;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSDate *published;

@end
