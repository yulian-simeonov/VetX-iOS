//
//  MenuTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 1/13/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface MenuTableViewCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *menuItem;

@end

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCell {
    if (!self.icon) {
        self.icon = [[UIImageView alloc] init];
        [self.icon setTintColor:GREY_COLOR];
        [self addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.and.height.equalTo(@25);
            make.left.equalTo(self).offset(15);
        }];
    }
    if (!self.menuItem) {
        self.menuItem = [[UILabel alloc] init];
        [self.menuItem setFont:VETX_FONT_MEDIUM_15];
        [self.menuItem setTextColor:GREY_COLOR];
        [self addSubview:self.menuItem];
        [self.menuItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.icon.mas_right).offset(15);
        }];
    }
}

- (void)setTitle:(NSString *)title icon:(UIImage *)image {
    [self.icon setImage:image];
    [self.menuItem setText:title];
}

@end
