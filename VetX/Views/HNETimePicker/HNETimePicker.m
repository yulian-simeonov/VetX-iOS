//
//  HNETimePicker.m
//  HNETimePicker Example
//
//  Created by Henri Normak on 06/10/2014.
//  Copyright (c) 2014 Hone. All rights reserved.
//

#import "HNETimePicker.h"
#import "HNETimeComponent.h"
#import "HNETimePickerCell.h"
#import "HNETimePickerLayout.h"
#import "HNETimePickerComponentLayout.h"
#import "HNETimePickerSelectionView.h"

#import "NSLocale+TimeSeparator.h"

// Format for the components is constant, hour (skeleton), minute and optionally AM/PM symbol
static NSString *const HNETimePickerComponentFormat = @"j mm a";

// Cell identifier, there is only one type of cell used by the picker
static NSString *const HNETimePickerCellIdentifier = @"TimePickerCell";

@interface HNETimePicker () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, HNETimePickerLayoutDataSource>

@property (nonatomic, copy) NSArray *components;
@property (nonatomic, copy) NSArray *collectionViews;
@property (nonatomic, copy) NSArray *selectionViews;
@property (nonatomic, strong) UILabel *separatorView;

@property (nonatomic, strong) HNETimePickerLayout *layout;
@property (nonatomic, copy) NSArray *componentWidths;

- (void)commonInitialisation;

- (CGSize)elementSizeForComponentAtIndex:(NSUInteger)idx;
- (UIEdgeInsets)contentInsetsForComponentAtIndex:(NSUInteger)idx;
- (CGPoint)contentOffsetForComponentAtIndex:(NSUInteger)idx;

- (CGFloat)widthForComponentAtIndex:(NSUInteger)idx;
- (void)recalculateComponentWidths;

- (NSAttributedString *)attributedSeparator;
- (NSAttributedString *)attributedStringForComponentAtIndex:(NSUInteger)idx elementIndex:(NSUInteger)elementIdx;

- (void)rebuildComponents;
- (void)rebuildViews;

- (void)recalculateValue;

@end

@implementation HNETimePicker

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

- (void)commonInitialisation {
    _locale = [NSLocale autoupdatingCurrentLocale];
    _cellAlphaDelta = .7f;
    _interCellSpacing = 4.f;
    _interComponentSpacing = 8.f;
    _selectionCornerRadius = 4.f;
    _selectionStrokeWidth = 2.f;
    _cellContentInset = UIEdgeInsetsMake(8.f, 4.f, 8.f, 4.f);
    _cellFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.layout = [[HNETimePickerLayout alloc] init];
    self.layout.dataSource = self;
    self.layout.extendToEdges = YES;
    
    [self rebuildComponents];
    [self recalculateComponentWidths];
    [self.layout reloadLayout];
    [self rebuildViews];
}

#pragma mark -
#pragma mark Accessors

- (void)setLocale:(NSLocale *)locale {
    _locale = locale;
    
    [self rebuildComponents];
    [self recalculateComponentWidths];
    [self.layout reloadLayout];
    
    [self rebuildViews];
}

- (void)setDate:(NSDate *)date {
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    _date = date;
    
    [self rebuildComponents];
    
    NSUInteger count = [self.components count];
    for (NSUInteger i = 0; i < count; i++) {
        HNETimeComponent *component = [self.components objectAtIndex:i];
        UICollectionView *collectionView = [self.collectionViews objectAtIndex:i];
        HNETimePickerComponentLayout *layout = (HNETimePickerComponentLayout *)[collectionView collectionViewLayout];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:component.selectedIndex inSection:0];
        [collectionView setContentOffset:[layout contentOffsetForSelectingItemAtIndexPath:path] animated:animated];
    }
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    [super setBounds:bounds];
    
    if (!CGRectEqualToRect(oldBounds, bounds)) {
        [self.layout reloadLayout];
        [self.collectionViews makeObjectsPerformSelector:@selector(reloadData)];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    // Return the size that our layout deems as ideal
    return [self.layout boundingRect].size;
}

#pragma mark -
#pragma mark Appearance

- (void)setInterCellSpacing:(CGFloat)interCellSpacing {
    _interCellSpacing = interCellSpacing;
    [[self.collectionViews valueForKeyPath:@"layout"] makeObjectsPerformSelector:@selector(invalidateLayout)];
    [self setNeedsLayout];
}

- (void)setInterComponentSpacing:(CGFloat)interComponentSpacing {
    _interComponentSpacing = interComponentSpacing;
    
    [self.layout reloadLayout];
    [self setNeedsLayout];
}

- (void)setSelectionCornerRadius:(CGFloat)selectionCornerRadius {
    _selectionCornerRadius = selectionCornerRadius;
    [self.selectionViews setValue:@(selectionCornerRadius) forKeyPath:@"cornerRadius"];
}

