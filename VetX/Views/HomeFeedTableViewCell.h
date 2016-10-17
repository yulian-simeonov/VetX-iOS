//
//  HomeFeedTableViewCell.h
//  VetX
//
//  Created by YulianMobile on 1/25/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol HomeFeedTableViewCellDelegate <NSObject>

- (void)shareQuestion:(Question *)questionObj;

@end

@interface HomeFeedTableViewCell : UITableViewCell

@property (nonatomic, assign) id<HomeFeedTableViewCellDelegate> delegate;

- (void)bindQuestionData:(Question *)questionObj;

@end
