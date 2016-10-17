//
//  SettingsTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 1/4/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UIImageView *arrowImage;
@property (strong, nonatomic) UISwitch *switchToggle;

@end
