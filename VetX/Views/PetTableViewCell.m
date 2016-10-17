//
//  PetTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 3/14/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "PetTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "VTXViewWithDivider.h"
#import "UIImageView+AFNetworking.h"

@interface PetTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *editPetBtn;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) VTXViewWithDivider *typeView;
@property (nonatomic, strong) VTXViewWithDivider *breedView;
@property (nonatomic, strong) VTXViewWithDivider *birthdayView;
@property (nonatomic, strong) VTXViewWithDivider *sexView;
//@property (nonatomic, strong) UILabel *detailLabel;

@end


@implementation PetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (!self.cellBackgroundView) {
        self.cellBackgroundView = [[UIView alloc] init];
        [self.cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackgroundView.layer setShadowColor:FEED_CELL_SHADOW.CGColor];
        [self.cellBackgroundView.layer setShadowOpacity:1.0];
        [self.cellBackgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self.cellBackgroundView.layer setShadowRadius:5.0f];
        [self.cellBackgroundView setAccessibilityLabel:@"Pet Cell Background"];
        [self.contentView addSubview:self.cellBackgroundView];
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.and.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
        }];
    }
    
    if (!self.profileImage) {
        self.profileImage = [[UIImageView alloc] init];
        [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.profileImage setClipsToBounds:YES];
        [self.profileImage setImage:[UIImage imageNamed:@"Pet_Placeholder"]];
        [self.cellBackgroundView addSubview:self.profileImage];
        [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.width.equalTo(self.cellBackgroundView);
            make.height.equalTo(@120);
        }];
    }
    
    if (!self.nameLabel) {
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setFont:VETX_FONT_BOLD_20];
        [self.nameLabel setTextColor:MEDICAL_PET_NAME_COLOR];
        [self.nameLabel setText:@"Name"];
        [self.cellBackgroundView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.cellBackgroundView);
            make.top.equalTo(self.profileImage.mas_bottom).offset(15);
        }];
    }

    if (!self.editPetBtn) {
        self.editPetBtn = [[UIButton alloc] init];
        [self.editPetBtn setTitle:@"edit pet" forState:UIControlStateNormal];
        [self.editPetBtn.titleLabel setFont:VETX_FONT_MEDIUM_11];
        [self.editPetBtn setTitleColor:DARK_GREY_COLOR forState:UIControlStateNormal];
        [self.editPetBtn setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [self.editPetBtn.layer setCornerRadius:2.0f];
        [self.editPetBtn addTarget:self action:@selector(editPetProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellBackgroundView     addSubview:self.editPetBtn];
        [self.editPetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_baseline).offset(5);
            make.centerX.equalTo(self.nameLabel);
            make.height.equalTo(@24);
            make.width.equalTo(@60);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [self.cellBackgroundView addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.cellBackgroundView);
            make.height.equalTo(@1);
            make.top.equalTo(self.editPetBtn.mas_bottom).offset(15);
        }];
    }

    if (!self.typeView) {
        self.typeView = [[VTXViewWithDivider alloc] init];
        [self addSubview:self.typeView];
        [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.top.equalTo(self.divider.mas_bottom);
            make.centerX.equalTo(self);
            make.width.equalTo(self).offset(-40);
        }];
    }
    
    if (!self.breedView) {
        self.breedView = [[VTXViewWithDivider alloc] init];
        [self addSubview:self.breedView];
        [self.breedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerX.and.width.equalTo(self.typeView);
            make.top.equalTo(self.typeView.mas_bottom);
        }];
    }
    
    if (!self.birthdayView) {
        self.birthdayView = [[VTXViewWithDivider alloc] init];
        [self addSubview:self.birthdayView];
        [self.birthdayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerX.and.width.equalTo(self.typeView);
            make.top.equalTo(self.breedView.mas_bottom);
        }];
    }
    
    if (!self.sexView) {
        self.sexView = [[VTXViewWithDivider alloc] init];
        [self.sexView showDivider:NO];
        [self addSubview:self.sexView];
        [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerX.and.width.equalTo(self.typeView);
            make.top.equalTo(self.birthdayView.mas_bottom);
        }];
    }
}

- (void)bindData:(Pet *)petData indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    NSString *breed = petData.breed;
    NSString *sexString = @"";
    [self.profileImage  setImageWithURL:[NSURL URLWithString:petData.imageURL] placeholderImage:[UIImage imageNamed:@"Pet_Placeholder"]];
    switch ([petData getSexType]) {
        case FemaleSpayed:
            sexString = @"Female Spayed";
            break;
        case FemaleNotSpayed:
            sexString = @"Female Not Spayed";
            break;
        case MaleNeutered:
            sexString = @"Male Neutered";
            break;
        case MaleNotNeutered:
            sexString = @"Male Not Neutered";
            break;
        default:
            break;
    }
    
    [self.typeView setLeftLabel:@"Type" rightLabel:petData.type];
    [self.breedView setLeftLabel:@"Breed" rightLabel:breed];
    [self.birthdayView setLeftLabel:@"Birthday" rightLabel:[petData getPetBirthday]];
    [self.sexView setLeftLabel:@"Sex" rightLabel:sexString];
    
    [self.nameLabel setText:petData.name];
//    [self.detailLabel setText:details];
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)editPetProfileClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickEditBtn:)]) {
        [self.delegate performSelector:@selector(didClickEditBtn:) withObject:self.indexPath];
    }
}

@end
