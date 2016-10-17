//
//  HNETimePickerSelectionView.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 20/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "HNETimePickerSelectionView.h"

@interface HNETimePickerSelectionView ()

- (void)commonInitialisation;

@end

@implementation HNETimePickerSelectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInitialisation];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialisation];
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self commonInitialisation];
    }
    
    return self;
}

- (void)commonInitialisation {
    _cornerRadius = 4.f;
    _strokeWidth = 2.f;
    _strokeColor = [UIColor blackColor];
    
    self.contentMode = UIViewContentModeRedraw;
}

#pragma mark -
#pragma mark Accessors

- (BOOL)isUserInteractionEnabled {
    return NO;
}

- (BOOL)isOpaque {
    return NO;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = MAX(0.f, cornerRadius);
    [self setNeedsDisplay];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = MAX(0.f, strokeWidth);
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = CGRectInset(self.bounds, self.strokeWidth / 2.f, self.strokeWidth / 2.f);
    
    // Make sure the radius is usable
    CGFloat radius = MIN(MAX(self.cornerRadius, 0.f), MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds)) / 2.f);
    CGPathRef path = CGPathCreateWithRoundedRect(bounds, radius, radius, NULL);
    
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    CGContextSetLineWidth(ctx, self.strokeWidth);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}
 
@end
