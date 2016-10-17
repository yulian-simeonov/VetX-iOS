//
//  ChangePasswordView.m
//  VetX
//
//  Created by YulianMobile on 1/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ChangePasswordView.h"
#import "Constants.h"
#import "Masonry.h"

#import "RoundedBtn.h"



@interface ChangePasswordView () <UITextFieldDelegate>


@property (nonatomic, strong) RoundedBtn *saveBtn;

@end

@implementation ChangePasswordView

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
    if (!self.oldPswdField) {
        self.oldPswdField = [[VetXTextField alloc] init];
//        [self.oldPswdField addTitleLabel:@"Current Password"];
        [self.oldPswdField setPlaceholder:@"Old password"];
        [self.oldPswdField setSecureTextEntry:YES];
        [self addSubview:self.oldPswdField];
        [self.oldPswdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(30);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@40);
            make.width.equalTo(self.mas_width).offset(-40);
        }];
    }
    
    if (!self.pswdField) {
        self.pswdField = [[VetXTextField alloc] init];
//        [self.pswdField addTitleLabel:@"New Password"];
        [self.pswdField setPlaceholder:@"New password, at least 6 characters"];
        [self.pswdField setSecureTextEntry:YES];
        [self addSubview:self.pswdField];
        [self.pswdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.oldPswdField.mas_bottom).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@40);
            make.width.equalTo(self.mas_width).offset(-40);
        }];
    }
    
    if (!self.retypePswdField) {
        self.retypePswdField = [[VetXTextField alloc] init];
//        [self.retypePswdField addTitleLabel:@"Confirm Password"];
        [self.retypePswdField setPlaceholder:@"Confirm Password"];
        [self.retypePswdField setSecureTextEntry:YES];
        [self addSubview:self.retypePswdField];
        [self.retypePswdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pswdField.mas_bottom).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@40);
            make.width.equalTo(self.mas_width).offset(-40);
        }];
    }
    
    if (!self.saveBtn) {
        self.saveBtn = [[RoundedBtn alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 50)];
        [self.saveBtn setSelected:YES];
        [self.saveBtn setTitle:@"Update Password" forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.retypePswdField.mas_bottom).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@50);
            make.width.equalTo(self.mas_width).offset(-40);
        }];
    }
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.oldPswdField) {
//        self.model.oldPassword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if (textField == self.pswdField){
//        self.model.password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
//        self.model.confirmPassword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (void)dismissKeyboard {
    [self endEditing:YES];
}

- (void)saveBtnClicked {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(changePswdClicked)]) {
        [self.delegate performSelector:@selector(changePswdClicked)];
    }
}

@end
