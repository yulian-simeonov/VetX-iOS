//
//  SettingsTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 1/4/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "SettingsTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface SettingsTableViewCell ()



@end

@implementation SettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCell {
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setTextColor:GREY_COLOR];
        [self.titleLabel setFont:VETX_FONT_MEDIUM_17];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }];
    }
    
    if (!self.secondLabel) {
        self.secondLabel = [[UILabel alloc] init];
        [self.secondLabel setTextColor:GREY_COLOR];
        [self.secondLabel setFont:VETX_FONT_BOLD_15];
        [self.secondLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    
    if (!self.arrowImage) {
        self.arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow_Thin"]];
        [self.contentView addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
}

@end
