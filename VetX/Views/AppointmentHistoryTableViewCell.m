//
//  AppointmentHistoryTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 2/18/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AppointmentHistoryTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface AppointmentHistoryTableViewCell ()

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIImageView *petProfileImage;
@property (nonatomic, strong) UILabel *petNameLabel;
@property (nonatomic, strong) UILabel *dateTimeLabel;
@property (nonatomic, strong) UILabel *clinicNameLabel;

@end

@implementation AppointmentHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
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

- (void)setupView {
    
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    if (!self.cellBackgroundView) {
        self.cellBackgroundView = [[UIView alloc] init];
        [self.cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackgroundView.layer setShadowColor:FEED_CELL_SHADOW.CGColor];
        [self.cellBackgroundView.layer setShadowOpacity:1.0];
        [self.cellBackgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self.cellBackgroundView.layer setShadowRadius:5.0f];
        [self.cellBackgroundView setAccessibilityLabel:@"Appointment History Cell Background"];
        [self.contentView addSubview:self.cellBackgroundView];
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    
    
    if (!self.petProfileImage) {
        self.petProfileImage = [[UIImageView alloc] init];
        [self.petProfileImage setClipsToBounds:YES];
        [self.petProfileImage.layer setCornerRadius:35.0f];
        [self.petProfileImage setImage:[UIImage imageNamed:@"Pet"]];
        [self.cellBackgroundView addSubview:self.petProfileImage];
        [self.petProfileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.equalTo(self.cellBackgroundView).offset(15);
            make.width.and.height.equalTo(@70);
        }];
    }
    
    if (!self.dateTimeLabel) {
        self.dateTimeLabel = [[UILabel alloc] init];
        [self.dateTimeLabel setText:@"March 23, 2016"];
        [self.dateTimeLabel setFont:VETX_FONT_BOLD_13];
        [self.dateTimeLabel setTextColor:GREY_COLOR];
        [self.cellBackgroundView addSubview:self.dateTimeLabel];
        [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.petProfileImage);
            make.left.equalTo(self.petProfileImage.mas_right).offset(10);
        }];
    }
    
    if (!self.petNameLabel) {
        self.petNameLabel = [[UILabel alloc] init];
        [self.petNameLabel setFont:VETX_FONT_BOLD_15];
        [self.petNameLabel setTextColor:GREY_COLOR];
        [self.petNameLabel setText:@"Thatcher"];
        [self.cellBackgroundView addSubview:self.petNameLabel];
        [self.petNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateTimeLabel);
            make.bottom.equalTo(self.dateTimeLabel.mas_top).offset(-5);
        }];
    }
    
    if (!self.clinicNameLabel) {
        self.clinicNameLabel = [[UILabel alloc] init];
        [self.clinicNameLabel setFont:VETX_FONT_MEDIUM_13];
        [self.clinicNameLabel setTextColor:GREY_COLOR];
        [self.clinicNameLabel setText:@"Porter Square Vet"];
        [self.cellBackgroundView addSubview:self.clinicNameLabel];
        [self.clinicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateTimeLabel);
            make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(5);
        }];
    }
}

@end
