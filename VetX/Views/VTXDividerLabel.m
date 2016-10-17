//
//  VTXDividerLabel.m
//  VetX
//
//  Created by YulianMobile on 4/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXDividerLabel.h"
#import "Constants.h"
#import "Masonry.h"

@interface VTXDividerLabel ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation VTXDividerLabel

- (instancetype)initWithLabel:(NSString *)label {
    self = [super init];
    if (self) {
        [self setupView:label];
    }
    return self;
}

- (void)setupView:(NSString *)label {
    
    if (!self.centerLabel) {
        self.centerLabel = [[UILabel alloc] init];
        [self.centerLabel setFont:VETX_FONT_LIGHT_13];
        [self.centerLabel setTextColor:[UIColor whiteColor]];
        [self.centerLabel setText:label];
        [self.centerLabel sizeToFit];
        [self addSubview:self.centerLabel];
        CGFloat width = CGRectGetWidth(self.centerLabel.frame);
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo([NSNumber numberWithDouble:width]);
            make.center.equalTo(self);
        }];
    }
    
    if (!self.leftLabel) {
        self.leftLabel = [[UILabel alloc] init];
        [self.leftLabel setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.and.centerY.equalTo(self);
            make.right.equalTo(self.centerLabel.mas_left).offset(-10);
        }];
    }
    
    if (!self.rightLabel) {
        self.rightLabel = [[UILabel alloc] init];
        [self.rightLabel setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.right.and.centerY.equalTo(self);
            make.left.equalTo(self.centerLabel.mas_right).offset(10);
        }];
    }
}



@end
