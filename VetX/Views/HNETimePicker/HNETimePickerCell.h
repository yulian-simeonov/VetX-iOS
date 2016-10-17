//
//  HNETimePickerCell.h
//  HNETimePicker Example
//
//  Created by Henri Normak on 20/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

@import UIKit;

@interface HNETimePickerCell : UICollectionViewCell

/**
 *  Label, spans the entire content view
 */
@property (nonatomic, readonly) UILabel *label;

/**
 *  Content insets, adjusts the frame of the contentView
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
