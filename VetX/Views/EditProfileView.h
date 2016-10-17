//
//  EditProfileView.h
//  VetX
//
//  Created by YulianMobile on 1/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTXRightIconTextField.h"

@protocol EditProfileDelegate <NSObject>

- (void)didClickAddProfileBtn;

@end

@interface EditProfileView : UIView

@property (nonatomic, assign) id<EditProfileDelegate> delegate;

@property (nonatomic, strong) UIButton *profileImage;
@property (nonatomic, strong) UILabel *editProfileLabel;
@property (nonatomic, strong) VTXRightIconTextField *firstNameField;
@property (nonatomic, strong) VTXRightIconTextField *lastNameField;
@property (nonatomic, strong) VTXRightIconTextField *emailField;
@property (nonatomic, strong) VTXRightIconTextField *phoneField;
@property (nonatomic, strong) UITextView *userBio;


@end
