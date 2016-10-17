//
//  EditProfileView.m
//  VetX
//
//  Created by YulianMobile on 1/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "EditProfileView.h"
#import "Constants.h"
#import "Masonry.h"

static NSString *placeholder = @"Tell us something about yourself...";

@interface EditProfileView () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILabel *divider;

@end

@implementation EditProfileView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (!self.profileImage) {
        self.profileImage = [[UIButton alloc] init];
        [self.profileImage setImage:[UIImage imageNamed:@"Profile_Placeholder"] forState:UIControlStateNormal];
        [self.profileImage setClipsToBounds:YES];
        [self.profileImage.layer setCornerRadius:65.0f];
        [self.profileImage addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.profileImage];
        [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@130);
            make.top.equalTo(self).offset(20);
            make.centerX.equalTo(self);
        }];
    }
    
    if (!self.editProfileLabel) {
        self.editProfileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        [self.editProfileLabel setText:@"tap to change profile picture"];
        [self.editProfileLabel setFont:VETX_FONT_MEDIUM_15];
        [self.editProfileLabel setTextColor:DARK_GREY_COLOR];
        [self addSubview:self.editProfileLabel];
        [self.editProfileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.profileImage.mas_bottom).offset(10);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:GREY_COLOR];
        [self addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.centerX.and.width.equalTo(self);
            make.top.equalTo(self.editProfileLabel.mas_bottom).offset(15);
        }];
    }
    
    if (!self.firstNameField) {
        self.firstNameField = [[VTXRightIconTextField alloc] initWithBorder:NO];
        [self.firstNameField setPlaceholder:@"First Name"];
        [self.firstNameField setTextFieldIcon:[UIImage imageNamed:@"user_profile"]];
        [self addSubview:self.firstNameField];
        [self.firstNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.centerX.and.width.equalTo(self);
            make.top.equalTo(self.divider.mas_bottom);
        }];
    }
    
    if (!self.lastNameField) {
        self.lastNameField = [[VTXRightIconTextField alloc] initWithBorder:NO];
        [self.lastNameField setPlaceholder:@"Last Name"];
        [self.lastNameField setTextFieldIcon:[UIImage imageNamed:@"user_profile"]];
        [self addSubview:self.lastNameField];
        [self.lastNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.and.centerX.equalTo(self.firstNameField);
            make.top.equalTo(self.firstNameField.mas_bottom);
        }];
    }
    
    if (!self.emailField) {
        self.emailField = [[VTXRightIconTextField alloc] initWithBorder:NO];
        [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [self.emailField setPlaceholder:@"Email Address"];
        [self.emailField setTextFieldIcon:[UIImage imageNamed:@"email"]];
        [self addSubview:self.emailField];
        [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.and.centerX.equalTo(self.firstNameField);
            make.top.equalTo(self.lastNameField.mas_bottom);
        }];
    }
    
    if (!self.userBio) {
        self.userBio = [[UITextView alloc] init];
        [self.userBio setKeyboardType:UIKeyboardTypeDefault];
        [self.userBio setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [self.userBio setFont:VETX_FONT_REGULAR_14];
        [self.userBio setTextColor:FEED_CELL_TITLE_COLOR];
        self.userBio.delegate = self;
        [self.userBio setText:placeholder];
        self.userBio.textContainerInset = UIEdgeInsetsMake(5, 10, 0, 0);
        [self addSubview:self.userBio];
        [self.userBio mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emailField.mas_bottom);
            make.width.and.left.equalTo(self.emailField);
            make.height.equalTo(@75);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)clickBtn {
    if ([self.delegate respondsToSelector:@selector(didClickAddProfileBtn)]) {
        [self.delegate performSelector:@selector(didClickAddProfileBtn)];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeholder]) {
        textView.text = @"";
        textView.textColor = FEED_CELL_TITLE_COLOR; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeholder;
        textView.textColor = DARK_GREY_COLOR; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - Text field

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
