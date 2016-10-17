//
//  VXDropDownTableViewController.h
//  VetX
//
//  Created by YulianMobile on 2/17/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropdownMenuDelegate <NSObject>

- (void)didSelectItemIndex:(NSIndexPath *)indexPath;

@end

@interface VXDropDownTableViewController : UIViewController

@property (nonatomic, strong) id<DropdownMenuDelegate> delegate;
@property (nonatomic, assign) CGFloat menuItemHeight;

- (void)setMenuItems:(NSArray *)items;

@end
