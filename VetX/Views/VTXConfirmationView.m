//
//  VTXConfirmationView.m
//  VetX
//
//  Created by YulianMobile on 4/19/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXConfirmationView.h"
#import "Masonry.h"
#import "Constants.h"

@interface VTXConfirmationView ()

@property (nonatomic, strong) UIImageView *confirmImageView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation VTXConfirmationView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setBackgroundColor:ORANGE_THEME_COLOR];
    if (!self.confirmImageView) {
        self.confirmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Confirm"]];
        [self addSubview:self.confirmImageView];
        [self.confirmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@128);
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top).offset(20);
        }];
    }
    
    if (!self.firstLabel) {
        self.firstLabel = [[UILabel alloc] init];
        [self.firstLabel setFont:VETX_FONT_BOLD_25];
        [self.firstLabel setText:@"Your question has\nbeen submitted"];
        [self.firstLabel setTextAlignment:NSTextAlignmentCenter];
        [self.firstLabel setTextColor:[UIColor whiteColor]];
        [self.firstLabel setNumberOfLines:2];
        [self addSubview:self.firstLabel];
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.confirmImageView);
            make.top.equalTo(self.confirmImageView.mas_bottom).offset(20);
        }];
    }
    
    if (!self.secondLabel) {
        self.secondLabel = [[UILabel alloc] init];
        [self.secondLabel setFont:VETX_FONT_REGULAR_15];
        [self.secondLabel setText:@"Please allow 5 - 10 minutes\nfor your question to be answered"];
        [self.secondLabel setTextAlignment:NSTextAlignmentCenter];
        [self.secondLabel setTextColor:[UIColor whiteColor]];
        [self.secondLabel setNumberOfLines:2];
        [self addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.confirmImageView);
            make.top.equalTo(self.firstLabel.mas_bottom).offset(15);
        }];
    }
    
    if (!self.okButton) {
        self.okButton = [[UIButton alloc] init];
        [self.okButton setBackgroundColor:[UIColor clearColor]];
        [self.okButton.titleLabel setFont:VETX_FONT_REGULAR_15];
        [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.okButton setTitle:@"okay" forState:UIControlStateNormal];
        [self.okButton addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okButton];
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.bottom.and.left.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:LIGHT_GREY_COLOR];
        [self addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.width.and.left.equalTo(self.okButton);
            make.bottom.equalTo(self.okButton.mas_top);
        }];
    }
}

- (void)setConfirmationType:(ConfirmationType)type {
    switch (type) {
        case General:
            [self.firstLabel setText:@"Your question has\nbeen submitted"];
            [self.secondLabel setText:@"Please allow 5 - 10 minutes\nfor your question to be answered"];
            break;
        case Chat:
            [self.firstLabel setText:@"Your chat consultation has\nbeen submitted"];
            [self.secondLabel setText:@"Please allow 3 - 5 minutes\nfor your consultation to be answered"];
            break;
        case Video:
            [self.firstLabel setText:@"Your video consultation has\nbeen submitted"];
            [self.secondLabel setText:@"Please allow 1 - 3 minutes\nfor your consultation to be answered"];
            break;
    }
}


- (void)clickOK {
    if ([self.delegate respondsToSelector:@selector(didClickOK)]) {
        [self.delegate performSelector:@selector(didClickOK)];
    }
}
@end
