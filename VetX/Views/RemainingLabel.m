//
//  RemainingLabel.m
//  VetX
//
//  Created by YulianMobile on 1/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "RemainingLabel.h"
#import "Constants.h"
#import "Masonry.h"

@interface RemainingLabel ()

@property (nonatomic, strong) UILabel *remaining;

@end

@implementation RemainingLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.0);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, 0.0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width/2.0, rect.size.height-20.0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, 0.0);
    
    CGContextSetFillColorWithColor(context, ORANGE_THEME_COLOR.CGColor);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, 0.0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width/2.0, rect.size.height-20.0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if (!self.remaining) {
        self.remaining = [[UILabel alloc] init];
        [self.remaining setNumberOfLines:3];
        [self.remaining setFont:VETX_FONT_MEDIUM_12];
        [self.remaining setTextAlignment:NSTextAlignmentCenter];
        [self.remaining setLineBreakMode:NSLineBreakByWordWrapping];
        [self.remaining setTextColor:[UIColor whiteColor]];
        [self addSubview:self.remaining];
        [self.remaining mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.width.equalTo(self);
            make.top.equalTo(self).offset(5);
        }];
    }
}

- (void)setRemainingText:(NSString *)remaining {
    [self.remaining setText:remaining];
    [self.remaining sizeToFit];
}

@end
