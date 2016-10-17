//
//  ChangePasswordView.h
//  VetX
//
//  Created by YulianMobile on 1/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VetXTextField.h"

@protocol ChangePasswordDelegate <NSObject>

- (void)changePswdClicked;

@end

@interface ChangePasswordView : UIView

@property (nonatomic, assign) id<ChangePasswordDelegate> delegate;
@property (nonatomic, strong) VetXTextField *oldPswdField;
@property (nonatomic, strong) VetXTextField *pswdField;
@property (nonatomic, strong) VetXTextField *retypePswdField;

@end
