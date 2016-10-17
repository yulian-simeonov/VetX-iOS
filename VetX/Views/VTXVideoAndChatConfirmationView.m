//
//  VTXVideoAndChatConfirmationView.m
//  VetX
//
//  Created by YulianMobile on 5/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXVideoAndChatConfirmationView.h"
#import "Masonry.h"
#import "Constants.h"
#import "AnimatedGIFImageSerialization.h"


@interface VTXVideoAndChatConfirmationView ()

@property (nonatomic, strong) UIImageView *confirmImageView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation VTXVideoAndChatConfirmationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setBackgroundColor:[UIColor whiteColor]];
    if (!self.confirmImageView) {
        self.confirmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-large.gif"]];
        [self addSubview:self.confirmImageView];
        [self.confirmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@150);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY);
        }];
    }
    
    if (!self.firstLabel) {
        self.firstLabel = [[UILabel alloc] init];
        [self.firstLabel setFont:VETX_FONT_BOLD_20];
        [self.firstLabel setText:@"Connecting With A Vet"];
        [self.firstLabel setTextAlignment:NSTextAlignmentCenter];
        [self.firstLabel setTextColor:ORANGE_THEME_COLOR];
        [self.firstLabel setNumberOfLines:1];
        [self addSubview:self.firstLabel];
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.confirmImageView);
            make.top.equalTo(self.confirmImageView.mas_bottom).offset(20);
        }];
    }
    
    if (!self.secondLabel) {
        self.secondLabel = [[UILabel alloc] init];
        [self.secondLabel setFont:VETX_FONT_REGULAR_15];
        [self.secondLabel setText:@"your payment has been processed\nWe will notify you when our Vet is ready\nwait time: ~2 minutes"];
        [self.secondLabel setTextAlignment:NSTextAlignmentCenter];
        [self.secondLabel setTextColor:ORANGE_THEME_COLOR];
        [self.secondLabel setNumberOfLines:3];
        [self addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.confirmImageView);
            make.top.equalTo(self.firstLabel.mas_bottom).offset(15);
        }];
    }
    
    if (!self.okButton) {
        self.okButton = [[UIButton alloc] init];
        [self.okButton setBackgroundColor:ORANGE_THEME_COLOR];
        [self.okButton.titleLabel setFont:VETX_FONT_REGULAR_15];
        [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.okButton setTitle:@"okay" forState:UIControlStateNormal];
        [self.okButton addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okButton];
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.height.equalTo(@50);
            make.width.equalTo(@240);
        }];
    }
}

- (void)setOneOnOneConfirmationType:(OneOnOneType)type {
    switch (type) {
        case ConsultationChat:
            [self.secondLabel setText:@"your payment has been processed\nWe will notify you when our Vet is ready\nwait time: ~3 minutes"];
            break;
        case ConsultationVideo:
            [self.secondLabel setText:@"your payment has been processed\nWe will notify you when our Vet is ready\nwait time: ~2 minutes"];
            break;
    }
}

- (void)clickOK {
    if ([self.delegate respondsToSelector:@selector(didClickConfirm)]) {
        [self.delegate performSelector:@selector(didClickConfirm)];
    }
}

@end
