//
//  VetXVerticalButton.m
//  VetX
//
//  Created by YulianMobile on 1/29/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "VetXVerticalButton.h"

@interface VetXVerticalButton ()

@property (nonatomic, assign) BOOL titleAtBottom;

@end

@implementation VetXVerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize titleAtBottom; // BOOL property

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleAtBottom = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleAtBottom = YES;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    self.titleLabel.text = [self titleForState: self.state];
    
    UIEdgeInsets imageInsets = self.imageEdgeInsets;
    UIEdgeInsets titleInsets = self.titleEdgeInsets;
    
    CGSize imageSize = [self imageForState: self.state].size;
    if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
        imageSize.width += imageInsets.left + imageInsets.right;
        imageSize.height += imageInsets.top + imageInsets.bottom;
        
    }
    
    CGSize textSize = [self.titleLabel sizeThatFits: CGSizeMake(size.width - titleInsets.left - titleInsets.right,
                                                                size.height -(imageSize.width +
                                                                              titleInsets.top+titleInsets.bottom))];
    if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
        textSize.width += titleInsets.left + titleInsets.right;
        textSize.height += titleInsets.top + titleInsets.bottom;
    }
    
    CGSize result = CGSizeMake(MAX(textSize.width, imageSize.width),
                               textSize.height + imageSize.height);
    return result;
}

- (void)layoutSubviews {
    // needed to update all properities of child views:
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGRect titleFrame = UIEdgeInsetsInsetRect(bounds, self.titleEdgeInsets);
    CGRect imageFrame = UIEdgeInsetsInsetRect(bounds, self.imageEdgeInsets);
    if (self.titleAtBottom) {
//        CGFloat titleHeight = [self.titleLabel sizeThatFits: titleFrame.size].height;
//        titleFrame.origin.y = CGRectGetMaxY(titleFrame)-titleHeight;
//        titleFrame.size.height = titleHeight;
//        titleFrame = CGRectStandardize(titleFrame);
//        self.titleLabel.frame = titleFrame;
//        
//        CGFloat imageBottom = CGRectGetMinY(titleFrame)-(self.titleEdgeInsets.top+self.imageEdgeInsets.bottom);
//        imageFrame.size.height = imageBottom - CGRectGetMinY(imageFrame);
//        self.imageView.frame = CGRectStandardize(imageFrame);
        int kTextTopPadding = 3;
        
        CGRect titleLabelFrame = self.titleLabel.frame;
        
        CGRect labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.bounds)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
        
        CGRect imageFrame = self.imageView.frame;
        
        CGSize fitBoxSize = (CGSize){.height = labelSize.size.height + kTextTopPadding +  imageFrame.size.height, .width = MAX(imageFrame.size.width, labelSize.size.width)};
        
        CGRect fitBoxRect = CGRectInset(self.bounds, (self.bounds.size.width - fitBoxSize.width)/2, (self.bounds.size.height - fitBoxSize.height)/2);
        
        imageFrame.origin.y = fitBoxRect.origin.y;
        imageFrame.origin.x = CGRectGetMidX(fitBoxRect) - (imageFrame.size.width/2);
        self.imageView.frame = imageFrame;
        
        // Adjust the label size to fit the text, and move it below the image
        
        titleLabelFrame.size.width = labelSize.size.width;
        titleLabelFrame.size.height = labelSize.size.height;
        titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.size.width / 2);
        titleLabelFrame.origin.y = fitBoxRect.origin.y + imageFrame.size.height + kTextTopPadding;
        self.titleLabel.frame = titleLabelFrame;
    } else {
        CGFloat titleHeight = [self.titleLabel sizeThatFits: titleFrame.size].height;
        titleFrame.size.height = titleHeight;
        titleFrame = CGRectStandardize(titleFrame);
        self.titleLabel.frame = titleFrame;
        
        CGFloat imageTop = CGRectGetMaxY(titleFrame)+(self.titleEdgeInsets.bottom+self.imageEdgeInsets.top);
        imageFrame.size.height = CGRectGetMaxY(imageFrame) - imageTop;
        self.imageView.frame = CGRectStandardize(imageFrame);
    }
}

- (void)setTitleAtBottom:(BOOL)newTitleAtBottom {
    if (titleAtBottom!=newTitleAtBottom) {
        titleAtBottom=newTitleAtBottom;
        [self setNeedsLayout];
    }
}


@end
