//
//  AppointmentView_One.h
//  VetX
//
//  Created by YulianMobile on 1/13/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@protocol AppointmentViewOneDelegate <NSObject>

- (void)openDateTimePicker;

@end

@interface AppointmentView_One : UIView

@property (nonatomic, assign) id<AppointmentViewOneDelegate> delegate;

@property (nonatomic, strong) UITableView *searchResultTable;
@property (nonatomic, strong) JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) UICollectionView *collectionView;


@end
