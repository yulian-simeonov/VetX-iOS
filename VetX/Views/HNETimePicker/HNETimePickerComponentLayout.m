//
//  HNETimePickerComponentLayout.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 07/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "HNETimePickerComponentLayout.h"

@interface HNETimePickerComponentLayout ()
@property (nonatomic, assign) UIEdgeInsets addedInsets;
@end

@implementation HNETimePickerComponentLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.alphaOffset = 0.05f;
        self.selectionOffset = 0.5f;
        self.minimumAlpha = 0.f;
        self.maximumAlpha = 1.f;
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.alphaOffset = 0.05f;
        self.selectionOffset = 0.5f;
        self.minimumAlpha = 0.f;
        self.maximumAlpha = 1.f;
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setAlphaOffset:(CGFloat)alphaOffset {
    _alphaOffset = MAX(0.f, MIN(1.f, alphaOffset));
    [self invalidateLayout];
}

- (void)setSelectionOffset:(CGFloat)selectionOffset {
    _selectionOffset = MAX(0.f, MIN(1.f, selectionOffset));
    [self invalidateLayout];
}

- (void)setMinimumAlpha:(CGFloat)minimumAlpha {
    _minimumAlpha = MAX(0.f, MIN(1.f, minimumAlpha));
    [self invalidateLayout];
}

- (void)setMaximumAlpha:(CGFloat)maximumAlpha {
    _maximumAlpha = MAX(0.f, MIN(1.f, maximumAlpha));
    [self invalidateLayout];
}

#pragma mark -
#pragma mark Actions

- (NSIndexPath *)indexPathOfSelectedItem {
    // Determine the point to query for an index path
    CGPoint point = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMidY(self.collectionView.bounds));
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        point.x += CGRectGetWidth(self.collectionView.bounds) * (self.selectionOffset - 0.5);
    } else if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        point.y += CGRectGetHeight(self.collectionView.bounds) * (self.selectionOffset - 0.5);
    }
    
    return [self.collectionView indexPathForItemAtPoint:point];
}

- (CGPoint)contentOffsetForSelectingItemAtIndexPath:(NSIndexPath *)path {
    CGRect bounds = self.collectionView.bounds;
    UIEdgeInsets insets = self.collectionView.contentInset;
    CGSize size = [self collectionViewContentSize];
    
    CGRect frame = [self layoutAttributesForItemAtIndexPath:path].frame;
    CGPoint offset = CGPointZero;
    
    // Position the frame in a way that aligns it's center line with out selection offset
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat candidate = CGRectGetMinX(frame) - (self.selectionOffset * CGRectGetWidth(bounds)) + roundf(CGRectGetWidth(frame) / 2.f);
        offset.x = MAX(-insets.left, MIN(size.width + insets.right - CGRectGetWidth(bounds), candidate));
    } else if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat candidate = CGRectGetMinY(frame) - (self.selectionOffset * CGRectGetHeight(bounds)) + roundf(CGRectGetHeight(frame) / 2.f);
        offset.y = MAX(-insets.top, MIN(size.height + insets.bottom - CGRectGetHeight(bounds), candidate));
    }
    
    return offset;
}

#pragma mark -
#pragma mark UICollectionViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES; // We want to update alpha as we scroll or as the size changes
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *regular = [super layoutAttributesForElementsInRect:rect];
    CGRect bounds = self.collectionView.bounds;
    
    // Loop over the attributes and apply suitable alpha interpolations
    for (UICollectionViewLayoutAttributes *attribute in regular) {
        CGRect frame = attribute.frame;
        CGFloat offset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (CGRectGetMidX(frame) - CGRectGetMinX(bounds)) / CGRectGetWidth(bounds) :
                            (CGRectGetMidY(frame) - CGRectGetMinY(bounds)) / CGRectGetHeight(bounds);
        
        if (offset < 0.f || offset > 1.f) {
            attribute.alpha = self.minimumAlpha;
        } else if (offset < self.selectionOffset - self.alphaOffset) {
            // Above the selection
            CGFloat position = offset / (self.selectionOffset - self.alphaOffset);
            attribute.alpha = self.minimumAlpha + (self.maximumAlpha - self.minimumAlpha) * position;
        } else if (offset > self.selectionOffset + self.alphaOffset) {
            // Below the selection
            CGFloat position = 1.f - ((offset - self.selectionOffset - self.alphaOffset) / (1.f - (self.selectionOffset + self.alphaOffset)));
            attribute.alpha = self.minimumAlpha + (self.maximumAlpha - self.minimumAlpha) * position;
        } else {
            attribute.alpha = self.maximumAlpha;
        }
    }
    
    return regular;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect = self.collectionView.bounds;
    rect.origin = proposedContentOffset;
    NSArray *attributes = [self layoutAttributesForElementsInRect:rect];
    
    // Our goal is to have an attribute line up with our selection offset
    CGPoint target = CGPointMake(roundf(CGRectGetWidth(self.collectionView.bounds) * self.selectionOffset), CGRectGetHeight(self.collectionView.bounds) * self.selectionOffset);
    target.y += proposedContentOffset.y;
    target.x += proposedContentOffset.x;
    
    CGSize bestOffset = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    UICollectionViewLayoutAttributes *bestAttribute = nil;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGRect frame = attribute.frame;
        CGSize offset = CGSizeMake(fabs(CGRectGetMidX(frame) - target.x), fabs(CGRectGetMidY(frame) - target.y));
        
        if (!bestAttribute || offset.height < bestOffset.height || (offset.height == bestOffset.height && offset.width < bestOffset.width)) {
            bestAttribute = attribute;
            bestOffset = offset;
        }
    }
    
    // If we found a best match attribute, adjust the proposed offset to center the best match
    if (bestAttribute) {
        proposedContentOffset = [self contentOffsetForSelectingItemAtIndexPath:bestAttribute.indexPath];
    }
    
    // Make sure we don't scroll out of bounds
    CGSize contentSize = self.collectionView.contentSize;
    UIEdgeInsets insets = self.collectionView.contentInset;
    proposedContentOffset.x = MIN(contentSize.width - CGRectGetWidth(rect) + insets.right, MAX(-insets.left, proposedContentOffset.x));
    proposedContentOffset.y = MIN(contentSize.height - CGRectGetHeight(rect) + insets.bottom, MAX(-insets.top, proposedContentOffset.y));
    
    return proposedContentOffset;
}

@end
