//
//  LoginView.m
//  VetX
//
//  Created by YulianMobile on 12/17/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "LoginView.h"
#import "Masonry.h"
#import "Constants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "VTXDividerLabel.h"
#import "TTTAttributedLabel.h"

@interface LoginView () <UITextFieldDelegate, TTTAttributedLabelDelegate, FBSDKLoginButtonDelegate>

@property (nonatomic, strong) UIImageView *vetLogoView;
@property (nonatomic, strong) UILabel *orLabel;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) VTXDividerLabel *orLabel1;
@property (nonatomic, strong) FBSDKLoginButton *fbBtn;
@property (nonatomic, strong) UIButton *gotoSignup;
@property (nonatomic, strong) UIButton *continueAsGuest;
@property (nonatomic, strong) UIButton *forgotPassword;
@property (nonatomic, strong) TTTAttributedLabel *termsAndConditionLabel;

@end

@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    
    if (!self.vetLogoView) {
        self.vetLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VetX_Logo_White"]];
        [self.vetLogoView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.vetLogoView];
        [self.vetLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            if (SCREEN_HEIGHT < 600) {
                make.top.equalTo(self.mas_top);
                make.width.equalTo(@180);
                make.height.equalTo(self.vetLogoView.mas_width).multipliedBy(192.0/205.0f);
            } else {
                make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.04);
                make.width.equalTo(@205);
                make.height.equalTo(self.vetLogoView.mas_width).multipliedBy(192.0/205.0f);
            }
        }];
    }
    
    if (!self.emailField) {
        self.emailField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.emailField setPlaceholder:@"Email Address"];
        [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [self.emailField setTextFieldIcon:[UIImage imageNamed:@"email"]];
        self.emailField.delegate = self;
        [self addSubview:self.emailField];
        [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
            if (SCREEN_HEIGHT < 500) {
                make.top.equalTo(self.vetLogoView.mas_bottom).offset(-10);
                make.width.equalTo(self).offset(-60);
                make.height.equalTo(@30);
            } else if (SCREEN_HEIGHT < 600) {
                make.top.equalTo(self.vetLogoView.mas_bottom).offset(-10);
                make.width.equalTo(self).offset(-60);
                make.height.equalTo(@47);
            } else {
                make.top.equalTo(self.vetLogoView.mas_bottom).offset(SCREEN_HEIGHT*0.04);
                make.width.equalTo(self).offset(-116);
                make.height.equalTo(@47);
            }
            make.centerX.equalTo(self);
        }];
    }
    
    if (!self.passwordField) {
        self.passwordField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.passwordField setPlaceholder:@"Password, at least 6 digits"];
        [self.passwordField setTextFieldIcon:[UIImage imageNamed:@"lock"]];
        [self.passwordField setSecureTextEntry:YES];
        self.passwordField.delegate = self;
        [self addSubview:self.passwordField];
        [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emailField.mas_bottom).offset(13);
            make.centerX.height.and.width.equalTo(self.emailField);
        }];
    }
    
    if (!self.loginBtn) {
        self.loginBtn = [[UIButton alloc] init];
        [self.loginBtn setBackgroundColor:ORANGE_THEME_COLOR];
        [self.loginBtn.layer setCornerRadius:2.0f];
        [self.loginBtn.titleLabel setFont:VETX_FONT_MEDIUM_14];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"Sign In" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(didLoginUser) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.height.and.width.equalTo(self.emailField);
            make.top.equalTo(self.passwordField.mas_bottom).offset(13);
        }];
    }
    
    if (!self.fbBtn) {
        self.fbBtn = [[FBSDKLoginButton alloc] init];
        self.fbBtn.delegate = self;
        [self.fbBtn setReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
        [self addSubview:self.fbBtn];
        [self.fbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.height.and.width.equalTo(self.emailField);
            make.top.equalTo(self.loginBtn.mas_bottom).offset(13);
        }];
    }
    
    if (!self.orLabel1) {
        self.orLabel1 = [[VTXDividerLabel alloc] initWithLabel:@"don't have an account?"];
        [self addSubview:self.orLabel1];
        [self.orLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fbBtn.mas_bottom).offset(20);
            make.width.equalTo(self.loginBtn);
            make.left.equalTo(self.passwordField);
        }];
    }
    
    if (!self.gotoSignup) {
        self.gotoSignup = [[UIButton alloc] init];
        [self.gotoSignup setBackgroundColor:[UIColor whiteColor]];
        [self.gotoSignup.layer setCornerRadius:2.0];
        [self.gotoSignup.titleLabel setFont:VETX_FONT_MEDIUM_14];
        [self.gotoSignup setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.gotoSignup setTitleColor:ORANGE_THEME_COLOR forState:UIControlStateNormal];
        [self.gotoSignup addTarget:self action:@selector(signupBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.gotoSignup];
        [self.gotoSignup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.height.and.width.equalTo(self.emailField);
            make.top.equalTo(self.orLabel1.mas_bottom).offset(20);
        }];
    }
    
    if (!self.continueAsGuest) {
        self.continueAsGuest = [[UIButton alloc] init];
        [self.continueAsGuest.layer setCornerRadius:2.0];
        [self.continueAsGuest.layer setBorderWidth:1.0];
        [self.continueAsGuest.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.continueAsGuest setBackgroundColor:[UIColor clearColor]];
        [self.continueAsGuest setTitle:@"or continue as a guest" forState:UIControlStateNormal];
        [self.continueAsGuest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.continueAsGuest.titleLabel setFont:VETX_FONT_REGULAR_12];
        [self.continueAsGuest addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.continueAsGuest];
        [self.continueAsGuest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.centerX.equalTo(self.gotoSignup);
            make.height.equalTo(@35);
            make.top.equalTo(self.gotoSignup.mas_bottom).offset(13);
        }];
    }
    
    if (!self.forgotPassword) {
        self.forgotPassword = [[UIButton alloc] init];
        NSString *str = @"forgot password?";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:VETX_FONT_REGULAR_13}];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
        [self.forgotPassword setAttributedTitle:attrStr forState:UIControlStateNormal];
        [self.forgotPassword addTarget:self action:@selector(clickForgotPassword) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.forgotPassword];
        [self.forgotPassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.gotoSignup);
            make.height.equalTo(@25);
            make.width.equalTo(@150);
            make.top.equalTo(self.continueAsGuest.mas_bottom).offset(10);
        }];
    }
    
    if (!self.termsAndConditionLabel) {
        self.termsAndConditionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.termsAndConditionLabel setTextColor:[UIColor whiteColor]];
        NSString *str = @"by signing up you are agreeing to our terms & conditions";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:VETX_FONT_LIGHT_8}];
        NSRange range = [str rangeOfString:@"terms & conditions"];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [self.termsAndConditionLabel addLinkToURL:[NSURL URLWithString:@"http://vet.vetxapp.com/ToS.pdf"] withRange:range];
        self.termsAndConditionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        [self.termsAndConditionLabel setAttributedText:attrStr];
        self.termsAndConditionLabel.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
        [self addSubview:self.termsAndConditionLabel];
        [self.termsAndConditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.centerX.equalTo(self);
        }];
    }
    
}

