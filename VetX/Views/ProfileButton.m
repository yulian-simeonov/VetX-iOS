//
//  ProfileButton.m
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ProfileButton.h"
#import "Constants.h"
#import "Masonry.h"

@interface ProfileButton ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ProfileButton

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
    if (!self.leftLabel) {
        self.leftLabel = [[UILabel alloc] init];
        [self.leftLabel setTextAlignment:NSTextAlignmentLeft];
        [self.leftLabel setFont:VETX_FONT_MEDIUM_15];
        [self.leftLabel setTextColor:GREY_COLOR];
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
    }
    
    if (!self.rightLabel) {
        self.rightLabel = [[UILabel alloc] init];
        [self.rightLabel setTextAlignment:NSTextAlignmentRight];
        [self.rightLabel setFont:VETX_FONT_MEDIUM_13];
        [self.rightLabel setTextColor:GREY_COLOR];
        [self addSubview:self.rightLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
    }
    
    if (!self.arrowImageView) {
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow_Thin"]];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
    }
    
    if (!self.line) {
        self.line = [[UIView alloc] init];
        [self.line setBackgroundColor:GREY_COLOR];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.and.width.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    
    if (!self.btn) {
        self.btn = [[UIButton alloc] init];
        [self.btn setBackgroundColor:[UIColor clearColor]];
        [self.btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
//    [self layoutIfNeeded];
}

- (void)setBttuonTitle:(NSString *)title {
    [self.leftLabel setText:title];
}

- (void)hideRightLabel {
    [self.rightLabel setHidden:YES];
    [self.arrowImageView setHidden:NO];
}

- (void)hideArrowImage {
    [self.arrowImageView setHidden:YES];
    [self.rightLabel setHidden:NO];
}

- (void)btnClicked {
    if ([self.delegate respondsToSelector:@selector(profileBtnClicked:)]) {
        [self.delegate performSelector:@selector(profileBtnClicked:) withObject:self];
    }
}

@end
