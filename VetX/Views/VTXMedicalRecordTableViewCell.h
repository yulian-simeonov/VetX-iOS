//
//  VTXMedicalRecordTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 4/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@protocol VTXMedicalRecordCellDelegate <NSObject>

- (void)addRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath;
- (void)shareRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath;
- (void)viewRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath;
- (void)editRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath;

@end

@interface VTXMedicalRecordTableViewCell : UITableViewCell

@property (nonatomic, assign) id<VTXMedicalRecordCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)bindPetData:(Pet *)pet;

@end
