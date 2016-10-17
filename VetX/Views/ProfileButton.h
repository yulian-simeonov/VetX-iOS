//
//  ProfileButton.h
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileButton;
@protocol ProfileButtonDelegate <NSObject>

- (void)profileBtnClicked:(ProfileButton *)sender;

@end

@interface ProfileButton : UIView

@property (nonatomic, assign) id<ProfileButtonDelegate> delegate;

- (void)setBttuonTitle:(NSString *)title;
- (void)hideRightLabel;
- (void)hideArrowImage;

@end
