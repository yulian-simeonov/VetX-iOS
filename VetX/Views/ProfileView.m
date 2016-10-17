//
//  ProfileView.m
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ProfileView.h"
#import "Constants.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileView () <ProfileButtonDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *bioLabel;
@property (strong, nonatomic) UIButton *editBtn;
//@property (strong, nonatomic) UIScrollView *scrollView;
//@property (strong, nonatomic) UIView *contentView;
//@property (strong, nonatomic) ProfileButton *editProfile;
//@property (strong, nonatomic) ProfileButton *changePswd;
//@property (strong, nonatomic) ProfileButton *changeSubscription;
//@property (strong, nonatomic) ProfileButton *creditCard;
//@property (strong, nonatomic) UIButton *logout;

@end

@implementation ProfileView

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
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] init];
        [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.width.equalTo(self);
            make.height.equalTo(@130);
        }];
    }
    
    if (!self.profileImageView) {
        self.profileImageView = [[UIImageView alloc] init];
        [self.profileImageView setImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
        [self.profileImageView.layer setBorderWidth:2.0f];
        [self.profileImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.profileImageView.layer setCornerRadius:50.0f];
        [self.profileImageView setClipsToBounds:YES];
        [self.backgroundView addSubview:self.profileImageView];
        [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backgroundView);
            make.width.and.height.equalTo(@100);
            make.left.equalTo(self.mas_top).offset(25);
        }];
    }
    
    if (!self.nameLabel) {
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setTextColor:ORANGE_THEME_COLOR];
        [self.nameLabel setFont:VETX_FONT_BOLD_20];
        [self.backgroundView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.profileImageView).offset(5);
            make.left.equalTo(self.profileImageView.mas_right).offset(25);
        }];
    }
    
    if (!self.bioLabel) {
        self.bioLabel = [[UILabel alloc] init];
        [self.bioLabel setFont:VETX_FONT_REGULAR_13];
        [self.bioLabel setTextColor:FEED_CELL_TITLE_COLOR];
        [self.bioLabel setNumberOfLines:2];
        [self.backgroundView addSubview:self.bioLabel];
        [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.right.equalTo(self.backgroundView.mas_right).offset(-20);
        }];
    }
    
    if (!self.editBtn) {
        self.editBtn = [[UIButton alloc] init];
        [self.editBtn.titleLabel setFont:VETX_FONT_BOLD_13]; 
        [self.editBtn setTitle:@"Edit Profile" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateNormal];
        [self.editBtn setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [self.editBtn.layer setCornerRadius:2.0f];
        [self.editBtn addTarget:self action:@selector(profileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.profileImageView).offset(-5);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.backgroundView).offset(-40);
            make.height.equalTo(@24);
        }];
    }

    [self layoutIfNeeded];
}

- (void)bindUserData:(User *)userObj {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", userObj.firstName, userObj.lastName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:userObj.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
    [self.bioLabel setText:userObj.bio];
    [self layoutIfNeeded];
}

- (void)setProfileImage:(UIImage *)image {
    [self.profileImageView setImage:image];
}

- (void)profileBtnClicked:(ProfileButton *)sender {
//    if (sender == self.editProfile) {
        if ([self.delegate respondsToSelector:@selector(editProfileClicked)]) {
            [self.delegate performSelector:@selector(editProfileClicked)];
        }
}

- (void)logoutUser {
    if ([self.delegate respondsToSelector:@selector(logoutClicked)]) {
        [self.delegate performSelector:@selector(logoutClicked)];
    }
}
@end
