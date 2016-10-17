//
//  NSDictionary+WithoutNilValue.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "NSDictionary+WithoutNilValue.h"

@implementation NSDictionary (WithoutNilValue)

- (NSDictionary *)withoutNilValue {
    NSMutableDictionary *modifiedDictionaryValue = [super mutableCopy];
    
    for (NSString *originalKey in self) {
        if ([self valueForKey:originalKey] == [NSNull null]) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }
    
    return [modifiedDictionaryValue copy];
}

@end
