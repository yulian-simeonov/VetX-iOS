//
//  PostQuestionRequestModel.h
//  VetX
//
//  Created by YulianMobile on 3/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PostQuestionRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSString *questionDetails;
@property (nonatomic, copy) NSString *questionCategory;
@property (nonatomic, copy) NSString *questionPetID;
@property (nonatomic, copy) NSData *questionImage;

@end
