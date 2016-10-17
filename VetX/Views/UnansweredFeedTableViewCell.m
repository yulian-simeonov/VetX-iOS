//
//  UnansweredFeedTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 3/15/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "UnansweredFeedTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "FeedCellVetLayout.h"
#import "VetFeedCellCollectionViewCell.h"
#import "User.h"
#import "QuestionRequestModel.h"
#import "QuestionManager.h"
#import "NSDate+DateTools.h"


static NSString *placeholder = @"Please input your answer here...";

@interface UnansweredFeedTableViewCell () <UITextViewDelegate>

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *userProfileImage;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *answerBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) Question *question;

@end

@implementation UnansweredFeedTableViewCell

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
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.cellBackgroundView) {
        self.cellBackgroundView = [[UIView alloc] init];
        [self.cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackgroundView.layer setShadowColor:FEED_CELL_SHADOW.CGColor];
        [self.cellBackgroundView.layer setShadowOpacity:1.0];
        [self.cellBackgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self.cellBackgroundView.layer setShadowRadius:5.0f];
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
    
    if (!self.shareBtn) {
        self.shareBtn = [[UIButton alloc] init];
        UIImage *bookmark = [[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.shareBtn setImage:bookmark forState:UIControlStateNormal];
        [self.shareBtn setTintColor:GREY_COLOR];
        [self.shareBtn addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setAccessibilityLabel:@"Cell Bookmark Button"];
        [self.cellBackgroundView addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userProfileImage);
            make.right.equalTo(self.cellBackgroundView).offset(-15);
            make.height.equalTo(@23.5);
            make.width.equalTo(@15);
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
    
    if (!self.answerField) {
        self.answerField = [[UITextView alloc] init];
        [self.answerField setText:placeholder];
        self.answerField.delegate = self;
        [self.answerField.layer setBorderWidth:1.0];
        [self.answerField.layer setBorderColor:GREY_COLOR.CGColor];
        [self.answerField.layer setCornerRadius:5.0];
        [self.answerField setClipsToBounds:YES];
        [self.answerField setTextColor:GREY_COLOR];
        [self.answerField setFont:VETX_FONT_MEDIUM_15];
        [self.answerField setDataDetectorTypes:UIDataDetectorTypeAll];
        [self.cellBackgroundView addSubview:self.answerField];
        [self.answerField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellBackgroundView).offset(10);
            make.right.equalTo(self.cellBackgroundView).offset(-10);
            make.top.equalTo(self.questionLabel.mas_bottom).offset(20);
            make.height.equalTo(@1);
        }];
    }

    if (!self.answerBtn) {
        self.answerBtn = [[UIButton alloc] init];
        [self.answerBtn setBackgroundColor:GREY_COLOR];
        [self.answerBtn setTitle:@"Answer" forState:UIControlStateNormal];
        [self.answerBtn addTarget:self action:@selector(answerQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self.cellBackgroundView addSubview:self.answerBtn];
        [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellBackgroundView).offset(10);
            make.right.equalTo(self.cellBackgroundView).offset(-10);
            make.top.equalTo(self.answerField.mas_bottom).offset(10);
        }];
        
        [self.cellBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.answerBtn.mas_bottom).offset(10);
            make.bottom.and.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
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

- (void)setSelectedCell:(BOOL)isSelected {
    if (isSelected) {
        [self.answerField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@80);
        }];
        [self.cellBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.answerBtn.mas_bottom).offset(10);
            make.bottom.and.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
        }];
    } else {
        [self.answerField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
        [self.cellBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.answerBtn.mas_bottom).offset(10);
            make.bottom.and.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
        }];
    }
}


- (void)answerQuestion {
    
    NSString *answerStr = [self.answerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![answerStr isEqualToString:@""] && ![answerStr isEqualToString:placeholder]) {
        // if answer is not empty, send request to server
        QuestionRequestModel *request = [[QuestionRequestModel alloc] init];
        request.answer = answerStr;
        [[QuestionManager defaultManager] answerQuestion:self.question.questionID answer:request complete:^(BOOL finished, NSError *error) {
            
        }];
    }
    [self.answerField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(clickAnswerBtn:answer:)]) {
        if ([answerStr isEqualToString:@""] || [answerStr isEqualToString:placeholder]) {
            [self.delegate performSelector:@selector(clickAnswerBtn:answer:) withObject:self.indexPath withObject:@""];
        } else {
            [self.delegate performSelector:@selector(clickAnswerBtn:answer:) withObject:nil withObject:answerStr];
            // After this, reset text view
            self.answerField.text = placeholder;
        }
    }
}

- (void)shareClicked {
    if ([self.delegate respondsToSelector:@selector(shareQuestion:)]) {
        [self.delegate performSelector:@selector(shareQuestion:) withObject:self.question];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeholder]) {
        textView.text = @"";
        textView.textColor = DARK_GREY_COLOR; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeholder;
        textView.textColor = GREY_COLOR; //optional
    }
    [textView resignFirstResponder];
}

@end
