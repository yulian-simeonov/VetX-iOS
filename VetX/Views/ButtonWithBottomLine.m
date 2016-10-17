//
//  ButtonWithBottomLine.m
//  VetX
//
//  Created by YulianMobile on 1/27/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ButtonWithBottomLine.h"
#import "Constants.h"

@implementation ButtonWithBottomLine

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, LIGHT_GREY_COLOR.CGColor);
    CGContextFillRect(context, CGRectMake(0.0f, self.frame.size.height-0.5, self.frame.size.width, 0.5));
}


@end
