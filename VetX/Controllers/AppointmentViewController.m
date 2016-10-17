//
//  AppointmentViewController.m
//  VetX
//
//  Created by YulianMobile on 1/12/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AppointmentViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "AppointmentView_One.h"
#import "RMDateSelectionViewController.h"
#import <JTCalendar/JTCalendar.h>

@interface AppointmentViewController () <AppointmentViewOneDelegate, JTCalendarDelegate>

@property (nonatomic, strong) AppointmentView_One *appointOne;

@property (nonatomic, strong) JTCalendarManager *calendarManager;

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setExclusiveTouch:YES];
//    [rightBtn setFrame:CGRectMake(0, 0, 20, 20)];
//    [rightBtn setTintColor:GREY_COLOR];
//    [rightBtn setImage:[[UIImage imageNamed:@"Calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(openAppointmentHistory) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    [self.navigationItem setRightBarButtonItem:right];
    [self.navigationItem setTitle:@"MAKE APPOINTMENT"];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (!self.appointOne) {
        self.appointOne = [[AppointmentView_One alloc] init];
        self.appointOne.delegate = self;
        [self.view addSubview:self.appointOne];
        [self.appointOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (!self.calendarManager) {
        self.calendarManager = [JTCalendarManager new];
        self.calendarManager.delegate = self;
        self.calendarManager.settings.weekModeEnabled = YES;
        [self.calendarManager setContentView:self.appointOne.calendarContentView];
        [self.calendarManager setDate:[NSDate date]];
    }
    
}

- (void)openAppointmentHistory {
    
}

- (void)openDateTimePicker {
//    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
//        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
//    }];
//    
//    //Create cancel action
//    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
//        NSLog(@"Date selection was canceled");
//    }];
//    
//    //Create date selection view controller
//    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
//    dateSelectionController.title = @"Appointment";
//    dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
//    
//    //Now just present the date selection controller using the standard iOS presentation method
//    [self presentViewController:dateSelectionController animated:YES completion:nil];
}



@end