- (void)setSelectionStrokeWidth:(CGFloat)selectionStrokeWidth {
    _selectionStrokeWidth = selectionStrokeWidth;
    [self.selectionViews setValue:@(selectionStrokeWidth) forKeyPath:@"strokeWidth"];
    
    [self.layout reloadLayout];
    [self setNeedsLayout];
}

- (void)setSelectionStrokeColor:(UIColor *)selectionStrokeColor {
    _selectionStrokeColor = selectionStrokeColor;
    [self.selectionViews setValue:selectionStrokeColor forKeyPath:@"strokeColor"];
}

- (void)setCellAlphaDelta:(CGFloat)cellAlphaDelta {
    _cellAlphaDelta = MIN(1.f, MAX(0.f, cellAlphaDelta));
    [self.collectionViews setValue:@(1.f - cellAlphaDelta) forKeyPath:@"layout.minimumAlpha"];
    [[self.collectionViews valueForKeyPath:@"layout"] makeObjectsPerformSelector:@selector(invalidateLayout)];
}

- (void)setCellFont:(UIFont *)cellFont {
    if (!cellFont)
        cellFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    _cellFont = cellFont;
    
    [self recalculateComponentWidths];
    
    self.separatorView.attributedText = [self attributedSeparator];
    [self.collectionViews makeObjectsPerformSelector:@selector(reloadData)];
    
    [self.layout reloadLayout];
    [self setNeedsLayout];
}

- (void)setCellKerningFactor:(CGFloat)cellKerningFactor {
    _cellKerningFactor = cellKerningFactor;
    
    [self recalculateComponentWidths];
    
    self.separatorView.attributedText = [self attributedSeparator];
    [self.collectionViews makeObjectsPerformSelector:@selector(reloadData)];
    
    [self.layout reloadLayout];
    [self setNeedsLayout];
}

- (void)setCellTextColor:(UIColor *)cellTextColor {
    _cellTextColor = cellTextColor;
    
    self.separatorView.attributedText = [self attributedSeparator];
    [self.collectionViews makeObjectsPerformSelector:@selector(reloadData)];
}

- (void)setCellContentInset:(UIEdgeInsets)cellContentInset {
    _cellContentInset = cellContentInset;
    
    [self.collectionViews makeObjectsPerformSelector:@selector(reloadData)];
    
    [self.layout reloadLayout];
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = [self.collectionViews count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // Collection view first
        UICollectionView *collectionView = [self.collectionViews objectAtIndex:i];
        HNETimePickerComponentLayout *layout = (HNETimePickerComponentLayout *)[collectionView collectionViewLayout];
        
        // Invalidate layout first, this makes sure that the frame change will not cause any
        // invalid layouts to occur, i.e for example when the new frame is smaller than the previous
        // one
        [layout invalidateLayout];
        
        collectionView.frame = [self.layout frameForComponentAtIndex:i];
        collectionView.contentInset = [self contentInsetsForComponentAtIndex:i];
        collectionView.contentOffset = [self contentOffsetForComponentAtIndex:i];
        
        // Selection view second
        UIView *selectionView = [self.selectionViews objectAtIndex:i];
        selectionView.frame = [self.layout frameForSelectionViewAtIndex:i];
    }
    
    self.separatorView.frame = [self.layout frameForSeparatorView];
}

- (CGSize)elementSizeForComponentAtIndex:(NSUInteger)idx {
    CGSize size = CGSizeZero;
    
    // Height is the font + padding
    size.height = [self.cellFont lineHeight];
    size.height += 4.f;
    size.height += 2 * self.selectionStrokeWidth;
    size.height += self.cellContentInset.top + self.cellContentInset.bottom;
    
    // Width is component width + padding
    size.width = [self widthForComponentAtIndex:idx];
    size.width += 4.f;
    size.width += self.cellContentInset.right + self.cellContentInset.left;
    size.width += 2 * self.selectionStrokeWidth;
    
    return size;
}

- (UIEdgeInsets)contentInsetsForComponentAtIndex:(NSUInteger)idx {
    HNETimePickerComponentLayout *layout = (HNETimePickerComponentLayout *)[[self.collectionViews objectAtIndex:idx] collectionViewLayout];
    CGRect bounds = [self.layout frameForComponentAtIndex:idx];
    CGFloat offset = roundf([self elementSizeForComponentAtIndex:idx].height / 2.f);
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = CGRectGetHeight(bounds) * layout.selectionOffset - offset;
    insets.bottom = CGRectGetHeight(bounds) * (1.f - layout.selectionOffset) - offset;
    
    return insets;
}

