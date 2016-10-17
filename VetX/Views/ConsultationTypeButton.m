//
//  ConsultationTypeButton.m
//  VetX
//
//  Created by YulianMobile on 1/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ConsultationTypeButton.h"
#import "Constants.h"

@implementation ConsultationTypeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.layer setBorderWidth:1.0];
    [self.layer setBorderColor:GREY_COLOR.CGColor];
    [self.layer setCornerRadius:5.0];
    [self setClipsToBounds:YES];
    [self setTintColor:GREY_COLOR];
    [self setTitleColor:GREY_COLOR forState:UIControlStateNormal];
    [self setTitleColor:ORANGE_THEME_COLOR forState:UIControlStateSelected];
    [self.titleLabel setFont:VETX_FONT_MEDIUM_13];
    [self.titleLabel setNumberOfLines:2];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(self.frame.size.width/4.0, 16.5, 0.0, 0.0)];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled) {
        [self showUnavailable];
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [self setTintColor:ORANGE_THEME_COLOR];
    } else {
        [self setTintColor:GREY_COLOR];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(self.frame)-50.0f;
    return CGRectMake((CGRectGetWidth(self.frame)-height)/2.0, 40.0f, height, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(5.0, 0.0, CGRectGetWidth(self.frame)-10.0, 40.0);
}

- (void)showUnavailable {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(CGRectGetWidth(self.frame)-50.0f, CGRectGetHeight(self.frame)-50.0f, 50.0f, 50.0f);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, 50.0f);
    CGPathAddLineToPoint(path, NULL, 50.0f, 0.0f);
    CGPathAddLineToPoint(path, NULL, 50.0f, 20.0f);
    CGPathAddLineToPoint(path, NULL, 20.0f, 50.0f);
    layer.path = path;
    [layer setFillColor:ORANGE_THEME_COLOR.CGColor];
    
    [self.layer addSublayer:layer];
    
    UILabel* label = [[UILabel alloc] init];
    label.text = @"Unavailable";
    label.font = VETX_FONT_MEDIUM_8;
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(CGRectGetWidth(self.frame)-20.0f, CGRectGetHeight(self.frame)-20.0f);
    label.transform = CGAffineTransformMakeRotation(-1.57079633/2.0);
    [label sizeToFit];
    [self addSubview:label];
}
@end
