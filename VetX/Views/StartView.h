//
//  StartView.h
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartViewDelegate <NSObject>

- (void)didClickLoginBtn;
- (void)didClickVetLoginBtn;
- (void)didClickSignupBtn;

@end

@interface StartView : UIView

@property (nonatomic) id<StartViewDelegate> delegate;

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

@end
