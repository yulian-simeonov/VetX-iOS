//
//  VTXMedicalRecordItemView.h
//  VetX
//
//  Created by YulianMobile on 4/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CertificateOfHealth,
    VaccinationRecord,
    LaboratoryResults,
    PatentChart,
    InvoiceRecord,
    OtherRecord
} MedicalRecordItem;

@protocol VTXMedicalRecordItemDelegate <NSObject>

- (void)addRecord:(NSNumber *)item;
- (void)shareRecord:(NSNumber *)item;
- (void)editRecord:(NSNumber *)item;
- (void)viewRecord:(NSNumber *)item;

@end

@interface VTXMedicalRecordItemView : UIView

@property (nonatomic, assign) id<VTXMedicalRecordItemDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithItem:(MedicalRecordItem)item;
- (void)showDivider:(BOOL)show;
- (void)showAddBtn;
- (void)showViewBtn;

@end
