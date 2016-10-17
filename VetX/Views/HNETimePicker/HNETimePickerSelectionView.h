//
//  HNETimePickerSelectionView.h
//  HNETimePicker Example
//
//  Internal view used to highlight the selection
//  and provide a frame for it
//
//  Created by Henri Normak on 20/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE
@interface HNETimePickerSelectionView : UIView

/**
 *  Corner radius, use clamped to >= 0
 *  Defaults to 4.f
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/**
 *  Width of the stroke
 *  Defaults to 2.f
 */
@property (nonatomic, assign) IBInspectable CGFloat strokeWidth UI_APPEARANCE_SELECTOR;

/**
 *  Color of the stroke
 *  Defaults to black
 */
@property (nonatomic, strong) IBInspectable UIColor *strokeColor UI_APPEARANCE_SELECTOR;

@end
