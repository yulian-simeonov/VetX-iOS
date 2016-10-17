//
//  SignUpView.m
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "SignUpView.h"
#import "Masonry.h"
#import "Constants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "M13Checkbox.h"
#import "VTXDividerLabel.h"
#import "TTTAttributedLabel.h"

@interface SignUpView () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIView *signupFirstView;
@property (nonatomic, strong) UIView *fbView;
@property (nonatomic, strong) FBSDKLoginButton *fbBtn;
@property (nonatomic, strong) VTXDividerLabel *orLabel1;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIImageView *emailIcon;
@property (nonatomic, strong) UIButton *signupEmailBtn;
@property (nonatomic, strong) UILabel *bottomDivider;
@property (nonatomic, strong) UIView *hasAccountView;
@property (nonatomic, strong) UILabel *hasAccountLabel;
@property (nonatomic, strong) UIButton *gotoLoginBtn;

@property (nonatomic, strong) UIView *signupBackgroundView;
@property (nonatomic, strong) UILabel *typeToAddImageLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *signupLabel;
@property (nonatomic, strong) M13Checkbox *isVetCheckbox;
@property (nonatomic, strong) TTTAttributedLabel *privacyLabel;
@property (nonatomic, strong) UILabel *hasAccountLabel2;
@property (nonatomic, strong) UIButton *gotoLoginBtn2;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic, strong) NSNumber *isVet;

@end

@implementation SignUpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init {
    self = [super init];
    if (self) {
        self.allowEdit = NO;
        [self setupView];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.allowEdit = NO;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    if (!self.signupBackgroundView) {
        self.signupBackgroundView = [[UIView alloc] init];
        [self.signupBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self.signupBackgroundView setHidden:NO];
        [self addSubview:self.signupBackgroundView];
        [self.signupBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    if (!self.closeBtn) {
        self.closeBtn = [[UIButton alloc] init];
        [self.closeBtn setTintColor:[UIColor whiteColor]];
        [self.closeBtn setImage:[[UIImage imageNamed:@"BackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.signupBackgroundView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.equalTo(self.signupBackgroundView).offset(20);
            make.height.and.width.equalTo(@30);
        }];
    }
    
    
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
        [self.tap setCancelsTouchesInView:NO];
        self.tap.delegate = self;
        [self.signupBackgroundView addGestureRecognizer:self.tap];
    }
    
    if (!self.profileImage) {
        self.profileImage  = [[UIButton alloc] init];
        [self.profileImage.layer setCornerRadius:50.0f];
        [self.profileImage setClipsToBounds:YES];
        [self.profileImage setImage:[UIImage imageNamed:@"Profile_Placeholder-1"] forState:UIControlStateNormal];
        [self.profileImage addTarget:self action:@selector(addProfileImageClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.signupBackgroundView addSubview:self.profileImage];
        [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signupBackgroundView).offset(40);
            make.height.and.width.equalTo(@100);
            make.centerX.equalTo(self.signupBackgroundView);
        }];
    }
    
    if (!self.typeToAddImageLabel) {
        self.typeToAddImageLabel = [[UILabel alloc] init];
        [self.typeToAddImageLabel setFont:VETX_FONT_MEDIUM_12];
        [self.typeToAddImageLabel setText:@"tap to choose profile picture"];
        [self.typeToAddImageLabel setTextColor:[UIColor whiteColor]];
        [self.signupBackgroundView addSubview:self.typeToAddImageLabel];
        [self.typeToAddImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.profileImage);
            make.top.equalTo(self.profileImage.mas_bottom);
        }];
        
    }
    
    if (!self.firstNameField) {
        self.firstNameField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.firstNameField setPlaceholder:@"First Name"];
        [self.firstNameField setTextFieldIcon:[UIImage imageNamed:@"user_profile"]];
        self.firstNameField.delegate = self;
        [self.signupBackgroundView addSubview:self.firstNameField];
        [self.firstNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeToAddImageLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.signupBackgroundView);
            make.height.equalTo(@47);
            make.width.equalTo(self.signupBackgroundView).offset(-116);
        }];
    }
    
    if (!self.lastNameField) {
        self.lastNameField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.lastNameField setPlaceholder:@"Last Name"];
        [self.lastNameField setTextFieldIcon:[UIImage imageNamed:@"user_profile"]];
        self.lastNameField.delegate = self;
        [self.signupBackgroundView addSubview:self.lastNameField];
        [self.lastNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstNameField.mas_bottom).offset(13);
            make.centerX.height.and.width.equalTo(self.firstNameField);
        }];
    }
    
    if (!self.emailField) {
        self.emailField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.emailField setPlaceholder:@"Email Address"];
        [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [self.emailField setTextFieldIcon:[UIImage imageNamed:@"email"]];
        self.emailField.delegate = self;
        [self.signupBackgroundView addSubview:self.emailField];
        [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastNameField.mas_bottom).offset(13);
            make.centerX.height.and.width.equalTo(self.firstNameField);
        }];
    }
    
    if (!self.passwordField) {
        self.passwordField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.passwordField setPlaceholder:@"Password, at least 6 digits"];
        [self.passwordField setTextFieldIcon:[UIImage imageNamed:@"lock"]];
        [self.passwordField setSecureTextEntry:YES];
        self.passwordField.delegate = self;
        [self.signupBackgroundView addSubview:self.passwordField];
        [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emailField.mas_bottom).offset(13);
            make.centerX.height.and.width.equalTo(self.firstNameField);
        }];
    }
    
    if (!self.confirmField) {
        self.confirmField = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.confirmField setPlaceholder:@"Confirm password"];
        [self.confirmField setTextFieldIcon:[UIImage imageNamed:@"lock"]];
        [self.confirmField setSecureTextEntry:YES];
        self.confirmField.delegate = self;
        [self.signupBackgroundView addSubview:self.confirmField];
        [self.confirmField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordField.mas_bottom).offset(13);
            make.centerX.height.and.width.equalTo(self.firstNameField);
        }];
    }
    
    if (!self.isVetCheckbox) {
        self.isVetCheckbox = [[M13Checkbox alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) title:@"Are you a Vet?"];
        [self.isVetCheckbox.titleLabel setFont:VETX_FONT_MEDIUM_15];
        [self.isVetCheckbox.titleLabel setTextColor:DARK_GREY_COLOR];
        [self.isVetCheckbox setCheckColor:ORANGE_THEME_COLOR];
        [self.isVetCheckbox setStrokeColor:ORANGE_THEME_COLOR];
        [self.isVetCheckbox addTarget:self action:@selector(checkChangeState:) forControlEvents:UIControlEventTouchUpInside];
        [self.signupBackgroundView addSubview:self.isVetCheckbox];
        [self.isVetCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.confirmField);
            make.height.equalTo(@30);
            make.top.equalTo(self.confirmField.mas_bottom).offset(13);
        }];
    }
    
    if (!self.vetLicense) {
        self.vetLicense = [[VTXLeftIconTextField alloc] initWithBorder:YES];
        [self.vetLicense setPlaceholder:@"Veterinary License"];
        [self.vetLicense setTextFieldIcon:[UIImage imageNamed:@"IdentityCard"]];
        [self.vetLicense setSecureTextEntry:YES];
        self.vetLicense.delegate = self;
        self.vetLicense.alpha = 0.0;
        [self.signupBackgroundView addSubview:self.vetLicense];
        [self.vetLicense mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.isVetCheckbox.mas_bottom).offset(13);
            make.centerX.height.and.width.equalTo(self.firstNameField);
        }];
    }
    
    [self addSaveBtn];
}

