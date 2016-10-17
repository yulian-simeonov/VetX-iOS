//
//  HomePageView.m
//  VetX
//
//  Created by YulianMobile on 1/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "HomePageView.h"
#import "Constants.h"
#import "Masonry.h"
#import "PetCellLayout.h"
#import "PetCollectionViewCell.h"
#import "RoundedBtn.h"
#import "RemainingLabel.h"
#import "ConsultationTypeButton.h"

@interface HomePageView ()

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIImageView *petPhotoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *breedLabel;
@property (nonatomic, strong) UILabel *genderLabel;
@property (nonatomic, strong) UILabel *knownIssueLabel;
@property (nonatomic, strong) UILabel *petName;
@property (nonatomic, strong) UILabel *petAge;
@property (nonatomic, strong) UILabel *petBreed;
@property (nonatomic, strong) UILabel *petGender;
@property (nonatomic, strong) UILabel *petKnowIssues;
@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) RoundedBtn *editPet;
@property (nonatomic, strong) RoundedBtn *beginConsultation;
@property (nonatomic, strong) UIButton *addPet;
@property (nonatomic, strong) UILabel *selectPetLabel;
@property (nonatomic, strong) RemainingLabel *remaining;
@property (nonatomic, strong) ConsultationTypeButton *typePhone;
@property (nonatomic, strong) ConsultationTypeButton *typeSMS;
@property (nonatomic, strong) ConsultationTypeButton *typeVideo;

@end

