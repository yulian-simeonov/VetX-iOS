//
//  InviteView.h
//  VetX
//
//  Created by YulianMobile on 1/4/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)setReferralCode:(NSString *)code;

@end
