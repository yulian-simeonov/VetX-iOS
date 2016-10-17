//
//  HNETimePicker.h
//  HNETimePicker Example
//
//  Customisable UIDatePicker alternative for time
//  pickers. Date change is reported as with UIDatePicker
//
//  Created by Henri Normak on 06/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

@import UIKit;

NS_CLASS_AVAILABLE_IOS(8_0) IB_DESIGNABLE
@interface HNETimePicker : UIControl

/**
 *  Date currently displayed on the picker
 *  Keep in mind that the date part is ignored
 *  and thus setting this with a non-today date
 *  will mean the picker resets the date to today
 *  upon next change by the user.
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  Locale for the picker, changes the layout
 *  of the picker, defaults to +autoupdatingCurrentLocale
 */
@property (nonatomic, copy) NSLocale *locale;

/**
 *  Animates the date change on the columns
 *
 *  @param date     Date to change to
 *  @param animated YES if the change should be animated
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

#pragma mark -
#pragma mark Appearance

/**
 *  Spacing between cells, likely vertical spacing, but should
 *  be viewed as the spacing between cells of the same column/row
 *  Defaults to 4.f
 */
@property (nonatomic, assign) IBInspectable CGFloat interCellSpacing;

/**
 *  Spacing between components, likely horizontal spacing between
 *  columns, but should be viewed as more abstract spacing between
 *  components, which can also be laid out vertically
 *  Defaults to 8.f
 */
@property (nonatomic, assign) IBInspectable CGFloat interComponentSpacing;


/**
 *  Corner radius of the selection highlight box
 *  Defaults to 4.f
 */
@property (nonatomic, assign) IBInspectable CGFloat selectionCornerRadius;

/**
 *  Stroke width of the selection hightlight
 *  Defaults to 2.f
 */
@property (nonatomic, assign) IBInspectable CGFloat selectionStrokeWidth;

/**
 *  Color of the selection highlight stroke
 *  Defaults to black
 */
@property (nonatomic, strong) IBInspectable UIColor *selectionStrokeColor;


/**
 *  Delta in alpha from the ~1.f used for the selected rows
 *  versus the alpha used for outer most cells, defaults
 *  to .7f;
 */
@property (nonatomic, assign) IBInspectable CGFloat cellAlphaDelta;

/**
 *  Font used by the individual rows
 *  Defaults to Dynamic Type body font, setting to nil returns to default
 */
@property (nonatomic, strong) IBInspectable UIFont *cellFont;

/**
 *  Kerning factor used by the individual rows
 *  Defaults to 0.f (i.e font default kerning factor)
 */
@property (nonatomic, assign) IBInspectable CGFloat cellKerningFactor;

/**
 *  Color for the cell text
 *  Defaults to nil (black)
 */
@property (nonatomic, strong) IBInspectable UIColor *cellTextColor;

/**
 *  Content inset for the individual cells
 *  Starts from the selection width (i.e 0 == selectionStrokeWidth from picker column dimensions)
 *  Defaults to 4.f/8.f (horizontal/vertical)
 */
@property (nonatomic, assign) UIEdgeInsets cellContentInset;

@end