- (void)addSaveBtn {
    if (!self.saveBtn) {
        self.saveBtn = [[UIButton alloc] init];
        [self.saveBtn setBackgroundColor:[UIColor whiteColor]];
        [self.saveBtn.layer setCornerRadius:2.0];
        [self.saveBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:ORANGE_THEME_COLOR forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(createAccountClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.signupBackgroundView addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.signupBackgroundView.mas_bottom).offset(-20);
            make.centerX.equalTo(self.signupBackgroundView);
            make.width.equalTo(self).offset(-116);
            make.height.equalTo(@47);
        }];
    }
    
}

- (void)addProfileImageClicked {
    if ([self.delegate respondsToSelector:@selector(addProfileImage)]) {
        [self.delegate performSelector:@selector(addProfileImage)];
    }
}

- (void)clickSignupEmail {
    [UIView animateWithDuration:0.3 animations:^{
        [self.signupFirstView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.signupFirstView removeFromSuperview];
        [self.signupBackgroundView setHidden:NO];
    }];
}

- (void)checkChangeState:(id)sender {
    NSLog(@"Change state");
    CGFloat changeAlpha = 0.0;
    if (self.isVetCheckbox.checkState == M13CheckboxStateChecked) {
        changeAlpha = 1.0;
        self.isVet = @1;
        [self.privacyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vetLicense.mas_bottom).offset(5);
            make.centerX.equalTo(self.signupBackgroundView);
            make.width.equalTo(@260);
        }];
    } else {
        self.isVet = @2;
        [self.privacyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.isVetCheckbox.mas_bottom).offset(5);
            make.centerX.equalTo(self.signupBackgroundView);
            make.width.equalTo(@260);
        }];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.signupBackgroundView layoutIfNeeded];
        self.vetLicense.alpha = changeAlpha;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapBackground {
    [self endEditing:YES];
}


- (void)closeBtnClicked {
    if ([self.delegate respondsToSelector:@selector(backToLogin)]) {
        [self.delegate performSelector:@selector(backToLogin)];
    }
}

- (void)createAccountClicked {
    if ([self.delegate respondsToSelector:@selector(createUser:)]) {
        [self.delegate performSelector:@selector(createUser:) withObject:self.isVet];
    }
}

- (void)loginBtnClicked {
    if ([self.delegate respondsToSelector:@selector(loginUser)]) {
        [self.delegate performSelector:@selector(loginUser)];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (([touch.view isKindOfClass:[UIButton class]])) {
        return NO;
    }
    return YES;
}
//
//#pragma mark - FB Auth Delegate
//- (void)loginButton:(FBSDKLoginButton *)loginButton
//didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
//              error:(NSError *)error {
//    if ([self.delegate respondsToSelector:@selector(signupWithFB:)]) {
//        [self.delegate performSelector:@selector(signupWithFB:) withObject:result.token.tokenString];
//    }
//}
//
//- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
//    
//}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}
@end
