//
//  HNETimePickerLayout.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 23/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "HNETimePickerLayout.h"

@interface HNETimePickerLayout ()
@property (nonatomic, copy) NSArray *componentFrames;
@property (nonatomic, copy) NSArray *selectionFrames;
@property (nonatomic, assign) CGRect separatorFrame;

@property (nonatomic, assign) CGRect boundingRect;

@end

@implementation HNETimePickerLayout

#pragma mark -
#pragma mark Accessors

- (void)setDataSource:(id<HNETimePickerLayoutDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadLayout];
}

- (CGRect)frameForComponentAtIndex:(NSUInteger)idx {
    return [[self.componentFrames objectAtIndex:idx] CGRectValue];
}

- (CGRect)frameForSelectionViewAtIndex:(NSUInteger)idx {
    return [[self.selectionFrames objectAtIndex:idx] CGRectValue];
}

- (CGRect)frameForSeparatorView {
    return self.separatorFrame;
}

#pragma mark -
#pragma mark Actions

- (void)reloadLayout {
    // Shared variables between all components and other frames
    NSUInteger count = [self.dataSource numberOfComponentsInLayout:self];
    NSUInteger separatorIdx = [self.dataSource separatorIndexInLayout:self];
    
    NSAssert(separatorIdx == NSNotFound || count > separatorIdx, @"Separator should either be NSNotFound or within allowed limits (component count)");
    
    CGFloat spacing = [self.dataSource interComponentSpacingInLayout:self];
    CGRect bounds = [self.dataSource boundsForLayout:self];
    
    CGRect boundingRect = CGRectZero;
    CGPoint origin = CGPointZero;
    
    NSMutableArray *components = [NSMutableArray array];
    NSMutableArray *selections = [NSMutableArray array];
    CGRect separatorFrame = CGRectZero;
    
    for (NSUInteger i = 0; i < count; i++) {
        // Main component frame first
        CGSize elementSize = [self.dataSource layout:self elementSizeForComponentAtIndex:i];
        
        CGRect componentFrame = CGRectZero;
        componentFrame.size.width = elementSize.width;
        componentFrame.size.height = CGRectGetHeight(bounds);
        componentFrame.origin = origin;
        [components addObject:[NSValue valueWithCGRect:componentFrame]];
        
        boundingRect = CGRectUnion(boundingRect, componentFrame);
        
        // Selection view next
        CGFloat selectionOffset = [self.dataSource layout:self selectionViewPositionForComponentAtIndex:i];
        CGRect selectionFrame = CGRectZero;
        selectionFrame.size.width = elementSize.width;
        selectionFrame.size.height = elementSize.height;
        selectionFrame.origin = origin;
        selectionFrame.origin.y = (CGRectGetHeight(componentFrame) * selectionOffset) - roundf(elementSize.height / 2.f);
        [selections addObject:[NSValue valueWithCGRect:selectionFrame]];
        
        origin.x += elementSize.width + spacing;
        
        // Check if separator is between here
        if (separatorIdx == i) {
            separatorFrame.size = [self.dataSource separatorSizeInLayout:self];
            separatorFrame.origin.x = origin.x;
            separatorFrame.origin.y = roundf((CGRectGetHeight(componentFrame) - CGRectGetHeight(separatorFrame)) / 2.f);
            
            boundingRect = CGRectUnion(boundingRect, separatorFrame);
            
            origin.x += CGRectGetWidth(separatorFrame) + spacing;
        }
    }
    
    // Center everything horizontally (i.e offset by half of the diff between bounds and bounding rect)
    // Also make sure to keep track of the extended edges (for outer components), this only affects
    // the components and not the selection frames
    CGFloat offset = roundf((CGRectGetWidth(bounds) - CGRectGetWidth(boundingRect)) / 2.f);
    
    BOOL extend = self.extendToEdges && offset > 0.f;
    NSArray *temporary = [components copy];
    NSUInteger lastIdx = [temporary count] - 1;
    
    [temporary enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
        CGRect modified = [value CGRectValue];
        
        if (extend && (idx == 0 || idx == lastIdx)) {
            if (idx == 0) {
                modified.size.width += offset;
            } else if (idx == [temporary count] - 1) {
                modified = CGRectOffset(modified, offset, 0.f);
                modified.size.width += offset;
            }
        } else {
            modified = CGRectOffset(modified, offset, 0.f);
        }
        
        [components replaceObjectAtIndex:idx withObject:[NSValue valueWithCGRect:modified]];
    }];
    
    temporary = [selections copy];
    [temporary enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
        CGRect frame = CGRectOffset([value CGRectValue], offset, 0.f);
        NSValue *newValue = [NSValue valueWithCGRect:frame];
        [selections replaceObjectAtIndex:idx withObject:newValue];
    }];
    
    separatorFrame = CGRectOffset(separatorFrame, offset, 0.f);
    
    // Store the layout so we can access it faster later
    self.componentFrames = components;
    self.selectionFrames = selections;
    self.separatorFrame = separatorFrame;
    self.boundingRect = boundingRect;
}

@end
