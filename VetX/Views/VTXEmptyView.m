//
//  VTXEmptyView.m
//  VetX
//
//  Created by YulianMobile on 4/24/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXEmptyView.h"
#import "Masonry.h"
#import "Constants.h"

@interface VTXEmptyView ()

@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UIButton *bottomBtn;

@end


@implementation VTXEmptyView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setBackgroundColor:FEED_BACKGROUND_COLOR];
    if (!self.emptyImageView) {
        self.emptyImageView = [[UIImageView alloc] init];
        [self.emptyImageView setTintColor:EMPTY_VIEW_TEXT_COLOR];
        [self.emptyImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.emptyImageView];
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-35);
            
        }];
    }
    
    if (!self.bottomBtn) {
        self.bottomBtn = [[UIButton alloc] init];
        [self.bottomBtn.layer setCornerRadius:2.0f];
        [self.bottomBtn setClipsToBounds:YES];
        [self.bottomBtn setBackgroundColor:ORANGE_THEME_COLOR];
        [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottomBtn.titleLabel setFont:VETX_FONT_REGULAR_15];
        [self.bottomBtn addTarget:self action:@selector(clickBottomBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bottomBtn];
        [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.emptyImageView.mas_bottom).offset(15);
            make.width.equalTo(@135);
            make.height.equalTo(@35);
        }];
    }
}

- (void)clickBottomBtn {
    if ([self.delegate respondsToSelector:@selector(didClickBtn)]) {
        [self.delegate performSelector:@selector(didClickBtn)];
    }
}

- (void)setEmptyScreenType:(EmptyType)type {
    switch (type) {
        case EmptyQuestion:
            [self setQuestion];
            break;
        case EmptyRecord:
            [self setRecords];
            break;
        case EmptyProfile:
            [self setProfile];
            break;
        case EmptyAnswers:
            [self setAnswer];
            break;
        default:
            break;
    }
}

- (void)setQuestion {
//    [self.emptyImageView setTintColor:EMPTY_VIEW_TEXT_COLOR];
    [self.emptyImageView setImage:[UIImage imageNamed:@"Empty_Question"]];
//    [self.emptyImageView setImage:[[UIImage imageNamed:@"Empty_Question"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.bottomBtn setTitle:@"Ask A Question" forState:UIControlStateNormal];
    [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@140);
    }];
    [self layoutIfNeeded];
}

- (void)setAnswer {
    [self.emptyImageView setTintColor:EMPTY_VIEW_TEXT_COLOR];
    [self.emptyImageView setImage:[[UIImage imageNamed:@"Empty_Question"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.bottomBtn setTitle:@"Answer A Question" forState:UIControlStateNormal];
    [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@170);
    }];
    [self layoutIfNeeded];
}

- (void)setRecords {
    [self.emptyImageView setImage:[UIImage imageNamed:@"Empty_Record"]];
    [self.bottomBtn setTitle:@"Add A Pet" forState:UIControlStateNormal];
}

- (void)setProfile {
    [self.emptyImageView setImage:[UIImage imageNamed:@"Profile_Empty"]];
    [self.bottomBtn setTitle:@"Add A Pet" forState:UIControlStateNormal];
    if (SCREEN_HEIGHT < 600) {
        [self.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@260);
            make.width.equalTo(self.emptyImageView).multipliedBy(290.0/325);
        }];
    }
    [self layoutIfNeeded];
}

@end
