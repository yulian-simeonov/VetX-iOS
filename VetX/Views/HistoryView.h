//
//  HistoryView.h
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryViewDelegate <NSObject>

- (void)clickInProgres;
- (void)clickComplete;

@end

@interface HistoryView : UIView

@property (nonatomic, assign) id<HistoryViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;


@end
