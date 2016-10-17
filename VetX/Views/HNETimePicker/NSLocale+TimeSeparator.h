//
//  NSLocale+TimeSeparator.h
//  HNETimePicker Example
//
//  Created by Henri Normak on 23/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (TimeSeparator)

/**
 *  Get the locale specific time separator string
 *  used between hours/minutes. Usually :, but can be .
 *  or even -
 *
 *  @return String to use as a separator between
 *  hours/minutes
 */
- (NSString *)timeSeparatorString;

@end
