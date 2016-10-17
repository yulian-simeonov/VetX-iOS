//
//  InviteView.m
//  VetX
//
//  Created by YulianMobile on 1/4/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "InviteView.h"
#import "Constants.h"
#import "Masonry.h"
#import "ReferralCollectionViewCell.h"

@interface InviteView () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *inviteDesc;
@property (nonatomic, strong) UIImageView *inviteIcon;
@property (nonatomic, strong) UILabel *yourCodeLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *referralLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation InviteView

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
    [self setBackgroundColor:[UIColor whiteColor]];
    if (!self.inviteDesc) {
        self.inviteDesc = [[UILabel alloc] init];
        [self.inviteDesc setFont:VETX_FONT_BOLD_15];
        [self.inviteDesc setTextColor:GREY_COLOR];
        [self.inviteDesc setNumberOfLines:3];
        [self.inviteDesc setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.inviteDesc];
        [self.inviteDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(self).offset(-50);
            make.top.equalTo(self).offset(25);
        }];
    }
    
    if (!self.inviteIcon) {
        self.inviteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InviteOrangeIcon"]];
        [self addSubview:self.inviteIcon];
        [self.inviteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.inviteDesc.mas_bottom).offset(5);
        }];
    }
    
    if (!self.yourCodeLabel) {
        self.yourCodeLabel = [[UILabel alloc] init];
        [self.yourCodeLabel setTextColor:LIGHT_GREY_COLOR];
        [self.yourCodeLabel setFont:VETX_FONT_MEDIUM_12];
        [self.yourCodeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.yourCodeLabel setText:@"Your code:"];
        [self addSubview:self.yourCodeLabel];
        [self.yourCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.inviteIcon.mas_bottom).offset(5);
        }];
    }
    
    if (!self.codeLabel) {
        self.codeLabel = [[UILabel alloc] init];
        [self.codeLabel setTextColor:REGERRAL_CODE_COLOR];
        [self.codeLabel setFont:VETX_FONT_BOLD_30];
        [self.codeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.codeLabel];
        [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.yourCodeLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.referralLabel) {
        self.referralLabel = [[UILabel alloc] init];
        [self.referralLabel setTextColor:LIGHT_GREY_COLOR];
        [self.referralLabel setFont:VETX_FONT_MEDIUM_12];
        [self.referralLabel setTextAlignment:NSTextAlignmentCenter];
        [self.referralLabel setText:@"Your referrals:"];
        [self addSubview:self.referralLabel];
        [self.referralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.codeLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.shareBtn) {
        self.shareBtn = [[UIButton alloc] init];
        [self.shareBtn setBackgroundColor:ORANGE_THEME_COLOR];
        [self.shareBtn setTitle:@"Share" forState:UIControlStateNormal];
        [self.shareBtn.titleLabel setFont:VETX_FONT_BOLD_15];
        [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shareBtn.layer setCornerRadius:25.0f];
        [self.shareBtn setClipsToBounds:YES];
        [self addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.height.equalTo(@50);
            make.width.equalTo(self).offset(-40);
            make.centerX.equalTo(self);
        }];
    }
    
    if (!self.noteLabel) {
        self.noteLabel = [[UILabel alloc] init];
        [self.noteLabel setFont:VETX_FONT_ITALIC_11];
        [self.noteLabel setText:@"Please note that your subscription is month to month and can be canceled at any time"];
        [self.noteLabel setTextColor:LIGHT_GREY_COLOR];
        [self.noteLabel setNumberOfLines:2];
        [self.noteLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.noteLabel];
        [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-5);
            make.width.equalTo(self).offset(-40);
            make.centerX.equalTo(self);
        }];
    }
    
    
    if (!self.collectionView) {
        //!!!: Layout is not right.s
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.collectionView registerClass:[ReferralCollectionViewCell class] forCellWithReuseIdentifier:@"ReferralCell"];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.referralLabel.mas_bottom);
            make.left.and.width.equalTo(self);
            make.bottom.equalTo(self.noteLabel.mas_top).offset(-5);
        }];
    }
}

- (void)setReferralCode:(NSString *)code {
    [self.codeLabel setText:code];
}

@end
