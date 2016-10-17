//
//  PetTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 3/14/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@protocol PetTableCellDelegate <NSObject>

- (void)didClickEditBtn:(NSIndexPath *)indexPath;

@end

@interface PetTableViewCell : UITableViewCell

@property (nonatomic, assign) id<PetTableCellDelegate> delegate;

- (void)bindData:(Pet *)petData indexPath:(NSIndexPath *)indexPath;

@end
