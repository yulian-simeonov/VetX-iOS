//
//  ConsultationRequestTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 5/21/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consultation.h"

@interface ConsultationRequestTableViewCell : UITableViewCell

- (void)bindWithUserData:(Consultation *)consultation indexPath:(NSIndexPath *)indexPath;

@end
