//
//  AnswerDetailsCell.m
//  VetX
//
//  Created by YulianMobile on 2/9/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AnswerDetailsCell.h"
#import "Masonry.h"
#import "Constants.h"
#import "User.h"
#import "UIButton+AFNetworking.h"

@interface AnswerDetailsCell ()

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UILabel *answerTitleLabel;
@property (nonatomic, strong) UILabel *answerDetailLabel;
@property (nonatomic, strong) UIButton *upVoteButton;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UIButton *vetProfileImage;
@property (nonatomic, strong) UILabel *vetNameLabel;
@property (nonatomic, strong) UILabel *vetProfileDesc;
@property (nonatomic, strong) UIButton *arrowBtn;

@end

@implementation AnswerDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    
    [self setBackgroundColor:FEED_BACKGROUND_COLOR];
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.cellBackgroundView) {
        self.cellBackgroundView = [[UIView alloc] init];
        [self.cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackgroundView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.cellBackgroundView.layer setShadowOpacity:0.15];
        [self.cellBackgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self.cellBackgroundView.layer setShadowRadius:2.0f];
        [self.cellBackgroundView setAccessibilityLabel:@"Answer Cell Background"];
        [self.contentView addSubview:self.cellBackgroundView];
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
        }];
    }
    
    if (!self.vetProfileImage) {
        self.vetProfileImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.vetProfileImage setClipsToBounds:YES];
        [self.vetProfileImage.layer setCornerRadius:20.0];
        [self.vetProfileImage setImage:[UIImage imageNamed:@"DefaultPlaceHolder"] forState:UIControlStateNormal];
        [self.vetProfileImage setAccessibilityLabel:@"Cell Vet Profile Image"];
        [self.cellBackgroundView addSubview:self.vetProfileImage];
        [self.vetProfileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@40);
            make.left.and.top.equalTo(self.cellBackgroundView).offset(20);
        }];
    }

    
    if (!self.vetNameLabel) {
        self.vetNameLabel = [[UILabel alloc] init];
        [self.vetNameLabel setText:@"Daniel Ferman"];
        [self.vetNameLabel setFont:VETX_FONT_BOLD_10];
        [self.vetNameLabel setTextColor:DARK_GREY_COLOR];
        [self.cellBackgroundView addSubview:self.vetNameLabel];
        [self.vetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vetProfileImage.mas_right).offset(5);
            make.bottom.equalTo(self.vetProfileImage.mas_centerY).offset(-1);
        }];
    }
    
    if (!self.vetProfileDesc) {
        self.vetProfileDesc = [[UILabel alloc] init];
        [self.vetProfileDesc setText:@"Rose Canyon Animal Hospital"];
        [self.vetProfileDesc setFont:VETX_FONT_BOLD_10];
        [self.vetProfileDesc setTextColor:DARK_GREY_COLOR];
        [self.cellBackgroundView addSubview:self.vetProfileDesc];
        [self.vetProfileDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vetNameLabel);
            make.top.equalTo(self.vetProfileImage.mas_centerY).offset(1);
        }];
    }
    
    if (!self.arrowBtn) {
        self.arrowBtn = [[UIButton alloc] init];
        [self.arrowBtn setImage:[UIImage imageNamed:@"Arrow_Thin"] forState:UIControlStateNormal];
        [self.cellBackgroundView addSubview:self.arrowBtn];
        [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.vetProfileImage);
            make.width.and.height.equalTo(@40);
            make.right.equalTo(self.cellBackgroundView);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:LIGHT_GREY_COLOR];
        [self.cellBackgroundView addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.top.equalTo(self.vetProfileImage.mas_bottom).offset(15);
            make.left.and.width.equalTo(self.cellBackgroundView);
        }];
    }
    
    if (!self.answerTitleLabel) {
        self.answerTitleLabel = [[UILabel alloc] init];
        [self.answerTitleLabel setFont:VETX_FONT_BOLD_13];
        [self.answerTitleLabel setText:@"ANSWER:"];
        [self.answerTitleLabel setTextColor:DARK_GREY_COLOR];
        [self.cellBackgroundView addSubview:self.answerTitleLabel];
        [self.answerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vetProfileImage);
            make.top.equalTo(self.divider.mas_bottom).offset(10);
        }];
    }
    
    if (!self.answerDetailLabel) {
        self.answerDetailLabel = [[UILabel alloc] init];
        [self.answerDetailLabel setFont:VETX_FONT_MEDIUM_13];
        [self.answerDetailLabel setTextColor:GREY_COLOR];
        [self.answerDetailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.answerDetailLabel setTextAlignment:NSTextAlignmentLeft];
        [self.answerDetailLabel setNumberOfLines:0];
        [self.answerDetailLabel setText:@""];
        [self.cellBackgroundView addSubview:self.answerDetailLabel];
        [self.answerDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.answerTitleLabel);
            make.top.equalTo(self.answerTitleLabel.mas_bottom).offset(10);
            make.right.equalTo(self.self.cellBackgroundView).offset(-10);
        }];
    }
    
    [self.cellBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.answerDetailLabel.mas_bottom).offset(5);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.equalTo(@SCREEN_WIDTH);
        make.bottom.equalTo(self.cellBackgroundView).offset(5);
    }];
    
    [self layoutIfNeeded];
}

- (void)bindData:(Answer *)answer {
    [self.answerDetailLabel setText:answer.answerDetail];
    User *vet = answer.answerVet;
    [self.vetProfileDesc setText:vet.clinicID];
    [self.vetNameLabel setText:[NSString stringWithFormat:@"%@ %@", vet.firstName, vet.lastName]];
    [self.vetProfileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vet.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
}

@end
