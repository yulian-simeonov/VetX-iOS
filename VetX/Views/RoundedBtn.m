//
//  RoundedBtn.m
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "RoundedBtn.h"
#import "Constants.h"

@implementation RoundedBtn

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
    [self.titleLabel setFont:VETX_FONT_MEDIUM_15];
    [self setTitleColor:GREY_COLOR forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:2.0];
    [self.layer setBorderWidth:1.0f];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.layer setBorderColor:ORANGE_THEME_COLOR.CGColor];
        [self setBackgroundColor:ORANGE_THEME_COLOR];
    } else {
        [self.layer setBorderColor:GREY_COLOR.CGColor];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
