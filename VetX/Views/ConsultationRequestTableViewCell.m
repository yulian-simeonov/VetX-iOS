//
//  ConsultationRequestTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 5/21/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ConsultationRequestTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface ConsultationRequestTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *questionTitle;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UIImageView *consultationTypeImage;

@end

@implementation ConsultationRequestTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.profileImageView) {
        self.profileImageView = [[UIImageView alloc] init];
        [self.profileImageView.layer setCornerRadius:30.0f];
        [self.profileImageView setClipsToBounds:YES];
        [self.profileImageView setImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
        [self.contentView addSubview:self.profileImageView];
        [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@60);
            make.top.and.left.equalTo(self.contentView).offset(10);
        }];
    }
    
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] init];
        [self.userNameLabel setFont:VETX_FONT_REGULAR_15];
        [self.userNameLabel setTextColor:FEED_CELL_TITLE_COLOR];
        [self.userNameLabel setText:@"Dr. Janet"];
        [self.contentView addSubview:self.userNameLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileImageView.mas_right).offset(10);
            make.bottom.equalTo(self.profileImageView.mas_centerY);
        }];
    }
    
    if (!self.questionTitle) {
        self.questionTitle = [[UILabel alloc] init];
        [self.questionTitle setFont:VETX_FONT_REGULAR_12];
        [self.questionTitle setTextColor:FEED_CELL_TITLE_COLOR];
        [self.contentView addSubview:self.questionTitle];
        [self.questionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.top.equalTo(self.contentView.mas_centerY);
        }];
    }
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setFont:VETX_FONT_LIGHT_14];
        [self.timeLabel setTextColor:GREY_COLOR];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.profileImageView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    
    if (!self.consultationTypeImage) {
        self.consultationTypeImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.consultationTypeImage];
        [self.consultationTypeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userNameLabel);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.contentView addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
}

- (void)bindWithUserData:(Consultation *)consultation indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    NSString *name = [NSString stringWithFormat:@"%@ %@", consultation.user.firstName, consultation.user.lastName];
    [self.timeLabel setText:consultation.created.timeAgoSinceNow];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:consultation.user.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
    [self.userNameLabel setText:name];
    [self.questionTitle setText:consultation.consultationTitle];
    
    if ([consultation.type isEqualToString:@"text"]) {
        [self.consultationTypeImage setImage:[UIImage imageNamed:@"chat_small"]];
    } else {
        [self.consultationTypeImage setImage:[UIImage imageNamed:@"video_small"]];
    }
}

@end