- (CGPoint)contentOffsetForComponentAtIndex:(NSUInteger)idx {
    HNETimePickerComponentLayout *layout = (HNETimePickerComponentLayout *)[[self.collectionViews objectAtIndex:idx] collectionViewLayout];
    HNETimeComponent *component = [self.components objectAtIndex:idx];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:component.selectedIndex inSection:0];
    return [layout contentOffsetForSelectingItemAtIndexPath:path];
}

- (CGFloat)widthForComponentAtIndex:(NSUInteger)idx {
    return [[self.componentWidths objectAtIndex:idx] floatValue];
}

- (void)recalculateComponentWidths {
    NSMutableArray *widths = [NSMutableArray array];
    
    [self.components enumerateObjectsUsingBlock:^(HNETimeComponent *component, NSUInteger idx, BOOL *stop) {
        NSUInteger count = [component numberOfElements];
        CGFloat maxWidth = 0.f;
        
        for (NSUInteger i = 0; i < count; i++) {
            NSAttributedString *attributedString = [self attributedStringForComponentAtIndex:idx elementIndex:i];
            CGRect bounds = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            maxWidth = MAX(maxWidth, ceilf(CGRectGetMaxX(bounds)));
        }
        
        [widths addObject:@(maxWidth)];
    }];
    
    self.componentWidths = widths;
}

#pragma mark -
#pragma mark Helpers

