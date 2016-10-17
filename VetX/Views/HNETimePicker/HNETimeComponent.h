//
//  HNETimeComponent.h
//  HNETimePicker Example
//
//  A simple backing model object for HNETimePicker
//  allows for the picker to be properly internationalised
//  and also lifts some of the logic out into a more manageable
//  component
//
//  Created by Henri Normak on 06/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, HNETimeComponentUnit) {
    HNETimeComponentUnitHour = NSCalendarUnitHour,
    HNETimeComponentUnitMinute = NSCalendarUnitMinute,
    HNETimeComponentUnitAMPM = (1 << 16),
};

@interface HNETimeComponent : NSObject

/**
 *  Unit of the component, notice the custom type that is
 *  somewhat equivalent to NSCalendarUnit
 */
@property (nonatomic, readonly) HNETimeComponentUnit unit;

/**
 *  Whether the component is zero padded, i.e 1-23 vs 01-23 for hours
 *  for example
 */
@property (nonatomic, readonly, getter=isZeroPadded) BOOL zeroPadded;

/**
 *  Selected index, used for converting to NSDateComponents and can be used
 *  otherwise as well
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/**
 *  Create an array of time components for a date format template
 *  (uses NSDateFormatter +dateFormatFromTemplate:options:locale:)
 *
 *  @param formatTemplate For additional instructions see NSDateFormatter
 *  @param locale         Locale for the template (pass in nil for current locale)
 *
 *  @return Array of HNETimeComponent objects or nil if formatTemplate does not produce any
 */
+ (NSArray *)timeComponentsFromDateFormatTemplate:(NSString *)formatTemplate locale:(NSLocale *)locale;

/**
 *  Similar to the the simpler variant, with the additional
 *  ability of defining the initial selection via the date argument
 *
 *  @param formatTemplate For additional instructions see NSDateFormatter
 *  @param locale         Locale for the template (pass in nil for current locale)
 *  @param date           Date to use for initial values
 *
 *  @return Array of HNETimeComponent objects or nil if formatTemplate does not produce any
 */
+ (NSArray *)timeComponentsFromDateFormatTemplate:(NSString *)formatTemplate locale:(NSLocale *)locale date:(NSDate *)date;

#pragma mark -
#pragma mark Data methods

/**
 *  Number of elements in this component, passing in anything higher than
 *  this value to the following methods will throw an exception
 *
 *  @return Number of elements in the component
 */
- (NSUInteger)numberOfElements;

/**
 *  String value for a specific element in the component
 *
 *  @param idx Index of the element, refer to -numberOfElements for limitations
 *
 *  @return String representing the element at given index
 */
- (NSString *)stringValueForElementAtIndex:(NSUInteger)idx;

#pragma mark -
#pragma mark NSDateComponents bridge

/**
 *  Convert time components into NSDateComponents
 *
 *  @param timeComponents Array of HNETimeComponent objects to be converted
 *
 *  @return NSDateComponents representing the time components
 */
+ (NSDateComponents *)dateComponentsFromTimeComponents:(NSArray *)timeComponents;

@end
