//
//  QuestionRequestModel.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface QuestionRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSNumber *limit;
@property (nonatomic, copy) NSNumber *offset;
@property (nonatomic, copy) NSDate *afterDate;
@property (nonatomic, copy) NSString *answer;

@end
