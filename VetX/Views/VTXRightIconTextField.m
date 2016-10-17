//
//  VTXRightIconTextField.m
//  VetX
//
//  Created by YulianMobile on 4/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXRightIconTextField.h"
#import "Constants.h"
#import "Masonry.h"

@interface VTXRightIconTextField ()

@property (nonatomic, assign) BOOL hasBorder;
@property (nonatomic, strong) UIImageView *iconView;

@end


@implementation VTXRightIconTextField

- (instancetype)initWithBorder:(BOOL)hasBorder {
    self = [super init];
    if (self) {
        self.hasBorder = hasBorder;
        [self setupTextFieldWithBorder:hasBorder];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (!self.hasBorder) {
        CALayer *upperBorder = [CALayer layer];
        upperBorder.backgroundColor = TEXTFIELD_BORDER_COLOR.CGColor;
        upperBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1.0f, CGRectGetWidth(self.frame), 1.0f);
        [self.layer addSublayer:upperBorder];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    CGFloat titleWidth = 15.0f;
    ret.origin.x = ret.origin.x + titleWidth;
    ret.size.width = ret.size.width - titleWidth;
    return ret;
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    CGFloat titleWidth = 15.0f;
    ret.origin.x = ret.origin.x + titleWidth;
    ret.size.width = ret.size.width - titleWidth;
    return ret;
}

- (void)setupTextFieldWithBorder:(BOOL)hasBorder {
    if (hasBorder) {
        CGFloat borderWidth = 0.5;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [TEXTFIELD_BORDER_COLOR CGColor];
        self.layer.cornerRadius = 1.0f;
        [self.layer setMasksToBounds:YES];
        [self setClipsToBounds:YES];
    }
    [self setFont:VETX_FONT_REGULAR_14];
    [self setTextColor:FEED_CELL_TITLE_COLOR];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}


- (void)setTextFieldIcon:(UIImage *)icon {
    if (!self.iconView) {
        self.iconView = [[UIImageView alloc] initWithImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.iconView setTintColor:GREY_COLOR];
        [self.iconView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.right.equalTo(self).offset(-5);
            make.centerY.equalTo(self);
        }];
    }
}

@end