- (NSAttributedString *)attributedSeparator {
    NSString *string = [self.locale timeSeparatorString];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (self.cellFont)
        [attributes setObject:self.cellFont forKey:NSFontAttributeName];
    
    if (self.cellTextColor)
        [attributes setObject:self.cellTextColor forKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paraStyle.alignment = NSTextAlignmentCenter;
    [attributes setObject:paraStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    [attributedString addAttribute:NSKernAttributeName value:@(self.cellKerningFactor) range:NSMakeRange(0, [attributedString length] - 1)];
    
    return attributedString;
}

- (NSAttributedString *)attributedStringForComponentAtIndex:(NSUInteger)idx elementIndex:(NSUInteger)elementIdx {
    HNETimeComponent *component = [self.components objectAtIndex:idx];
    NSString *string = [component stringValueForElementAtIndex:elementIdx];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (self.cellFont)
        [attributes setObject:self.cellFont forKey:NSFontAttributeName];
    
    if (self.cellTextColor)
        [attributes setObject:self.cellTextColor forKey:NSForegroundColorAttributeName];
    
    
    NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paraStyle.alignment = NSTextAlignmentCenter;
    [attributes setObject:paraStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    [attributedString addAttribute:NSKernAttributeName value:@(self.cellKerningFactor) range:NSMakeRange(0, [attributedString length] - 1)];
    
    return attributedString;
}

#pragma mark -
#pragma mark Rebuilding

- (void)rebuildComponents {
    self.components = [HNETimeComponent timeComponentsFromDateFormatTemplate:HNETimePickerComponentFormat locale:self.locale date:self.date];
}

- (void)rebuildViews {
    // Clear existing views
    [self.collectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.collectionViews = nil;
    
    [self.selectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.selectionViews = nil;
    
    [self.separatorView removeFromSuperview];
    self.separatorView = nil;
    
    // Create the new ones, split them equally horizontally
    NSMutableArray *newCollectionViews = [NSMutableArray array];
    NSMutableArray *newSelectionViews = [NSMutableArray array];
    
    NSUInteger count = [self.components count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // Collection view
        HNETimePickerComponentLayout *layout = [[HNETimePickerComponentLayout alloc] init];
        layout.minimumAlpha = 1.f - self.cellAlphaDelta;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[self.layout frameForComponentAtIndex:i] collectionViewLayout:layout];
        [collectionView registerClass:[HNETimePickerCell class] forCellWithReuseIdentifier:HNETimePickerCellIdentifier];
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.alwaysBounceVertical = YES;
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [newCollectionViews addObject:collectionView];
        [self addSubview:collectionView];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        // Selection view
        HNETimePickerSelectionView *selectionView = [[HNETimePickerSelectionView alloc] initWithFrame:[self.layout frameForSelectionViewAtIndex:i]];
        selectionView.strokeWidth = self.selectionStrokeWidth;
        selectionView.cornerRadius = self.selectionCornerRadius;
        selectionView.strokeColor = self.selectionStrokeColor;
        
        [newSelectionViews addObject:selectionView];
        [self addSubview:selectionView];
    }
    
    self.collectionViews = newCollectionViews;
    self.selectionViews = newSelectionViews;
    
    // Separator
    self.separatorView = [[UILabel alloc] initWithFrame:[self.layout frameForSeparatorView]];
    self.separatorView.attributedText = [self attributedSeparator];
    [self addSubview:self.separatorView];
}

#pragma mark -
#pragma mark Value

- (void)recalculateValue {
    // Determine the "selected" rows of each component and thus their
    // values that need to be added to the components
    [self.collectionViews enumerateObjectsUsingBlock:^(UICollectionView *view, NSUInteger idx, BOOL *stop) {
        HNETimePickerComponentLayout *layout = (HNETimePickerComponentLayout *)[view collectionViewLayout];
        NSIndexPath *path = [layout indexPathOfSelectedItem];
        HNETimeComponent *component = [self.components objectAtIndex:idx];
        component.selectedIndex = path.row;
    }];
    
    NSDateComponents *components = [HNETimeComponent dateComponentsFromTimeComponents:self.components];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    _date = [calendar nextDateAfterDate:[NSDate date] matchingComponents:components options:NSCalendarMatchNextTimePreservingSmallerUnits];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark HNETimePickerLayoutDataSource

- (CGRect)boundsForLayout:(HNETimePickerLayout *)layout {
    return self.bounds;
}

- (NSUInteger)numberOfComponentsInLayout:(HNETimePickerLayout *)layout {
    return [self.components count];
}

- (NSUInteger)separatorIndexInLayout:(HNETimePickerLayout *)layout {
    // Separator is between hour and minute components (in that order)
    __block NSUInteger index = NSNotFound;
    
    [self.components enumerateObjectsUsingBlock:^(HNETimeComponent *component, NSUInteger idx, BOOL *stop) {
        if (component.unit == HNETimeComponentUnitHour && idx < [self.components count] - 1) {
            HNETimeComponent *nextComponent = [self.components objectAtIndex:idx + 1];
            if (nextComponent.unit == HNETimeComponentUnitMinute) {
                index = idx;
                *stop = YES;
            }
        }
    }];
    
    return index;
}

- (CGFloat)interComponentSpacingInLayout:(HNETimePickerLayout *)layout {
    return self.interComponentSpacing;
}

- (CGSize)separatorSizeInLayout:(HNETimePickerLayout *)layout {
    [self.separatorView sizeToFit];
    return self.separatorView.bounds.size;
}

- (CGSize)layout:(HNETimePickerLayout *)layout elementSizeForComponentAtIndex:(NSUInteger)idx {
    return [self elementSizeForComponentAtIndex:idx];
}

- (CGFloat)layout:(HNETimePickerLayout *)layout selectionViewPositionForComponentAtIndex:(NSUInteger)idx {
    return 0.5f;    // This could be changed, but as it is not exposed to outside world, there is no need
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger idx = [self.collectionViews indexOfObject:collectionView];
    if (idx != NSNotFound) {
        HNETimeComponent *component = [self.components objectAtIndex:idx];
        return [component numberOfElements];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HNETimePickerCell *cell = (HNETimePickerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HNETimePickerCellIdentifier forIndexPath:indexPath];

    NSUInteger componentIdx = [self.collectionViews indexOfObject:collectionView];
    NSUInteger lastIdx = [self.components count] - 1;
    
    if (componentIdx != NSNotFound) {
        // Use an attributed text as the label text
        cell.label.attributedText = [self attributedStringForComponentAtIndex:componentIdx elementIndex:indexPath.row];
        
        UIEdgeInsets insets = self.cellContentInset;
        insets.top += self.selectionStrokeWidth;
        insets.bottom += self.selectionStrokeWidth;
        insets.right += self.selectionStrokeWidth;
        insets.left += self.selectionStrokeWidth;
        
        // For outer components, adjust the insets a bit to counteract the
        // extended edges of the components
        if (componentIdx == 0 && componentIdx != lastIdx) {
            CGRect selectionFrame = [self.layout frameForSelectionViewAtIndex:componentIdx];
            insets.left += CGRectGetWidth(cell.frame) - CGRectGetWidth(selectionFrame);
        } else if (componentIdx == lastIdx && componentIdx != 0) {
            CGRect selectionFrame = [self.layout frameForSelectionViewAtIndex:componentIdx];
            insets.right += CGRectGetWidth(cell.frame) - CGRectGetWidth(selectionFrame);
        }
        
        cell.contentInset = insets;
    }
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.interCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interCellSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger idx = [self.collectionViews indexOfObject:collectionView];
    if (idx != NSNotFound) {
        CGSize elementSize = [self elementSizeForComponentAtIndex:idx];
        
        // Use the width of the collection view, that way it won't complain about width > collectionView.width and there will only be one element per row
        return CGSizeMake(CGRectGetWidth(collectionView.frame), elementSize.height);
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HNETimePickerComponentLayout *layout = (HNETimePickerComponentLayout *)collectionView.collectionViewLayout;
    CGPoint offset = [layout contentOffsetForSelectingItemAtIndexPath:indexPath];
    [collectionView setContentOffset:offset animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self recalculateValue];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self recalculateValue];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self recalculateValue];
}

@end
