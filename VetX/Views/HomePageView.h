//
//  HomePageView.h
//  VetX
//
//  Created by YulianMobile on 1/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)setPetProfileImage:(UIImage *)petImage;

@end
