//
//  HNETimeComponent.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 06/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "HNETimeComponent.h"

@interface HNETimeComponent ()

@property (nonatomic, readwrite, getter=isZeroPadded) BOOL zeroPadded;
@property (nonatomic, readwrite) HNETimeComponentUnit unit;

@property (nonatomic, readwrite) NSString *format;
@property (nonatomic, strong) NSArray *elementLabels;

@property (nonatomic, assign) NSRange elementRange;

/**
 *  Creating a time component
 *
 *  @param unit     Time unit the component represents
 *  @param isPadded Whether the component is zero padded or not
 *
 *  @return HNETimeComponent object
 */
- (instancetype)initWithUnit:(HNETimeComponentUnit)unit zeroPadded:(BOOL)isPadded;

@end

@implementation HNETimeComponent

- (instancetype)initWithUnit:(HNETimeComponentUnit)unit zeroPadded:(BOOL)isPadded {
    if ((self = [super init])) {
        self.unit = unit;
        self.zeroPadded = isPadded;
    }
    
    return self;
}

+ (NSArray *)timeComponentsFromDateFormatTemplate:(NSString *)formatTemplate locale:(NSLocale *)locale {
    return [self timeComponentsFromDateFormatTemplate:formatTemplate locale:locale date:nil];
}

+ (NSArray *)timeComponentsFromDateFormatTemplate:(NSString *)formatTemplate locale:(NSLocale *)locale date:(NSDate *)date {
    if (!locale)
        locale = [NSLocale currentLocale];
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:formatTemplate options:0 locale:locale];
    NSCharacterSet *nonalphabetic = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSArray *components = [formatString componentsSeparatedByCharactersInSet:nonalphabetic];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *componentString in components) {
        HNETimeComponentUnit unit = NSNotFound;
        BOOL padded = NO;
        NSRange range = NSMakeRange(NSNotFound, 0);
        
        if ([componentString isEqualToString:@"h"] || [componentString isEqualToString:@"hh"]) {
            unit = HNETimeComponentUnitHour;
            range = NSMakeRange(1, 12);
            if ([componentString isEqualToString:@"hh"])
                padded = YES;
        } else if ([componentString isEqualToString:@"H"] || [componentString isEqualToString:@"HH"]) {
            unit = HNETimeComponentUnitHour;
            range = NSMakeRange(0, 24);
            if ([componentString isEqualToString:@"HH"])
                padded = YES;
        } else if ([componentString isEqualToString:@"mm"]) {
            unit = HNETimeComponentUnitMinute;
            range = NSMakeRange(0, 60);
            padded = YES;
        } else if ([componentString isEqualToString:@"a"]) {
            unit = HNETimeComponentUnitAMPM;
            range = NSMakeRange(0, 2);
        }
        
        if (range.location != NSNotFound) {
            HNETimeComponent *component = [[HNETimeComponent alloc] initWithUnit:unit zeroPadded:padded];
            component.format = componentString;
            component.elementRange = range;
            
            // Generate the element strings for the component
            if (unit == HNETimeComponentUnitAMPM) {
                component.elementLabels = @[[calendar AMSymbol], [calendar PMSymbol]];
            } else {
                NSMutableArray *labels = [NSMutableArray array];
                
                for (NSUInteger i = range.location; i < NSMaxRange(range); i++) {
                    [labels addObject:[NSString stringWithFormat:padded ? @"%02lu" : @"%lu", (long unsigned)i]];
                }
                
                component.elementLabels = [labels copy];
            }
            
            [result addObject:component];
        }
    }
    
    if ([result count] == 0)
        return nil;
    
    // Prime with initial values (if we have a date object to use)
    if (date) {
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        NSUInteger minute = dateComponents.minute;
        NSUInteger hour = dateComponents.hour;
        NSUInteger ampmHour = hour;
        NSUInteger ampm = 0;
        
        if (hour == 0) {
            ampm = 0;
            ampmHour += 12;
        } else if (hour == 12) {
            ampm = 1;
        } else if (hour >= 13 && hour <= 23) {
            ampm = 1;
            ampmHour -= 12;
        }
        
        for (HNETimeComponent *component in result) {
            switch (component.unit) {
                case HNETimeComponentUnitMinute:
                    component.selectedIndex = minute;
                    break;
                case HNETimeComponentUnitHour:
                    if (NSEqualRanges(component.elementRange, NSMakeRange(1, 12)))
                        component.selectedIndex = ampmHour - component.elementRange.location;
                    else
                        component.selectedIndex = hour;
                    break;
                case HNETimeComponentUnitAMPM:
                    component.selectedIndex = ampm;
                    break;
                default:
                    break;
            }
        }
    }
    
    return [result copy];
}

#pragma mark -
#pragma mark Accessors

- (NSString *)description {
    NSString *unit;
    switch (self.unit) {
        case HNETimeComponentUnitHour:
            unit = @"Hour";
            break;
        case HNETimeComponentUnitMinute:
            unit = @"Minute";
            break;
        case HNETimeComponentUnitAMPM:
            unit = @"AM/PM";
            break;
        default:
            unit = nil;
            break;
    }
    
    NSString *padded = self.isZeroPadded ? @"YES" : @"NO";
    
    return [[super description] stringByAppendingFormat:@" Unit: %@ (format %@), padded: %@", unit, self.format, padded];
}

#pragma mark -
#pragma mark Data methods

- (NSUInteger)numberOfElements {
    return [self.elementLabels count];
}

- (NSString *)stringValueForElementAtIndex:(NSUInteger)idx {
    return [self.elementLabels objectAtIndex:idx];
}

#pragma mark -
#pragma mark Output

+ (NSDateComponents *)dateComponentsFromTimeComponents:(NSArray *)timeComponents {
    // Sort the array based on unit (ascending), this allows proper handling of am/pm as it will be handled
    // AFTER the hour component has been handled
    timeComponents = [timeComponents sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(unit)) ascending:YES]]];
    
    NSDateComponents *result = [[NSDateComponents alloc] init];
    NSInteger addedHour = 0;    // Offset we need to apply due to am/pm (only last of which is used)
    
    for (HNETimeComponent *component in timeComponents) {
        switch (component.unit) {
            case HNETimeComponentUnitMinute:
                result.minute = component.elementRange.location + component.selectedIndex;
                break;
            case HNETimeComponentUnitHour:
                result.hour = component.elementRange.location + component.selectedIndex;
                break;
            case HNETimeComponentUnitAMPM:
                if (component.selectedIndex == 0 && result.hour % 12 == 0) {
                    addedHour = -12;
                } else if (component.selectedIndex == 1 && result.hour >= 1 && result.hour <= 11) {
                    addedHour = 12;
                }
                break;
            default:
                break;
        }
    }
    
    result.hour += addedHour;
    return result;
}

@end
