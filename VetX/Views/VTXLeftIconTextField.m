//
//  VTXLeftIconTextField.m
//  VetX
//
//  Created by YulianMobile on 5/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXLeftIconTextField.h"
#import "Constants.h"
#import "Masonry.h"

@interface VTXLeftIconTextField ()

@property (nonatomic, assign) BOOL hasBorder;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation VTXLeftIconTextField

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
        upperBorder.backgroundColor = [UIColor whiteColor].CGColor;
        upperBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1.0f, CGRectGetWidth(self.frame), 1.0f);
        [self.layer addSublayer:upperBorder];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    CGFloat titleWidth = 40.0f;
    ret.origin.x = ret.origin.x + titleWidth;
    ret.size.width = ret.size.width - titleWidth;
    return ret;
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    CGFloat titleWidth = 40.0f;
    ret.origin.x = ret.origin.x + titleWidth;
    ret.size.width = ret.size.width - titleWidth;
    return ret;
}

- (void)setupTextFieldWithBorder:(BOOL)hasBorder {
    if (hasBorder) {
        CGFloat borderWidth = 0.5;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.cornerRadius = 1.0f;
        [self.layer setMasksToBounds:YES];
        [self setClipsToBounds:YES];
    }
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self setFont:VETX_FONT_REGULAR_14];
    [self setTextColor:[UIColor whiteColor]];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.attributedPlaceholder = str;
}

- (void)setTextFieldIcon:(UIImage *)icon {
    if (!self.iconView) {
        self.iconView = [[UIImageView alloc] initWithImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.iconView setTintColor:[UIColor whiteColor]];
        [self.iconView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
    }
}

@end
