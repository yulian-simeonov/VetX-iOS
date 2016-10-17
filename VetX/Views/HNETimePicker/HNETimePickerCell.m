//
//  HNETimePickerCell.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 20/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "HNETimePickerCell.h"

@interface HNETimePickerCell ()
@property (nonatomic, readwrite) UILabel *label;

- (void)commonInitialisation;

@end

@implementation HNETimePickerCell

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
    self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.label];
}

#pragma mark -
#pragma mark Accessors

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    self.label.frame = self.contentView.bounds;
}

@end
