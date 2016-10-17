//
//  VTXMedicalRecordTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 4/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXMedicalRecordTableViewCell.h"
#import "Masonry.h"
#import "Constants.h"
#import "VTXMedicalRecordItemView.h"
#import "UIImageView+AFNetworking.h"

@interface VTXMedicalRecordTableViewCell () <VTXMedicalRecordItemDelegate>

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) VTXMedicalRecordItemView *healthCertificateView;
@property (nonatomic, strong) VTXMedicalRecordItemView *vaccinationView;
@property (nonatomic, strong) VTXMedicalRecordItemView *laboratoryView;
@property (nonatomic, strong) VTXMedicalRecordItemView *patentView;
@property (nonatomic, strong) VTXMedicalRecordItemView *invoiceView;
@property (nonatomic, strong) VTXMedicalRecordItemView *othersView;

@end

@implementation VTXMedicalRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        [self.profileImage setImage:[UIImage imageNamed:@"Pet"]];
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
            make.height.equalTo(@30);
            make.top.equalTo(self.profileImage.mas_bottom).offset(5);
        }];
    }
    
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [self.cellBackgroundView addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.cellBackgroundView);
            make.height.equalTo(@1);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
    }
    
    if (!self.vaccinationView) {
        self.vaccinationView = [[VTXMedicalRecordItemView alloc] initWithItem:VaccinationRecord];
        self.vaccinationView.delegate = self;
        [self.cellBackgroundView addSubview:self.vaccinationView];
        [self.vaccinationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.divider.mas_bottom);
            make.centerX.equalTo(self.cellBackgroundView);
            make.height.equalTo(@40);
            make.width.equalTo(self.cellBackgroundView).offset(-20);
        }];
    }

    
    if (!self.laboratoryView) {
        self.laboratoryView = [[VTXMedicalRecordItemView alloc] initWithItem:LaboratoryResults];
        self.laboratoryView.delegate = self;
        [self.cellBackgroundView addSubview:self.laboratoryView];
        [self.laboratoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vaccinationView.mas_bottom);
            make.centerX.height.and.width.equalTo(self.vaccinationView);
        }];
    }
    
    if (!self.patentView) {
        self.patentView = [[VTXMedicalRecordItemView alloc] initWithItem:PatentChart];
        self.patentView.delegate = self;
        [self.patentView showViewBtn];
        [self.cellBackgroundView addSubview:self.patentView];
        [self.patentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.laboratoryView.mas_bottom);
            make.centerX.height.and.width.equalTo(self.vaccinationView);
        }];
    }
    
    if (!self.healthCertificateView) {
        self.healthCertificateView = [[VTXMedicalRecordItemView alloc] initWithItem:CertificateOfHealth];
        self.healthCertificateView.delegate = self;
        [self.cellBackgroundView addSubview:self.healthCertificateView];
        [self.healthCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.patentView.mas_bottom);
            make.centerX.height.and.width.equalTo(self.vaccinationView);
        }];
    }
    
    if (!self.invoiceView) {
        self.invoiceView = [[VTXMedicalRecordItemView alloc] initWithItem:InvoiceRecord];
        self.invoiceView.delegate = self;
        [self.cellBackgroundView addSubview:self.invoiceView];
        [self.invoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.healthCertificateView.mas_bottom);
            make.centerX.height.and.width.equalTo(self.vaccinationView);
        }];
    }
    
    if (!self.othersView) {
        self.othersView = [[VTXMedicalRecordItemView alloc] initWithItem:OtherRecord];
        self.othersView.delegate = self;
        [self.othersView showDivider:NO];
        [self.cellBackgroundView addSubview:self.othersView];
        [self.othersView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.invoiceView.mas_bottom);
            make.centerX.height.and.width.equalTo(self.vaccinationView);
        }];
    }
}

- (void)bindPetData:(Pet *)pet {
    if (pet) {
        [self.profileImage setImageWithURL:[NSURL URLWithString:pet.imageURL] placeholderImage:[UIImage imageNamed:@"Pet_Placeholder"]];
        [self.nameLabel setText:pet.name];
        if (pet.certificateOfHealth.count == 0) {
            [self.healthCertificateView showAddBtn];
        } else {
            [self.healthCertificateView showViewBtn];
        }
        
        if (pet.vaccinationRecord.count == 0) {
            [self.vaccinationView showAddBtn];
        } else {
            [self.vaccinationView showViewBtn];
        }
        
        if (pet.laboratoryResults.count == 0) {
            [self.laboratoryView showAddBtn];
        } else {
            [self.laboratoryView showViewBtn];
        }
        
        if (pet.patientChart.count == 0) {
            [self.patentView showAddBtn];
        } else {
            [self.patentView showViewBtn];
        }
        
        if (pet.invoiceRecord.count == 0) {
            [self.invoiceView showAddBtn];
        } else {
            [self.invoiceView showViewBtn];
        }
        
        if (pet.other.count == 0) {
            [self.othersView showAddBtn];
        } else {
            [self.othersView showViewBtn];
        }
    }
}

#pragma mark - VTXMedicalRecordItem 

- (void)addRecord:(NSNumber *)item {
    if ([self.delegate respondsToSelector:@selector(addRecord:indexPath:)]) {
        [self.delegate performSelector:@selector(addRecord:indexPath:) withObject:item withObject:self.indexPath];
    }
}

- (void)shareRecord:(NSNumber *)item {
    if ([self.delegate respondsToSelector:@selector(shareRecord:indexPath:)]) {
        [self.delegate performSelector:@selector(shareRecord:indexPath:) withObject:item withObject:self.indexPath];
    }
}

- (void)editRecord:(NSNumber *)item {
    if ([self.delegate respondsToSelector:@selector(editRecord:indexPath:)]) {
        [self.delegate performSelector:@selector(editRecord:indexPath:) withObject:item withObject:self.indexPath];
    }
}

- (void)viewRecord:(NSNumber *)item {
    NSLog(@"view record in cell");
    if ([self.delegate respondsToSelector:@selector(viewRecord:indexPath:)]) {
        [self.delegate performSelector:@selector(viewRecord:indexPath:) withObject:item withObject:self.indexPath];
    }
}

@end
