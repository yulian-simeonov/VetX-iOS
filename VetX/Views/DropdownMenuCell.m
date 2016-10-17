//
//  DropdownMenuCell.m
//  VetX
//
//  Created by YulianMobile on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "DropdownMenuCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface DropdownMenuCell ()

@property (nonatomic, strong) UILabel *divider;

@end

@implementation DropdownMenuCell

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

- (void)prepareForReuse {
    [self.iconView setImage:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.itemLabel setFont:VETX_FONT_BOLD_15];
        [self.iconView setImage:[UIImage imageNamed:@"CheckMark"]];
    } else {
        [self.itemLabel setFont:VETX_FONT_REGULAR_15];
        [self.iconView setImage:nil];
    }

    // Configure the view for the selected state
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.itemLabel) {
        self.itemLabel = [[UILabel alloc] init];
        [self.itemLabel setFont:VETX_FONT_MEDIUM_15];
        [self.itemLabel setTextColor:BLACK_SEARCH_MENU_FONT];
        [self.itemLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(20);
        }];
    }
    
    if (!self.iconView) {
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.height.and.width.equalTo(@24);
            make.centerY.equalTo(self.contentView);
        }];
    }
    
//    if (!self.divider) {
//        self.divider = [[UILabel alloc] init];
//        [self.divider setBackgroundColor:GREY_COLOR];
//        [self.contentView addSubview:self.divider];
//        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.and.right.equalTo(self.contentView);
//            make.height.equalTo(@SINGLE_LINE_WIDTH);
//        }];
//    }
}

@end
