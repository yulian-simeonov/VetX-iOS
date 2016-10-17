//
//  ConsultationResponseModel.m
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ConsultationResponseModel.h"
#import "ConsultationModel.h"

@implementation ConsultationResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"consultations" : @"data",
             @"error" : @"error"
             };
}

+ (NSValueTransformer *)consultationsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ConsultationModel.class];
}

@end
