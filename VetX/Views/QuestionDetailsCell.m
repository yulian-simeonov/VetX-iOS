//
//  QuestionDetailsCell.m
//  VetX
//
//  Created by YulianMobile on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "QuestionDetailsCell.h"
#import "Masonry.h"
#import "Constants.h"
#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"

@interface QuestionDetailsCell ()

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *userProfileImage;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *questionDetails;
@property (nonatomic, strong) UILabel *petInfoLabel;
@property (nonatomic, strong) UILabel *petDetailsLabel;
@property (nonatomic, strong) UIImageView *petImage;

@property (nonatomic, strong) Question *question;

@end


@implementation QuestionDetailsCell

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

//- (void)prepareForReuse {
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:FEED_BACKGROUND_COLOR];
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    if (!self.cellBackgroundView) {
        self.cellBackgroundView = [[UIView alloc] init];
        [self.cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackgroundView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.cellBackgroundView.layer setShadowOpacity:0.15];
        [self.cellBackgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self.cellBackgroundView.layer setShadowRadius:2.0f];
        [self.cellBackgroundView setAccessibilityLabel:@"Feed Cell Background"];
        [self.contentView addSubview:self.cellBackgroundView];
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
        }];
    }
    
    
    if (!self.shareBtn) {
        self.shareBtn = [[UIButton alloc] init];
        UIImage *bookmark = [[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.shareBtn setImage:bookmark forState:UIControlStateNormal];
        [self.shareBtn setTintColor:GREY_COLOR];
        [self.shareBtn addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setAccessibilityLabel:@"Cell Bookmark Button"];
        [self.cellBackgroundView addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellBackgroundView).offset(10);
            make.right.equalTo(self.cellBackgroundView).offset(-10);
//            make.height.equalTo(@23.5);
            make.width.equalTo(@15);
            make.height.equalTo(self.shareBtn.mas_width).multipliedBy(23.5/15.0);
        }];
    }
    
    if (!self.userProfileImage) {
        self.userProfileImage = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
        [self.userProfileImage.layer setCornerRadius:20.0f];
        [self.userProfileImage setClipsToBounds:YES];
        [self.userProfileImage setImage:[UIImage imageNamed:@"DefaultPlaceHolder"] forState:UIControlStateNormal];
        [self.userProfileImage setAccessibilityLabel:@"Cell User Profile Image"];
        [self.cellBackgroundView addSubview:self.userProfileImage];
        [self.userProfileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@40);
            make.top.and.left.equalTo(self.cellBackgroundView).offset(10);
        }];
    }
    
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] init];
        [self.userNameLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.userNameLabel setFont:VETX_FONT_BOLD_15];
        [self.userNameLabel setText:@"Jesse J."];
        [self.userNameLabel setAccessibilityLabel:@"Cell Username Label"];
        [self.cellBackgroundView addSubview:self.userNameLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.userProfileImage.mas_centerY);
            make.left.equalTo(self.userProfileImage.mas_right).offset(10);
        }];
    }
    
    if (!self.categoryLabel) {
        self.categoryLabel = [[UILabel alloc] init];
        [self.categoryLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.categoryLabel setText:@"BEHAVIOR"];
        [self.categoryLabel setFont:VETX_FONT_MEDIUM_12];
        [self.categoryLabel setAccessibilityLabel:@"Cell Question Category Label"];
        [self.cellBackgroundView addSubview:self.categoryLabel];
        [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.top.equalTo(self.userProfileImage.mas_centerY);
        }];
    }
    
    if (!self.questionLabel) {
        self.questionLabel = [[UILabel alloc] init];
        [self.questionLabel setFont:VETX_FONT_BOLD_15];
        [self.questionLabel setTextAlignment:NSTextAlignmentLeft];
        [self.questionLabel setTextColor:FEED_CELL_TITLE_COLOR];
        [self.questionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.questionLabel setText:@"Why is my dog eating grass?"];
        [self.questionLabel setNumberOfLines:0];
        [self.questionLabel setAccessibilityLabel:@"Cell Question Label"];
        [self.cellBackgroundView addSubview:self.questionLabel];
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userProfileImage.mas_bottom).offset(5);
            make.left.equalTo(self.userProfileImage);
            make.height.lessThanOrEqualTo(@40);
            make.right.equalTo(self.cellBackgroundView).offset(-10);
            
        }];
    }
    
    if (!self.detailsLabel) {
        self.detailsLabel = [[UILabel alloc] init];
        [self.detailsLabel setFont:VETX_FONT_BOLD_13];
        [self.detailsLabel setText:@"Details:"];
        [self.detailsLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.cellBackgroundView addSubview:self.detailsLabel];
        [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.questionLabel);
            make.top.equalTo(self.questionLabel.mas_bottom).offset(10);
        }];
    }
    
    if (!self.questionDetails) {
        self.questionDetails = [[UILabel alloc] init];
        [self.questionDetails setNumberOfLines:0];
        [self.questionDetails setTextAlignment:NSTextAlignmentLeft];
        [self.questionDetails setLineBreakMode:NSLineBreakByWordWrapping];
        [self.questionDetails setFont:VETX_FONT_MEDIUM_13];
        [self.questionDetails setTextColor:GREY_COLOR];
        [self.cellBackgroundView addSubview:self.questionDetails];
        [self.questionDetails mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailsLabel.mas_bottom).offset(5);
            make.left.equalTo(self.userProfileImage);
            make.right.equalTo(self.cellBackgroundView.mas_right).offset(-10);
        }];
        
    }
    
    if (!self.petImage) {
        self.petImage = [[UIImageView alloc] init];
        [self.petImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.petImage setClipsToBounds:YES];
        [self.cellBackgroundView addSubview:self.petImage];
        [self.petImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.width.equalTo(self.cellBackgroundView);
            make.centerX.equalTo(self.cellBackgroundView);
            make.top.equalTo(self.questionDetails.mas_bottom).offset(5);
        }];
    }
    
    [self.cellBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.petImage.mas_bottom).offset(5);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.equalTo(@SCREEN_WIDTH);
        make.bottom.equalTo(self.cellBackgroundView).offset(5);
    }];

    [self layoutIfNeeded];
}

- (void)bindData:(Question *)question {
    self.question = question;
    NSString *secondaryLabel = [NSString stringWithFormat:@"%@ • %@", question.published.timeAgoSinceNow, question.category];
    [self.categoryLabel setText:secondaryLabel];
    [self.questionLabel setText:question.questionTitle];
    [self.questionDetails setText:question.questionDetails];
    [self.petImage setImageWithURL:[NSURL URLWithString:self.question.questionImage]];
    if ([question.questionDetails isEqualToString:@""] || !question.questionDetails) {
        [self.detailsLabel setHidden:YES];
    }
    User *user = question.user;
    [self.userNameLabel setText:user.firstName];
    [self.userProfileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
    if (self.question.questionImage && ![self.question.questionImage isEqualToString:@""]) {
        [self.petImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@150);
            make.width.equalTo(self.cellBackgroundView);
            make.centerX.equalTo(self.cellBackgroundView);
            make.top.equalTo(self.questionDetails.mas_bottom).offset(5);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)shareClicked {
    if ([self.delegate respondsToSelector:@selector(shareQuestion:)]) {
        [self.delegate performSelector:@selector(shareQuestion:) withObject:self.question];
    }
}

@end
