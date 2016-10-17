//
//  StartView.m
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "StartView.h"
#import "Masonry.h"
#import "Constants.h"

@interface StartView ()

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIButton *signupBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *vetLoginBtn;

@end

@implementation StartView

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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if (!self.backgroundImage) {
        self.backgroundImage = [[UIImageView alloc] init];
        [self.backgroundImage setImage:[UIImage imageNamed:@"Login"]];
        [self addSubview:self.backgroundImage];
        [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    if (!self.signupBtn) {
        self.signupBtn = [[UIButton alloc] init];
        [self.signupBtn.layer setCornerRadius:20.0f];
        [self.signupBtn setClipsToBounds:YES];
        [self.signupBtn setBackgroundColor:ORANGE_THEME_COLOR];
        [self.signupBtn.titleLabel setFont:VETX_FONT_BOLD_15];
        [self.signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.signupBtn setTitle:@"GET STARTED" forState:UIControlStateNormal];
        [self.signupBtn addTarget:self action:@selector(startSignup) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.signupBtn];
        [self.signupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-25);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@40);
        }];
    }
    
    if (!self.loginBtn) {
        self.loginBtn = [[UIButton alloc] init];
        [self.loginBtn.layer setCornerRadius:20.0f];
        [self.loginBtn setClipsToBounds:YES];
        [self.loginBtn setBackgroundColor:GREY_COLOR];
        [self.loginBtn.titleLabel setFont:VETX_FONT_BOLD_15];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"USER LOGIN" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(startUserLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.height.equalTo(self.signupBtn);
            make.bottom.equalTo(self.signupBtn.mas_top).offset(-12);
            make.width.equalTo(self.signupBtn).multipliedBy(0.5).offset(-2);
        }];
    }
    
    if (!self.vetLoginBtn) {
        self.vetLoginBtn = [[UIButton alloc] init];
        [self.vetLoginBtn.layer setCornerRadius:20.0f];
        [self.vetLoginBtn setClipsToBounds:YES];
        [self.vetLoginBtn setBackgroundColor:GREY_COLOR];
        [self.vetLoginBtn.titleLabel setFont:VETX_FONT_BOLD_15];
        [self.vetLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.vetLoginBtn setTitle:@"VET LOGIN" forState:UIControlStateNormal];
        [self.vetLoginBtn addTarget:self action:@selector(startVetLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.vetLoginBtn];
        [self.vetLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.height.equalTo(self.signupBtn);
            make.bottom.equalTo(self.signupBtn.mas_top).offset(-12);
            make.width.equalTo(self.signupBtn).multipliedBy(0.5).offset(-2);
        }];
    }
}

#pragma mark - Button actions 
- (void)startSignup {
    if ([self.delegate respondsToSelector:@selector(didClickSignupBtn)]) {
        [self.delegate performSelector:@selector(didClickSignupBtn)];
    }
}

- (void)startUserLogin {
    if ([self.delegate respondsToSelector:@selector(didClickLoginBtn)]) {
        [self.delegate performSelector:@selector(didClickLoginBtn)];
    }
}

- (void)startVetLogin {
    if ([self.delegate respondsToSelector:@selector(didClickVetLoginBtn)]) {
        [self.delegate performSelector:@selector(didClickVetLoginBtn)];
    }
}

@end