@implementation HomePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    if (!self.selectLabel) {
        self.selectLabel = [[UILabel alloc] init];
        [self.selectLabel setTextAlignment:NSTextAlignmentCenter];
        [self.selectLabel setText:@"SELECT YOUR PET"];
        [self.selectLabel setTextColor:[UIColor blackColor]];
        [self.selectLabel setFont:VETX_FONT_MEDIUM_15];
        [self addSubview:self.selectLabel];
        [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self).offset(10);
        }];
    }

    if (!self.remaining) {
        self.remaining = [[RemainingLabel alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
        [self.remaining setRemainingText:@"0/2\nconsults\nremaining"];
        [self addSubview:self.remaining];
        [self.remaining mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@60);
            make.height.equalTo(@80);
            make.top.equalTo(self);
            make.right.equalTo(self).offset(-20);
        }];
    }
    
    if (!self.collectionView) {
        PetCellLayout *layout = [[PetCellLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) collectionViewLayout:layout];
        [self.collectionView registerClass:[PetCollectionViewCell class] forCellWithReuseIdentifier:@"PetCell"];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).multipliedBy(0.5);
            make.left.equalTo(self);
            make.top.equalTo(self.selectLabel.mas_bottom).offset(20);
            make.height.equalTo(@30);
        }];
    }
    
    if (!self.petPhotoView) {
        self.petPhotoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pet"]];
        [self.petPhotoView.layer setCornerRadius:60];
        [self.petPhotoView setClipsToBounds:YES];
        [self addSubview:self.petPhotoView];
        [self.petPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
            make.top.equalTo(self.collectionView.mas_bottom);
            make.width.and.height.equalTo(@120);
        }];
    }
    
    if (!self.nameLabel) {
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setText:@"Name"];
        [self.nameLabel setFont:VETX_FONT_MEDIUM_15];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView);
            make.left.equalTo(self.mas_centerX);
        }];
    }

    if (!self.petName) {
        self.petName = [[UILabel alloc] init];
        [self.petName setTextColor:GREY_COLOR];
        [self.petName setFont:VETX_FONT_BOLD_13];
        [self.petName setText:@"Boob"];
        [self.petName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.petName];
        [self.petName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.ageLabel) {
        self.ageLabel = [[UILabel alloc] init];
        [self.ageLabel setFont:VETX_FONT_MEDIUM_15];
        [self.ageLabel setTextColor:[UIColor blackColor]];
        [self.ageLabel setTextAlignment:NSTextAlignmentLeft];
        [self.ageLabel setText:@"Age"];
        [self addSubview:self.ageLabel];
        [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.petName.mas_bottom).offset(5);
        }];
    }
    
    if (!self.petAge) {
        self.petAge = [[UILabel alloc] init];
        [self.petAge setTextColor:GREY_COLOR];
        [self.petAge setFont:VETX_FONT_BOLD_13];
        [self.petAge setText:@"1 YEAR 5 MO"];
        [self.petAge setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.petAge];
        [self.petAge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.ageLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.breedLabel) {
        self.breedLabel = [[UILabel alloc] init];
        [self.breedLabel setFont:VETX_FONT_MEDIUM_15];
        [self.breedLabel setTextColor:[UIColor blackColor]];
        [self.breedLabel setTextAlignment:NSTextAlignmentLeft];
        [self.breedLabel setText:@"Breed"];
        [self addSubview:self.breedLabel];
        [self.breedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.petAge.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel);
        }];
    }
    
    if (!self.petBreed) {
        self.petBreed = [[UILabel alloc] init];
        [self.petBreed setFont:VETX_FONT_BOLD_13];
        [self.petBreed setTextColor:GREY_COLOR];
        [self.petBreed setTextAlignment:NSTextAlignmentLeft];
        [self.petBreed setText:@"Breed"];
        [self addSubview:self.petBreed];
        [self.petBreed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.breedLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel);
        }];
    }

    if (!self.genderLabel) {
        self.genderLabel = [[UILabel alloc] init];
        [self.genderLabel setFont:VETX_FONT_MEDIUM_15];
        [self.genderLabel setTextColor:[UIColor blackColor]];
        [self.genderLabel setTextAlignment:NSTextAlignmentLeft];
        [self.genderLabel setText:@"Gender"];
        [self addSubview:self.genderLabel];
        [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.petBreed.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel);
        }];
    }
    
    if (!self.petGender) {
        self.petGender = [[UILabel alloc] init];
        [self.petGender setFont:VETX_FONT_BOLD_13];
        [self.petGender setTextColor:GREY_COLOR];
        [self.petGender setTextAlignment:NSTextAlignmentLeft];
        [self.petGender setText:@"Gender"];
        [self addSubview:self.petGender];
        [self.petGender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.genderLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.knownIssueLabel) {
        self.knownIssueLabel = [[UILabel alloc] init];
        [self.knownIssueLabel setFont:VETX_FONT_MEDIUM_15];
        [self.knownIssueLabel setTextColor:[UIColor blackColor]];
        [self.knownIssueLabel setTextAlignment:NSTextAlignmentLeft];
        [self.knownIssueLabel setText:@"Know Issues"];
        [self addSubview:self.knownIssueLabel];
        [self.knownIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.petGender.mas_bottom).offset(5);
        }];
    }
    
    if (!self.petKnowIssues) {
        self.petKnowIssues = [[UILabel alloc] init];
        [self.petKnowIssues setFont:VETX_FONT_BOLD_13];
        [self.petKnowIssues setTextColor:GREY_COLOR];
        [self.petKnowIssues setTextAlignment:NSTextAlignmentLeft];
        [self.petKnowIssues setText:@"ASTHMA"];
        [self addSubview:self.petKnowIssues];
        [self.petKnowIssues mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.knownIssueLabel.mas_bottom).offset(5);
        }];
    }

    if (!self.editPet) {
        self.editPet = [[RoundedBtn alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        [self.editPet setTitle:@"Edit Pet" forState:UIControlStateNormal];
        [self.editPet setSelected:NO];
        [self addSubview:self.editPet];
        [self.editPet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.petPhotoView);
            make.top.equalTo(self.petPhotoView.mas_bottom).offset(10);
            make.width.equalTo(@90);
            make.height.equalTo(@30);
        }];
    }
    
    
    
    if (!self.addPet) {
        self.addPet = [[UIButton alloc] init];
        NSString *titleString = @"Add your pets information";
        NSDictionary *attributs = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                    NSForegroundColorAttributeName: GREY_COLOR,
                                    NSFontAttributeName:VETX_FONT_BOLD_15};
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:titleString attributes:attributs];
        [self.addPet.titleLabel setAttributedText:title];
        [self addSubview:self.addPet];
        [self.addPet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }

    if (!self.beginConsultation) {
        self.beginConsultation = [[RoundedBtn alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [self.beginConsultation setTitle:@"Begin Consultation" forState:UIControlStateNormal];
        [self.beginConsultation setSelected:YES];
        [self addSubview:self.beginConsultation];
        [self.beginConsultation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(self.mas_width).offset(-40);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.height.equalTo(@50);
        }];
    }
    
    if (!self.typePhone) {
        self.typePhone = [[ConsultationTypeButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        [self.typePhone setEnabled:NO];
        [self.typePhone setTitle:@"Phone" forState:UIControlStateNormal];
        [self.typePhone.titleLabel sizeToFit];
        [self.typePhone setImage:[UIImage imageNamed:@"Phone"] forState:UIControlStateNormal];
        [self addSubview:self.typePhone];
        [self.typePhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@80);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.beginConsultation.mas_top).offset(-20);
        }];
    }
    
    if (!self.typeSMS) {
        self.typeSMS = [[ConsultationTypeButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        [self.typeSMS setEnabled:YES];
        [self.typeSMS setTitle:@"Text" forState:UIControlStateNormal];
        [self.typeSMS.titleLabel sizeToFit];
        [self.typeSMS setImage:[[UIImage imageNamed:@"Chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self addSubview:self.typeSMS];
        [self.typeSMS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.typePhone);
            make.centerY.equalTo(self.typePhone.mas_centerY);
            make.right.equalTo(self.typePhone.mas_left).offset(-25);
        }];
    }
    
    
    if (!self.typeVideo) {
        self.typeVideo = [[ConsultationTypeButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        [self.typeVideo setEnabled:NO];
        [self.typeVideo setImage:[UIImage imageNamed:@"VideoCall"] forState:UIControlStateNormal];
        [self.typeVideo setTitle:@"Video\nChat" forState:UIControlStateNormal];
        [self.typeVideo.titleLabel sizeToFit];
        [self addSubview:self.typeVideo];
        [self.typeVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.typePhone);
            make.centerY.equalTo(self.typePhone.mas_centerY);
            make.left.equalTo(self.typePhone.mas_right).offset(25);
        }];
    }
    
    if (!self.methodLabel) {
        self.methodLabel = [[UILabel alloc] init];
        [self.methodLabel setFont:VETX_FONT_MEDIUM_15];
        [self.methodLabel setTextColor:[UIColor blackColor]];
        [self.methodLabel setNumberOfLines:0];
        [self.methodLabel setText:@"SELECT COMMUNICATION METHOD"];
        [self addSubview:self.methodLabel];
        [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.typePhone.mas_top).offset(-15);
        }];
    }
}

- (void)setPetProfileImage:(UIImage *)petImage {
    [self.petPhotoView setImage:petImage];
}

@end
