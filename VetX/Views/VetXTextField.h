//
//  UNETextField.h
//  UNE
//
//  Created by YulianMobile on 11/24/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VetXTextField : UITextField

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

//- (void)addTitleLabel:(NSString *)titleString;
- (void)addDownArrow;
- (void)setTextFieldIcon:(UIImage *)icon;

@end
