//
//  HNETimePickerComponentLayout.h
//  HNETimePicker Example
//
//  Responsible for producing the layout
//  needed for each of the time picker columns
//
//  Allows defining a "selection" offset on the axis
//  the collection view scrolls on, this offset defines
//  how alpha of objects is altered during scrolling and
//  how the snapping behaviour works to make sure an object
//  ends up aligned with the offset point
//
//  Also automatically adds insets for the content by shifting
//  the content down and making it taller, this is to make
//  sure every single element of the collection can appear at
//  the selectionOffset point
//
//  Created by Henri Normak on 07/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

@import UIKit;

@interface HNETimePickerComponentLayout : UICollectionViewFlowLayout

/**
 *  Unit value, defaults to 0.5 (center)
 *  Defines a point on the scrollable axis of the collection
 *  view, where items are generally snapped to and from which
 *  alpha changes radiate towards the edges
 */
@property (nonatomic, assign) CGFloat selectionOffset;

/**
 *  Offset from the center from which the alpha change begins
 *  Also in unit value, defaults to 0.05. Unit space is the
 *  distance between -selectionOffset and the respective edge 
 *  (top/bottom, left/right)
 */
@property (nonatomic, assign) CGFloat alphaOffset;

/**
 *  These two dictate the range in which the alpha of each
 *  cell must be, maximum should be larger than minimum, but
 *  is not enforced. Calculation interpolates between min and max,
 *  which by default are 0 and 1
 */
@property (nonatomic, assign) CGFloat minimumAlpha;
@property (nonatomic, assign) CGFloat maximumAlpha;

/**
 *  Return the index path of the item that is deemed
 *  as selected, i.e the one that is sitting on -selectionOffset
 *
 *  @return Index path
 */
- (NSIndexPath *)indexPathOfSelectedItem;

/**
 *  Estimated content offset for marking a specific item as selected
 *  i.e positioning it at the selectionOffset
 *
 *  @param path Index path of the item that needs to be selected
 *
 *  @return Content offset for the collection view that displays the
 *  given index path at the selection offset. Might be < 0 and > content size
 */
- (CGPoint)contentOffsetForSelectingItemAtIndexPath:(NSIndexPath *)path;

@end
