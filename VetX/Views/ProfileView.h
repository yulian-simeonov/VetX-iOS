//
//  ProfileView.h
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileButton.h"
#import "User.h"

@protocol ProfileViewDelegate <NSObject>

- (void)editProfileClicked;

@end

@interface ProfileView : UIView

@property (nonatomic, assign) id<ProfileViewDelegate> delegate;

- (void)setProfileImage:(UIImage *)image;
- (void)bindUserData:(User *)userObj;

@end
