//
//  FeedCellVetLayout.m
//  VetX
//
//  Created by YulianMobile on 2/3/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "FeedCellVetLayout.h"
#import "Constants.h"

@interface FeedCellVetLayout ()

@property (nonatomic, assign) NSUInteger totalVets;

@end

@implementation FeedCellVetLayout

- (CGSize)collectionViewContentSize {
    // Don't scroll horizontally and vertically
    //    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentWidth = 40.0f + (self.totalVets - 1) * 20.0f;
    CGFloat contentHeight = self.collectionView.bounds.size.height;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    NSMutableArray *visibleIndexPaths = [NSMutableArray array];
    self.totalVets = [self.collectionView numberOfItemsInSection:0];
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
    CGFloat startPoint = 40 - 20*indexPath.row;
    if (startPoint <= 0.0f) {
        startPoint = 0.0f;
    }
//    NSInteger row = indexPath.row;
    CGRect frame = CGRectZero;
    CGFloat height = 40.0f;
    CGFloat width = height;
    //    CGFloat margin = 13.0f;
    CGFloat x = startPoint;
    CGFloat y = 0;
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = width;
    frame.size.height = height;
    
    return frame;
}

@end
