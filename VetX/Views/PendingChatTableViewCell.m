//
//  PendingChatTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 4/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "PendingChatTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "AnimatedGIFImageSerialization.h"
#import "UIImageView+AFNetworking.h"

@interface PendingChatTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIImageView *vetImageView;
@property (nonatomic, strong) UILabel *vetNameLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *divider1;
@property (nonatomic, strong) UILabel *divider2;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *loadingImage;
@property (nonatomic, strong) UILabel *loadingTitle;

@end


@implementation PendingChatTableViewCell

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

- (void)prepareForReuse {
   self.loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.gif"]];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    
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
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.and.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
        }];
    }
    
    if (!self.vetImageView) {
        self.vetImageView = [[UIImageView alloc] init];
        [self.vetImageView.layer setCornerRadius:20.0f];
        [self.vetImageView setClipsToBounds:YES];
        [self.vetImageView setImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
        [self.cellBackgroundView addSubview:self.vetImageView];
        [self.vetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@40);
            make.top.and.left.equalTo(self.cellBackgroundView).offset(10);
        }];
    }
    
    if (!self.vetNameLabel) {
        self.vetNameLabel = [[UILabel alloc] init];
        [self.vetNameLabel setFont:VETX_FONT_BOLD_20];
        [self.vetNameLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.vetNameLabel setText:@"Dr. Janet"];
        [self.cellBackgroundView addSubview:self.vetNameLabel];
        [self.vetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vetImageView.mas_right).offset(10);
            make.bottom.equalTo(self.vetImageView.mas_centerY);
        }];
    }
    
    if (!self.secondLabel) {
        self.secondLabel = [[UILabel alloc] init];
        [self.secondLabel setFont:VETX_FONT_MEDIUM_15];
        [self.secondLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.secondLabel setText:@"Veterinarian"];
        [self.cellBackgroundView addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vetNameLabel);
            make.top.equalTo(self.vetImageView.mas_centerY);
        }];
    }
    
    if (!self.arrowImageView) {
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow_Thin"]];
        [self.cellBackgroundView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.vetImageView);
            make.right.equalTo(self.cellBackgroundView.mas_right).offset(-20);
        }];
    }
    
    if (!self.divider1) {
        self.divider1 = [[UILabel alloc] init];
        [self.divider1 setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.cellBackgroundView addSubview:self.divider1];
        [self.divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.centerX.and.width.equalTo(self.cellBackgroundView);
            make.top.equalTo(self.vetImageView.mas_bottom).offset(10);
        }];
    }
    
    if (!self.endBtn) {
        self.endBtn = [[UIButton alloc] init];
        [self.endBtn setTitle:@"End" forState:UIControlStateNormal];
        [self.endBtn setTitleColor:FEED_CELL_NAME_COLOR forState:UIControlStateNormal];
        [self.endBtn.titleLabel setFont:VETX_FONT_MEDIUM_15];
        [self.endBtn addTarget:self action:@selector(clickEndBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.cellBackgroundView addSubview:self.endBtn];
        [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.equalTo(self.cellBackgroundView);
            make.top.equalTo(self.divider1.mas_bottom);
            make.width.equalTo(self.cellBackgroundView).multipliedBy(0.5).offset(-0.5);
        }];
    }
    
    if (!self.divider2) {
        self.divider2 = [[UILabel alloc] init];
        [self.divider2 setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.cellBackgroundView addSubview:self.divider2];
        [self.divider2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.equalTo(self.endBtn);
            make.bottom.equalTo(self.cellBackgroundView);
            make.left.equalTo(self.endBtn.mas_right);
        }];
    }
    
    if (!self.replyBtn) {
        self.replyBtn = [[UIButton alloc] init];
        [self.replyBtn setTitle:@"Reply" forState:UIControlStateNormal];
        [self.replyBtn setTitleColor:FEED_CELL_NAME_COLOR forState:UIControlStateNormal];
        [self.replyBtn.titleLabel setFont:VETX_FONT_MEDIUM_15];
        [self.replyBtn addTarget:self action:@selector(clickReplyBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.cellBackgroundView addSubview:self.replyBtn];
        [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cellBackgroundView);
            make.top.height.and.width.equalTo(self.endBtn);
        }];
    }
    
    if (!self.loadingView) {
        self.loadingView = [[UIView alloc] init];
        [self.loadingView setBackgroundColor:[UIColor whiteColor]];
        [self.loadingView setHidden:YES];
        [self.cellBackgroundView addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.cellBackgroundView);
        }];
    }
    
    if (!self.loadingImage) {
        self.loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.gif"]];
        [self.loadingView addSubview:self.loadingImage];
        [self.loadingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@40);
            make.centerX.equalTo(self.loadingView);
            make.centerY.equalTo(self.loadingView).offset(-10);
        }];
    }
    
    if (!self.loadingTitle) {
        self.loadingTitle = [[UILabel alloc] init];
        [self.loadingTitle setTextColor:ORANGE_THEME_COLOR];
        [self.loadingTitle setFont:VETX_FONT_BOLD_13];
        [self.loadingTitle setText:@"Connecting with a Vet..."];
        [self.loadingView addSubview:self.loadingTitle];
        [self.loadingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.loadingView);
            make.top.equalTo(self.loadingImage.mas_bottom).offset(10);
        }];
    }
}

- (void)bindData:(Consultation *)consultation indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    if (consultation.vet == nil) {
        [self.loadingView setHidden:NO];
        self.loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.gif"]];
    } else {
        [self.loadingView setHidden:YES];
        NSString *name = [NSString stringWithFormat:@"%@ %@", consultation.vet.firstName, consultation.vet.lastName];
        [self.vetImageView setImageWithURL:[NSURL URLWithString:consultation.vet.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
        [self.vetNameLabel setText:name];
        [self.secondLabel setText:consultation.vet.clinicID];
    }
}

- (void)bindWithUserData:(Consultation *)consultation indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    NSString *name = [NSString stringWithFormat:@"%@ %@", consultation.user.firstName, consultation.user.lastName];
    [self.vetImageView setImageWithURL:[NSURL URLWithString:consultation.user.profileURL] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
    [self.vetNameLabel setText:name];
    [self.secondLabel setHidden:YES];
}

- (void)finishedConsultation {
    [self.endBtn removeFromSuperview];
    [self.replyBtn removeFromSuperview];
    [self.divider2 removeFromSuperview];
}

- (void)clickEndBtn {
    if ([self.delegate respondsToSelector:@selector(didClickEndChatBtn:)]) {
        [self.delegate performSelector:@selector(didClickEndChatBtn:) withObject:self.indexPath];
    }
}

- (void)clickReplyBtn {
    if ([self.delegate respondsToSelector:@selector(didClickReplyBtn:)]) {
        [self.delegate performSelector:@selector(didClickReplyBtn:) withObject:self.indexPath];
    }
}

@end
