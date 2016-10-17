//
//  SuggestionRequestModel.m
//  VetX
//
//  Created by Liam Dyer on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "SuggestionRequestModel.h"

@implementation SuggestionRequestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"text": @"text"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

@end
