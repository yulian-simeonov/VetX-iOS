//
//  VetFeedTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 5/20/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VetFeedTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "User.h"
#import "Answer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface VetFeedTableViewCell () 

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIButton *userProfileImage;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *questionDetailLabel;
@property (nonatomic, strong) UILabel *readMore;
@property (nonatomic, strong) UIButton *answerButton;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) Question *question;

@end

@implementation VetFeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)prepareForReuse {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setup {
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
        [self.cellBackgroundView setAccessibilityLabel:@"Feed Cell Background"];
        [self.contentView addSubview:self.cellBackgroundView];
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(7);
            make.bottom.and.right.equalTo(self.contentView).offset(-7);
            make.top.equalTo(self.contentView);
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
            make.top.equalTo(self.cellBackgroundView).offset(10);
            make.left.equalTo(self.cellBackgroundView).offset(15);
        }];
    }
    
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] init];
        [self.userNameLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.userNameLabel setFont:VETX_FONT_MEDIUM_17];
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
        [self.categoryLabel setFont:VETX_FONT_REGULAR_11];
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
            make.top.equalTo(self.userProfileImage.mas_bottom).offset(10);
            make.left.equalTo(self.userProfileImage);
            make.height.lessThanOrEqualTo(@40);
            make.right.equalTo(self.cellBackgroundView).offset(-10);
            
        }];
    }
    
    if (!self.detailLabel) {
        self.detailLabel = [[UILabel alloc] init];
        [self.detailLabel setFont:VETX_FONT_MEDIUM_13];
        [self.detailLabel setText:@"Details:"];
        [self.detailLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.cellBackgroundView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.questionLabel);
            make.top.equalTo(self.questionLabel.mas_bottom).offset(10);
        }];
    }
    
    if (!self.questionDetailLabel) {
        self.questionDetailLabel = [[UILabel alloc] init];
        [self.questionDetailLabel setNumberOfLines:3];
        [self.questionDetailLabel setTextAlignment:NSTextAlignmentLeft];
        [self.questionDetailLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.questionDetailLabel setFont:VETX_FONT_REGULAR_12];
        [self.questionDetailLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.questionDetailLabel setText:@""];
        [self.cellBackgroundView addSubview:self.questionDetailLabel];
        [self.questionDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
            make.left.equalTo(self.detailLabel);
            make.right.equalTo(self.cellBackgroundView).offset(-15);
            make.height.lessThanOrEqualTo(@50);
        }];
    }
    
    if (!self.answerButton) {
        self.answerButton = [[UIButton alloc] init];
        [self.answerButton setBackgroundColor:ORANGE_THEME_COLOR];
        [self.answerButton setTitle:@"Answer" forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.answerButton.titleLabel setFont:VETX_FONT_MEDIUM_13];
        [self.answerButton addTarget:self action:@selector(clickAnswer) forControlEvents:UIControlEventTouchUpInside];
        [self.cellBackgroundView addSubview:self.answerButton];
        [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.cellBackgroundView);
            make.height.equalTo(@45);
        }];
    }
    
    if (!self.readMore) {
        self.readMore = [[UILabel alloc] init];
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Read More"];
        [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSForegroundColorAttributeName value:FEED_CELL_TITLE_COLOR range:NSMakeRange(0, commentString.length)];
        [commentString addAttribute:NSUnderlineColorAttributeName value:FEED_CELL_NAME_COLOR range:NSMakeRange(0, commentString.length)];
        [self.readMore setAttributedText:commentString];
        [self.readMore setFont:VETX_FONT_BOLD_11];
        [self.cellBackgroundView addSubview:self.readMore];
        [self.readMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cellBackgroundView).offset(-15);
            make.bottom.equalTo(self.answerButton.mas_top).offset(-10);
        }];
    }
    
}

- (void)bindQuestionData:(Question *)questionObj indexPath:(NSIndexPath *)indexPath {
    self.question = questionObj;
    NSString *secondaryLabel = [NSString stringWithFormat:@"%@ • %@", questionObj.published.timeAgoSinceNow, questionObj.category];
    [self.categoryLabel setText:secondaryLabel];
    [self.questionLabel setText:questionObj.questionTitle];
    User *user = questionObj.user;
    [self.userNameLabel setText:user.firstName];
    self.indexPath = indexPath;
}

- (void)clickAnswer {
    if ([self.delegate respondsToSelector:@selector(didClickAnswerButton:)]) {
        [self.delegate performSelector:@selector(didClickAnswerButton:) withObject:self.indexPath];
    }
}

@end
