//
//  VTXMedicalRecordItemView.m
//  VetX
//
//  Created by YulianMobile on 4/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXMedicalRecordItemView.h"
#import "Masonry.h"
#import "Constants.h"

@interface VTXMedicalRecordItemView ()

@property (nonatomic, strong) UILabel *divider;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *viewButton;

@property (nonatomic, assign) MedicalRecordItem item;

@end

@implementation VTXMedicalRecordItemView

- (instancetype)initWithItem:(MedicalRecordItem)item {
    self = [super init];
    if (self) {
        self.item = item;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [self addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.bottom.left.and.right.equalTo(self);
        }];
    }
    
    if (!self.leftLabel) {
        self.leftLabel = [[UILabel alloc] init];
        [self.leftLabel setFont:VETX_FONT_MEDIUM_15];
        [self.leftLabel setTextColor:MEDICAL_RECOR_COLOR];
        [self setLabelText];
        [self.leftLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.centerY.equalTo(self);
        }];
    }
    
    [self showDivider:YES];
    
    if (!self.addButton) {
        self.addButton = [[UIButton alloc] init];
        [self.addButton.layer setBorderColor:ORANGE_THEME_COLOR.CGColor];
        [self.addButton.layer setBorderWidth:1.0f];
        [self.addButton.layer setCornerRadius:10.0f];
        [self.addButton setClipsToBounds:YES];
        [self.addButton.titleLabel setFont:VETX_FONT_BOLD_13];
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        [self.addButton setTitleColor:ORANGE_THEME_COLOR forState:UIControlStateNormal];
        [self.addButton addTarget:self
                              action:@selector(didClickAddBtn)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-5);
            make.height.and.width.equalTo(@20);
        }];
    }

    
    if (!self.deleteButton) {
        self.deleteButton = [[UIButton alloc] init];
        [self.deleteButton setBackgroundColor:ORANGE_THEME_COLOR];
        [self.deleteButton setClipsToBounds:YES];
        [self.deleteButton.layer setCornerRadius:1.0];
        [self.deleteButton.titleLabel setFont:VETX_FONT_REGULAR_11];
        [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [self.deleteButton addTarget:self
                             action:@selector(didClickDeleteBtn)
                   forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.height.equalTo(@20);
            make.width.equalTo(@40);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    if (!self.shareButton) {
        self.shareButton = [[UIButton alloc] init];
        [self.shareButton setBackgroundColor:ORANGE_THEME_COLOR];
        [self.shareButton setTintColor:[UIColor whiteColor]];
        [self.shareButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.shareButton setImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.shareButton addTarget:self
                            action:@selector(didClickShareBtn)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.centerY.equalTo(self.deleteButton);
            make.width.equalTo(@20);
            make.right.equalTo(self.deleteButton.mas_left).offset(-5);
        }];
    }
    
    
    if (!self.viewButton) {
        self.viewButton = [[UIButton alloc] init];
        [self.viewButton setBackgroundColor:ORANGE_THEME_COLOR];
        [self.viewButton setClipsToBounds:YES];
        [self.viewButton.layer setCornerRadius:1.0];
        [self.viewButton.titleLabel setFont:VETX_FONT_REGULAR_11];
        [self.viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.viewButton setTitle:@"View" forState:UIControlStateNormal];
        [self.viewButton addTarget:self
                            action:@selector(didClickViewBtn)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.viewButton];
        [self.viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.and.centerY.equalTo(self.deleteButton);
            make.right.equalTo(self.shareButton.mas_left).offset(-5);
        }];
    }
    
    [self showAddBtn];
}

- (void)setLabelText {
    switch (self.item) {
        case CertificateOfHealth:
            [self.leftLabel setText:@"Certificate of Health:"];
            break;
        case VaccinationRecord:
            [self.leftLabel setText:@"Vaccinations:"];
            break;
        case LaboratoryResults:
            [self.leftLabel setText:@"Lab and Imaging:"];
            break;
        case PatentChart:
            [self.leftLabel setText:@"Prescriptions:"];
            break;
        case InvoiceRecord:
            [self.leftLabel setText:@"Invoices:"];
            break;
        case OtherRecord:
            [self.leftLabel setText:@"Other Records:"];
            break;
        default:
            [self.leftLabel setText:@"Other Records:"];
            break;
    }
}

- (void)showDivider:(BOOL)show {
    if (show) {
        [self.divider setHidden:NO];
    } else {
        [self.divider setHidden:YES];
    }
}

- (void)showAddBtn {
    [self.addButton setHidden:NO];
    [self.shareButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.viewButton setHidden:YES];
}

- (void)showViewBtn {
    [self.addButton setHidden:YES];
    [self.shareButton setHidden:NO];
    [self.deleteButton setHidden:NO];
    [self.viewButton setHidden:NO];
}

- (void)didClickAddBtn {
    if ([self.delegate respondsToSelector:@selector(addRecord:)]) {
        [self.delegate performSelector:@selector(addRecord:) withObject:[NSNumber numberWithInteger:self.item]];
    }
}

- (void)didClickViewBtn {
    if ([self.delegate respondsToSelector:@selector(viewRecord:)]) {
        [self.delegate performSelector:@selector(viewRecord:) withObject:[NSNumber numberWithInteger:self.item]];
    }
}

- (void)didClickShareBtn {
    if ([self.delegate respondsToSelector:@selector(shareRecord:)]) {
        [self.delegate performSelector:@selector(shareRecord:) withObject:[NSNumber numberWithInteger:self.item]];
    }
}

- (void)didClickDeleteBtn {
    if ([self.delegate respondsToSelector:@selector(editRecord:)]) {
        [self.delegate performSelector:@selector(editRecord:) withObject:[NSNumber numberWithInteger:self.item]];
    }
}

@end
