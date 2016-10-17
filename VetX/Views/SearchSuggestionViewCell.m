//
//  SearchSuggestionViewCell.m
//  VetX
//
//  Created by Liam Dyer on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "SearchSuggestionViewCell.h"
#import "Masonry.h"
#import "Constants.h"

@interface SearchSuggestionViewCell ()

@property (nonatomic, strong) UILabel *questionLabel;

@end

@implementation SearchSuggestionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindQuestionData:(QuestionModel *)question {
    self.questionLabel.text = question.questionTitle;
}

- (void)setup {
    
    if (!self.questionLabel) {
        self.questionLabel = [[UILabel alloc] init];
        [self.questionLabel setFont:VETX_FONT_MEDIUM_15];
        [self.questionLabel setTextColor:GREY_COLOR];
        [self.contentView addSubview:self.questionLabel];
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    UIView *footerView = [[UILabel alloc] init];
    footerView.backgroundColor = GREY_COLOR;
    [self.contentView addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.width.equalTo(self.contentView.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

@end
