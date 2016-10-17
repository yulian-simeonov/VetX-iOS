//
//  NSLocale+TimeSeparator.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 23/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "NSLocale+TimeSeparator.h"

@implementation NSLocale (TimeSeparator)

- (NSString *)timeSeparatorString {
    // Base the estimate on the iOS logic used for "Region Format"

    static NSSet *periodSet;
    static NSSet *dashSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Use a period, hh.mm
        //    Danish (Denmark) {DK}
        //    Finnish (Finland) {FI}
        //    Serbian Montenegro (Cyrillic) {ME}
        //    Serbian Montenegro (Latin) {ME}
        //    Serbian (Cyrillic) {RS}
        //    Serbian (Latin) {RS}
        periodSet = [NSSet setWithObjects:@"da_DK", @"fi_FI", @"sr_Latn_ME", @"sr_Cyrl_ME", @"sr_Latn_RS", @"sr_Cyrl_RS", nil];
        
        // Use a dash, hh-mm
        //    Marathi (India) {IN}
        dashSet = [NSSet setWithObjects:@"mr_IN", nil];
    });

    if ([periodSet containsObject:self.localeIdentifier])
        return @".";
    
    if ([dashSet containsObject:self.localeIdentifier])
        return @"-";
    
    return @":";
}

@end
