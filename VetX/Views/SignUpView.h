//
//  SignUpView.h
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTXLeftIconTextField.h"

@protocol SingupViewDelegate <NSObject>

- (void)backToLogin;
- (void)createUser:(NSNumber *)isVet;
- (void)loginUser;
- (void)addProfileImage;

@end

@interface SignUpView : UIView

@property (nonatomic, assign) id<SingupViewDelegate> delegate;

@property (nonatomic, strong) UIButton *profileImage;
@property (nonatomic, strong) VTXLeftIconTextField *firstNameField;
@property (nonatomic, strong) VTXLeftIconTextField *lastNameField;
@property (nonatomic, strong) VTXLeftIconTextField *emailField;
@property (nonatomic, strong) VTXLeftIconTextField *passwordField;
@property (nonatomic, strong) VTXLeftIconTextField *confirmField;
@property (nonatomic, strong) VTXLeftIconTextField *vetLicense;

- (instancetype) init;

@end
