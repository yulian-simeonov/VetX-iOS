//
//  HNETimePickerLayout.h
//  HNETimePicker Example
//
//  Layout helper for the picker itself, reduces the complexity
//  in the picker implementation for determining frames for
//  various components and/or decorative views
//
//  Created by Henri Normak on 23/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

@import Foundation;
@import UIKit;

@protocol HNETimePickerLayoutDataSource;
@interface HNETimePickerLayout : NSObject

@property (nonatomic, weak) id <HNETimePickerLayoutDataSource> dataSource;

// Set if the components on the outside should extend all the way to the
// edge of the bounds. Only applies if bounds.width > boundingRect.width
// Defaults to NO
@property (nonatomic, assign) BOOL extendToEdges;

/**
 *  Reload the layout, asks data source for the information
 *  and recalculates the layout
 */
- (void)reloadLayout;

/**
 *  Bounding rect for the layout, as the bound parameter
 *  is ignored size wise during calculation, this is what allows
 *  determining the minimum needed size for the layout
 */
- (CGRect)boundingRect;

/**
 *  Accessing frames that have been calculated
 */
- (CGRect)frameForComponentAtIndex:(NSUInteger)idx;
- (CGRect)frameForSelectionViewAtIndex:(NSUInteger)idx;
- (CGRect)frameForSeparatorView;

@end

@protocol HNETimePickerLayoutDataSource <NSObject>

/**
 *  @param layout Layout object
 *
 *  @return Number of components in the layout
 */
- (NSUInteger)numberOfComponentsInLayout:(HNETimePickerLayout *)layout;

/**
 *  Limiting bounds for the layout, affects the placement
 *  of components
 *
 *  @param layout Layout object
 *
 *  @return Bounds for the layout, origin is respected, resulting frames
 *  are horizontally centered in the bounds
 */
- (CGRect)boundsForLayout:(HNETimePickerLayout *)layout;

/**
 *  Spacing between components, same value used between all components
 *
 *  @param layout Layout object
 *
 *  @return Spacing in points between components
 */
- (CGFloat)interComponentSpacingInLayout:(HNETimePickerLayout *)layout;

/**
 *  Element size for the specific component, allows differently
 *  sized selection and component frames per component
 *
 *  @param layout Layout object
 *  @param idx    Component index
 *
 *  @return Size of the elements in said component
 */
- (CGSize)layout:(HNETimePickerLayout *)layout elementSizeForComponentAtIndex:(NSUInteger)idx;

/**
 *  Index of separator, i.e before which component
 *  the separator should be placed. For example, returning
 *  0 means separator is before component at index 0,
 *  returning NSNotFound means separator frame is CGRectZero
 *
 *  @param layout Layout object
 *
 *  @return Index of separator
 */
- (NSUInteger)separatorIndexInLayout:(HNETimePickerLayout *)layout;

/**
 *  Separator size
 *
 *  @param layout Layout object
 *
 *  @return Size of the separator, used directly for the frame
 */
- (CGSize)separatorSizeInLayout:(HNETimePickerLayout *)layout;

/**
 *  Vertical placement of selection view, in unit coordinate
 *  system and referring to the vertical center of the selection
 *  view, i.e 0.5 refers to having a selection view that is vertically
 *  centered in the component frame
 *
 *  @param layout Layout object
 *  @param idx    Index of the component in question
 *
 *  @return Vertical offset in unit coordinate space
 */
- (CGFloat)layout:(HNETimePickerLayout *)layout selectionViewPositionForComponentAtIndex:(NSUInteger)idx;

@end