- (void)dismissKeyboard {
    [self endEditing:YES];
}

#pragma mark - Button Selector Functions
- (void)backBtnClicked {
    if ([self.delegate respondsToSelector:@selector(didGoBack)]) {
        [self.delegate performSelector:@selector(didGoBack)];
    }
}

- (void)didLoginUser {
    if ([self.delegate respondsToSelector:@selector(didLogin)]) {
        [self.delegate performSelector:@selector(didLogin)];
    }
}

- (void)signupBtnClicked {
    if ([self.delegate respondsToSelector:@selector(signupUser)]) {
        [self.delegate performSelector:@selector(signupUser)];
    }
}

- (void)clickForgotPassword {
    if ([self.delegate respondsToSelector:@selector(didClickForgotPassword)]) {
        [self.delegate performSelector:@selector(didClickForgotPassword)];
    }
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.emailField) {
//        self.loginUser.email = textField.text;
    } else {
//        self.loginUser.password = textField.text;
    }
}

#pragma mark - TTTAttributedLabel Delegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if ([self.delegate respondsToSelector:@selector(openTerms:)]) {
        [self.delegate performSelector:@selector(openTerms:) withObject:url];
    }
}


#pragma mark - FB Auth Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(signupWithFB:)]) {
        [self.delegate performSelector:@selector(signupWithFB:) withObject:result.token.tokenString];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

@end
