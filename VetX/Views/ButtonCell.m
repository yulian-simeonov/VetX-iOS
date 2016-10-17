//
//  ButonCell.m
//  VetX
//
//  Created by Mac on 10/08/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ButtonCell.h"
#import "Masonry.h"
#import "Constants.h"

@implementation ButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.leftButton) {
        self.leftButton = [[UIButton alloc] init];
        [self.leftButton.titleLabel setFont:VETX_FONT_MEDIUM_15];
        [self.leftButton setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).offset(8);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
    }
    
    if (!self.rightButton) {
        self.rightButton = [[UIButton alloc] init];
        [self.rightButton.titleLabel setFont:VETX_FONT_MEDIUM_15];
        [self.rightButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.greaterThanOrEqualTo(self.leftButton.mas_trailing).offset(8);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-8);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
    }
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
