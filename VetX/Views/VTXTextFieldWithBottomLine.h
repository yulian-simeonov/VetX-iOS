//
//  VTXTextFieldWithBottomLine.h
//  VetX
//
//  Created by YulianMobile on 4/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTXTextFieldWithBottomLine : UITextField

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

//- (void)addTitleLabel:(NSString *)titleString;
- (void)addDownArrow;

@end
