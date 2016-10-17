//
//  UNETestField.m
//  UNE
//
//  Created by YulianMobile on 11/24/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "VetXTextField.h"
#import "Constants.h"
#import "Masonry.h"

@interface VetXTextField ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *downArrow;

@end

@implementation VetXTextField

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
        [self setupTextField];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTextField];
    }
    
    return self;
}

- (void)setupTextField {
    CGFloat borderWidth = 1;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [DARK_GREY_COLOR CGColor];
    self.layer.cornerRadius = 2.0f;
    [self.layer setMasksToBounds:YES];
    [self setClipsToBounds:YES];
    [self setFont:VETX_FONT_MEDIUM_15];
    [self setTextColor:FEED_CELL_TITLE_COLOR];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    CGFloat titleWidth = 15.0f;
    if (self.iconView) {
        titleWidth = 35.0f;
    }
    ret.origin.x = ret.origin.x + titleWidth;
    ret.size.width = ret.size.width - titleWidth;
    return ret;
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    CGFloat titleWidth = 15.0f;
    if (self.iconView) {
        titleWidth = 35.0f;
    }
    ret.origin.x = ret.origin.x + titleWidth;
    ret.size.width = ret.size.width - titleWidth;
    return ret;
}


- (void)addDownArrow {
    if (!self.downArrow) {
        self.downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DownArrow"]];
        [self addSubview:self.downArrow];
        [self.downArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@6);
            make.width.equalTo(@12);
        }];
    }
}

- (void)setTextFieldIcon:(UIImage *)icon {
    if (!self.iconView) {
        self.iconView = [[UIImageView alloc] initWithImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.iconView setTintColor:DARK_GREY_COLOR];
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@20);
            make.left.and.top.equalTo(self).offset(10);
        }];
    }
}

@end
