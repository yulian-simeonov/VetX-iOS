//
//  PetCellLayout.m
//  VetX
//
//  Created by YulianMobile on 1/4/16.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "PetCellLayout.h"
#import "Constants.h"

@interface PetCellLayout ()

@property (nonatomic, assign) NSUInteger totalPets;

@end

@implementation PetCellLayout


- (CGSize)collectionViewContentSize {
    // Don't scroll horizontally and vertically
//    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentWidth = self.totalPets * 40.0f + (self.totalPets - 1) * 13.0f;
    CGFloat contentHeight = self.collectionView.bounds.size.height;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    NSMutableArray *visibleIndexPaths = [NSMutableArray array];
    self.totalPets = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [visibleIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    for (NSIndexPath *indexPath in [visibleIndexPaths copy]) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForItem:indexPath];
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Helper Functions
- (CGRect)frameForItem:(NSIndexPath *)indexPath {
//    CGFloat startPoint = (SCREEN_WIDTH- (40 * self.totalPets + 13 * (self.totalPets -1 ))) / 2;
    CGFloat startPoint = 0.0f;
    if (startPoint <= 0.0f) {
        startPoint = 0.0f;
    }
    NSInteger row = indexPath.row;
    CGRect frame = CGRectZero;
    CGFloat height = 40.0f;
    CGFloat width = height;
//    CGFloat margin = 13.0f;
    CGFloat x = startPoint + 53 * row;
    CGFloat y = 0;
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = width;
    frame.size.height = height;

    return frame;
}

@end
