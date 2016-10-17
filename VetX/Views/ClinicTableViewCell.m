//
//  ClinicTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 1/26/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ClinicTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface ClinicTableViewCell ()

@property (nonatomic, strong) UIImageView *clinicImageView;
@property (nonatomic, strong) UILabel *clinicNameLabel;
@property (nonatomic, strong) UILabel *clinicAddressLable;
@property (nonatomic, strong) UILabel *distanceLabel;

@end


@implementation ClinicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
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

- (void)setup {
    if (!self.clinicImageView) {
        self.clinicImageView = [[UIImageView alloc] init];
        [self.clinicImageView setImage:[UIImage imageNamed:@"Ambulance"]];
        [self addSubview:self.clinicImageView];
        [self.clinicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(self.mas_height);
            make.top.and.left.equalTo(self);
        }];
    }
    
    if (!self.clinicNameLabel) {
        self.clinicNameLabel = [[UILabel alloc] init];
        [self.clinicNameLabel setFont:VETX_FONT_BOLD_15];
        [self.clinicNameLabel setTextColor:GREY_COLOR];
        [self.clinicNameLabel setText:@"Bob's Vet Hospital"];
        [self.clinicNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.clinicNameLabel];
        [self.clinicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clinicImageView.mas_right).offset(10);
            make.bottom.equalTo(self.mas_centerY).offset(-15);
        }];
        
    }
    
    if (!self.clinicAddressLable) {
        self.clinicAddressLable = [[UILabel alloc] init];
        [self.clinicAddressLable setFont:VETX_FONT_MEDIUM_13];
        [self.clinicAddressLable setTextColor:LIGHT_GREY_COLOR];
        [self.clinicAddressLable setNumberOfLines:2];
        [self.clinicAddressLable setTextAlignment:NSTextAlignmentLeft];
        [self.clinicAddressLable setPreferredMaxLayoutWidth:200.0f];
        [self.clinicAddressLable setText:@"1234 Main Street, Boston, MA 02111"];
        [self addSubview:self.clinicAddressLable];
        [self.clinicAddressLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clinicNameLabel);
            make.centerY.equalTo(self.mas_centerY).offset(10);
        }];
    }
}

@end
