//
//  VTXViewWithDivider.m
//  VetX
//
//  Created by YulianMobile on 4/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXViewWithDivider.h"
#import "Constants.h"
#import "Masonry.h"

@interface VTXViewWithDivider ()

@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation VTXViewWithDivider

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [self addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.bottom.left.and.right.equalTo(self);
        }];
    }
    
    if (!self.leftLabel) {
        self.leftLabel = [[UILabel alloc] init];
        [self.leftLabel setFont:VETX_FONT_MEDIUM_15];
        [self.leftLabel setTextColor:MEDICAL_RECOR_COLOR];
        [self.leftLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.centerY.equalTo(self);
        }];
    }
    
    if (!self.rightLabel) {
        self.rightLabel = [[UILabel alloc] init];
        [self.rightLabel setFont:VETX_FONT_REGULAR_15];
        [self.rightLabel setTextColor:MEDICAL_PET_NAME_COLOR];
        [self.rightLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.centerY.equalTo(self);
        }];
    }
}

- (void)showDivider:(BOOL)show {
    if (show) {
        [self.divider setHidden:NO];
    } else {
        [self.divider setHidden:YES];
    }
}

- (void)setLeftLabel:(NSString *)left rightLabel:(NSString *)right {
    [self.leftLabel setText:left];
    [self.rightLabel setText:right];
    [self layoutIfNeeded];
}

@end
