//
//  HomeFeedTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 1/25/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "HomeFeedTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "FeedCellVetLayout.h"
#import "VetFeedCellCollectionViewCell.h"
#import "User.h"
#import "Answer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface HomeFeedTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *userProfileImage;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *answerDetailLabel;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UIButton *vetProfileImage;
@property (nonatomic, strong) UILabel *topAnswerLabel;
@property (nonatomic, strong) UILabel *vetNameLabel;
@property (nonatomic, strong) UILabel *vetProfileDesc;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readMore;
@property (nonatomic, strong) UICollectionView *vetCollectionView;
@property (nonatomic, strong) UILabel *moreVetsLabel;

@property (nonatomic, strong) Question *question;

@end

@implementation HomeFeedTableViewCell

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
    
    if (!self.answerLabel) {
        self.answerLabel = [[UILabel alloc] init];
        [self.answerLabel setFont:VETX_FONT_MEDIUM_13];
        [self.answerLabel setText:@"Answer:"];
        [self.answerLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.cellBackgroundView addSubview:self.answerLabel];
        [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.questionLabel);
            make.top.equalTo(self.questionLabel.mas_bottom).offset(10);
        }];
    }
    
    if (!self.answerDetailLabel) {
        self.answerDetailLabel = [[UILabel alloc] init];
        [self.answerDetailLabel setNumberOfLines:3];
        [self.answerDetailLabel setTextAlignment:NSTextAlignmentLeft];
        [self.answerDetailLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.answerDetailLabel setFont:VETX_FONT_REGULAR_12];
        [self.answerDetailLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.answerDetailLabel setText:@""];
        [self.cellBackgroundView addSubview:self.answerDetailLabel];
        [self.answerDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.answerLabel.mas_bottom).offset(5);
            make.left.equalTo(self.answerLabel);
            make.right.equalTo(self.cellBackgroundView).offset(-15);
            make.height.lessThanOrEqualTo(@50);
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
            make.left.equalTo(self.userProfileImage);
            make.bottom.equalTo(self.cellBackgroundView.mas_bottom).offset(-10);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:LIGHT_GREY_COLOR];
        [self.cellBackgroundView addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1.5);
            make.bottom.equalTo(self.vetProfileImage.mas_top).offset(-10);
            make.left.and.width.equalTo(self.cellBackgroundView);
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
            make.bottom.equalTo(self.divider.mas_top).offset(-5);
        }];
    }
    
    if (!self.topAnswerLabel) {
        self.topAnswerLabel = [[UILabel alloc] init];
        [self.topAnswerLabel setText:@"Top Answer By:"];
        [self.topAnswerLabel setFont:VETX_FONT_MEDIUM_9];
        [self.topAnswerLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.cellBackgroundView addSubview:self.topAnswerLabel];
        [self.topAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.top.equalTo(self.vetProfileImage);
        }];
    }
    
    if (!self.vetNameLabel) {
        self.vetNameLabel = [[UILabel alloc] init];
        [self.vetNameLabel setText:@"Daniel Ferman"];
        [self.vetNameLabel setFont:VETX_FONT_BOLD_10];
        [self.vetNameLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.cellBackgroundView addSubview:self.vetNameLabel];
        [self.vetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topAnswerLabel);
            make.centerY.equalTo(self.vetProfileImage);
        }];
    }
    
    if (!self.vetProfileDesc) {
        self.vetProfileDesc = [[UILabel alloc] init];
        [self.vetProfileDesc setText:@"Rose Canyon Animal Hospital"];
        [self.vetProfileDesc setFont:VETX_FONT_BOLD_10];
        [self.vetProfileDesc setTextColor:FEED_CELL_NAME_COLOR];
        [self.cellBackgroundView addSubview:self.vetProfileDesc];
        [self.vetProfileDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vetNameLabel);
            make.bottom.equalTo(self.vetProfileImage);
        }];
    }
    
    if (!self.vetCollectionView) {
        FeedCellVetLayout *layout = [[FeedCellVetLayout alloc] init];
        self.vetCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 80, 40) collectionViewLayout:layout];
        self.vetCollectionView.dataSource = self;
        self.vetCollectionView.delegate = self;
        [self.vetCollectionView setBackgroundColor:[UIColor clearColor]];
        [self.vetCollectionView registerClass:[VetFeedCellCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.cellBackgroundView addSubview:self.vetCollectionView];
        [self.vetCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@80);
            make.top.equalTo(self.vetProfileImage);
            make.right.equalTo(self.cellBackgroundView.mas_right).offset(-15);
        }];
    }
    
    if (!self.moreVetsLabel) {
        self.moreVetsLabel = [[UILabel alloc] init];
        [self.moreVetsLabel setFont:VETX_FONT_MEDIUM_11];
        [self.moreVetsLabel setTextColor:GREY_COLOR];
        [self.cellBackgroundView addSubview:self.moreVetsLabel];
    }
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] init];
    }
    
}

- (void)bindQuestionData:(Question *)questionObj {
    NSString *secondaryLabel = [NSString stringWithFormat:@"%@ • %@", questionObj.published.timeAgoSinceNow, questionObj.category];
    [self.categoryLabel setText:secondaryLabel];
    [self.questionLabel setText:questionObj.questionTitle];
    self.question = questionObj;
    User *user = questionObj.user;
    Answer *topAnswer = [questionObj.answers firstObject];
    User *vet = topAnswer.answerVet;
    [self.userProfileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
    [self.vetNameLabel setText:[NSString stringWithFormat:@"%@ %@", vet.firstName, vet.lastName]];
    [self.answerDetailLabel setText:topAnswer.answerDetail];
    [self.vetProfileDesc setText:vet.clinicID];
    [self.userNameLabel setText:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]];
    
    [self.vetProfileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vet.profileURL]];
    
    NSInteger answersNumber = self.question.answers.count;
    if (answersNumber <= 1) {
        [self.moreVetsLabel setHidden:YES];
    } else {
        answersNumber -= 2;
        [self.moreVetsLabel setText:[NSString stringWithFormat:@"+%zd", answersNumber+1]];
        CGFloat left = answersNumber >= 0?45.0+answersNumber*20.0 : 40.0;
        [self.moreVetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.vetCollectionView);
            make.right.equalTo(self.vetCollectionView.mas_right).offset(-left);
        }];
        [self.cellBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.vetProfileImage.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            
        }];
        
    }
    
    [self layoutIfNeeded];
}


- (void)shareClicked {
    if ([self.delegate respondsToSelector:@selector(shareQuestion:)]) {
        [self.delegate performSelector:@selector(shareQuestion:) withObject:self.question];
    }
}


#pragma mark - UICollection View Delegate & Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.question.answers.count > 1 ? self.question.answers.count-1 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VetFeedCellCollectionViewCell *cell = (VetFeedCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[VetFeedCellCollectionViewCell alloc] init];
    }
    NSInteger rowIndex = indexPath.row+1;
    [cell.vetProfileImage setImageWithURL:[NSURL URLWithString:self.question.answers[rowIndex].answerVet.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
    return cell;
}



@end
