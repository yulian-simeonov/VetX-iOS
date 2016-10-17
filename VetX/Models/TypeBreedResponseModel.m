//
//  TypeBreedResponseModel.m
//  VetX
//
//  Created by YulianMobile on 4/27/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "TypeBreedResponseModel.h"

@implementation TypeBreedResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"typeBreed" : @"data",
             @"error" : @"error"
             };
}

 /**
 *  Need to refactor API response design
 */
//+ (NSValueTransformer *)typeBreedJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:TypeBreedModel.class];
//}

@end
