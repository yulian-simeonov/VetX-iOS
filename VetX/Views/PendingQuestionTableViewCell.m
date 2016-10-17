//
//  PendingQuestionTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 4/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "PendingQuestionTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "Question.h"

@interface PendingQuestionTableViewCell ()

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *pendingLabel;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UIButton *readmoreBtn;

@end

@implementation PendingQuestionTableViewCell

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
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    
    if (!self.cellBackgroundView) {
        self.cellBackgroundView = [[UIView alloc] init];
        [self.cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackgroundView.layer setShadowColor:FEED_CELL_SHADOW.CGColor];
        [self.cellBackgroundView.layer setShadowOpacity:1.0];
        [self.cellBackgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self.cellBackgroundView.layer setShadowRadius:5.0f];
        [self.cellBackgroundView setAccessibilityLabel:@"Pending Question Cell Background"];
        [self.contentView addSubview:self.cellBackgroundView];
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.and.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
        }];
    }
    
    if (!self.questionTitleLabel) {
        self.questionTitleLabel = [[UILabel alloc] init];
        [self.questionTitleLabel setFont:VETX_FONT_BOLD_15];
        [self.questionTitleLabel setTextColor:FEED_CELL_TITLE_COLOR];
        [self.questionTitleLabel setNumberOfLines:0];
        [self.questionTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.cellBackgroundView addSubview:self.questionTitleLabel];
        [self.questionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.equalTo(self.cellBackgroundView).offset(10);
            make.right.equalTo(self.cellBackgroundView.mas_right).offset(-10);
            make.height.lessThanOrEqualTo(@58);
        }];
    }
    
    if (!self.secondLabel) {
        self.secondLabel = [[UILabel alloc] init];
        [self.secondLabel setNumberOfLines:1];
        [self.secondLabel setFont:VETX_FONT_MEDIUM_12];
        [self.secondLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.secondLabel setText:@"4m ago • Behavior"];
        [self.secondLabel setTextAlignment:NSTextAlignmentLeft];
        [self.cellBackgroundView addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.questionTitleLabel.mas_bottom);
            make.left.equalTo(self.questionTitleLabel);
        }];
    }
    
    if (!self.pendingLabel) {
        self.pendingLabel = [[UILabel alloc] init];
        [self.pendingLabel setText:@"Answer Pending"];
        [self.pendingLabel setTextColor:FEED_CELL_NAME_COLOR];
        [self.pendingLabel setFont:VETX_FONT_BOLD_13];
        [self.pendingLabel setTextAlignment:NSTextAlignmentLeft];
        [self.cellBackgroundView addSubview:self.pendingLabel];
        [self.pendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.questionTitleLabel);
            make.top.equalTo(self.secondLabel.mas_bottom);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.cellBackgroundView addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.centerX.and.width.equalTo(self.cellBackgroundView);
            make.top.equalTo(self.pendingLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.readmoreBtn) {
        self.readmoreBtn = [[UIButton alloc] init];
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Read More"];
        [commentString addAttribute:NSFontAttributeName value:VETX_FONT_MEDIUM_13 range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSUnderlineColorAttributeName value:FEED_CELL_NAME_COLOR range:NSMakeRange(0, commentString.length)];
        [self.readmoreBtn setAttributedTitle:commentString forState:UIControlStateNormal];
        [self.cellBackgroundView addSubview:self.readmoreBtn];
        [self.readmoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.divider.mas_bottom);
            make.bottom.left.and.right.equalTo(self.cellBackgroundView);
        }];
    }
}

- (void)bindData:(NSDictionary *)questionObj {
    Question *question = (Question *)questionObj;
    [self.questionTitleLabel setText:question.questionTitle];
    [self.secondLabel setText:question.category];
}

@end
