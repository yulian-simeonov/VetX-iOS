//
//  VTXTextViewWithBottomLine.m
//  VetX
//
//  Created by YulianMobile on 4/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXTextViewWithBottomLine.h"
#import "Constants.h"

@implementation VTXTextViewWithBottomLine

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
        [self setupTextView];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTextView];
    }
    
    return self;
}

- (void)setupTextView {
    [self.layer setMasksToBounds:YES];
    [self setClipsToBounds:YES];
    [self setFont:VETX_FONT_MEDIUM_15];
    [self setTextColor:GREY_COLOR];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

@end
