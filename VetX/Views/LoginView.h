//
//  LoginView.h
//  VetX
//
//  Created by YulianMobile on 12/17/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTXLeftIconTextField.h"

@protocol LoginViewDelegate <NSObject>

- (void)didGoBack;
- (void)didLogin;
- (void)signupUser;
- (void)signupWithFB:(NSString *)fbToken;
- (void)openTerms:(NSURL *)url;
- (void)didClickForgotPassword;

@end

@interface LoginView : UIView

@property (nonatomic, assign) id<LoginViewDelegate> delegate;

@property (nonatomic, strong) VTXLeftIconTextField *emailField;
@property (nonatomic, strong) VTXLeftIconTextField *passwordField;


@end
