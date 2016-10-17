//
//  VTXTextFieldWithBottomLine.m
//  VetX
//
//  Created by YulianMobile on 4/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXTextFieldWithBottomLine.h"
#import "Constants.h"
#import "Masonry.h"

@interface VTXTextFieldWithBottomLine ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *downArrow;

@end

@implementation VTXTextFieldWithBottomLine

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = GREY_COLOR.CGColor;
    upperBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1.0f, CGRectGetWidth(self.frame), 1.0f);
    [self.layer addSublayer:upperBorder];
}

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
    [self.layer setMasksToBounds:YES];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [self setClipsToBounds:YES];
    [self setFont:VETX_FONT_MEDIUM_15];
    [self setTextColor:GREY_COLOR];
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
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

@end
