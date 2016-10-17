//
//  AppointmentView_One.m
//  VetX
//
//  Created by YulianMobile on 1/13/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AppointmentView_One.h"
#import "Constants.h"
#import "Masonry.h"
#import "ConsultationTypeButton.h"
#import "PetCellLayout.h"
#import "PetCollectionViewCell.h"
#import "RoundedBtn.h"
#import "ClinicTableViewCell.h"
#import "ButtonWithBottomLine.h"
#import "HNETimePicker.h"
#import <MapKit/MapKit.h>
//@import GoogleMaps;


static NSString *cellIdentifier = @"ClinicCell";

@interface AppointmentView_One () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@property (nonatomic, assign) CGFloat topSpace;

//@property (nonatomic, strong) GMSMapView *map;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) ConsultationTypeButton *home;
//@property (nonatomic, strong) ConsultationTypeButton *hospital;

@property (nonatomic, strong) UIView *selectedClinicView;
@property (nonatomic, strong) UIImageView *clinicPhotoView;
@property (nonatomic, strong) UILabel *clinicNameLabel;
@property (nonatomic, strong) UILabel *clinicAddressLable;
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UIButton *reselectClinic;

@property (nonatomic, strong) UILabel *selectDate;
@property (nonatomic, strong) UILabel *selectTimeFrame;
@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) HNETimePicker *startTimePicker;
@property (nonatomic, strong) HNETimePicker *endTimePicker;
@property (nonatomic, strong) UIButton *timeFrameBtn1;
@property (nonatomic, strong) UIButton *timeFrameBtn2;
@property (nonatomic, strong) ButtonWithBottomLine *dateBtn;
@property (nonatomic, strong) UILabel *selectPet;
@property (nonatomic, strong) UIImageView *petPhotoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *knownIssueLabel;
@property (nonatomic, strong) UILabel *petName;
@property (nonatomic, strong) UILabel *petKnowIssues;
@property (nonatomic, strong) RoundedBtn *start;

@end


@implementation AppointmentView_One

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setupView];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupView];

    }
    return self;
}

//- (void)setupView {
//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
//    self.timeFormatter = [[NSDateFormatter alloc] init];
//    [self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
//    
//    if (!self.searchBar) {
//        self.searchBar = [[UISearchBar alloc] init];
//        self.searchBar.delegate = self;
//        [self.searchBar setShowsCancelButton:YES];
//        [self.searchBar setPlaceholder:@"Search Zip Code"];
//        [self addSubview:self.searchBar];
//        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.left.and.width.equalTo(self);
//            make.height.equalTo(@44);
//        }];
//    }
//    
////    if (!self.map) {
////        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.43983930277749 longitude:-71.02089217809393 zoom:13];
////        self.map = [GMSMapView mapWithFrame:CGRectZero camera:camera];
////        [self.map setMyLocationEnabled:YES];
////        [self.map setMapType:kGMSTypeNormal];
////        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(42.43983930277750, -71.02089217809390);
////        GMSMarker *marker1 = [GMSMarker markerWithPosition:position];
////        marker1.title = @"Hello World";
////        marker1.map = self.map;
////        [self addSubview:self.map];
////        CLLocationCoordinate2D position1 = CLLocationCoordinate2DMake(41.43983930277750, -71.02089217809390);
////        GMSMarker *marker2 = [GMSMarker markerWithPosition:position1];
////        marker2.map = self.map;
////        
////        [self addSubview:self.map];
////        [self.map mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(self.searchBar.mas_bottom);
////            make.left.and.width.equalTo(self);
////            make.height.equalTo(@200);
////        }];
////    }
//    
//    if (!self.searchResultTable) {
//        self.searchResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//        [self.searchResultTable setBackgroundColor:[UIColor whiteColor]];
//        self.searchResultTable.delegate = self;
//        self.searchResultTable.dataSource = self;
//        [self.searchResultTable registerClass:[ClinicTableViewCell class] forCellReuseIdentifier:cellIdentifier];
//        [self.searchResultTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
//        [self addSubview:self.searchResultTable];
//        [self.searchResultTable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.map.mas_bottom);
//            make.bottom.left.and.right.equalTo(self);
//        }];
//    }
//    
//    if (!self.selectDate) {
//        self.selectDate = [[UILabel alloc] init];
//        [self.selectDate setFont:VETX_FONT_BOLD_15];
//        [self.selectDate setText:@"Select a date"];
//        [self.selectDate setTextColor:GREY_COLOR];
//        [self addSubview:self.selectDate];
//        [self.selectDate mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.searchResultTable.mas_bottom).offset(110);
//            make.centerX.equalTo(self);
//        }];
//    }
//    
//    if (!self.dateBtn) {
//        self.dateBtn = [[ButtonWithBottomLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75.0f)];
//        [self.dateBtn.titleLabel setFont:VETX_FONT_MEDIUM_15];
//        [self.dateBtn setTitle:@"SELECT DATE" forState:UIControlStateNormal];
//        [self.dateBtn setTitleColor:GREY_COLOR forState:UIControlStateNormal];
//        [self.dateBtn setBackgroundColor:[UIColor whiteColor]];
//        [self.dateBtn addTarget:self action:@selector(clickDateBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.dateBtn];
//        [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.and.width.equalTo(self);
//            make.height.equalTo(@75);
//            make.top.equalTo(self.searchResultTable.mas_bottom).offset(100);
//        }];
//    }
//    
//    
//    if (!self.calendarContentView) {
//        self.calendarContentView = [[JTHorizontalCalendarView alloc] init];
//        [self addSubview:self.calendarContentView];
//        [self.calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.selectDate.mas_bottom).offset(10);
//            make.left.and.width.equalTo(self);
//            // Full height will be @85
//            make.height.equalTo(@0);
//        }];
//    }
//    
//    
//
//    if (!self.startTimePicker) {
//        self.startTimePicker = [[HNETimePicker alloc] init];
//        [self.startTimePicker setDate:[NSDate date]];
//        [self addSubview:self.startTimePicker];
//        [self.startTimePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.and.centerX.equalTo(self);
//            make.height.equalTo(@50);
//            make.top.equalTo(self.calendarContentView.mas_bottom);
//        }];
//    }
//    
//    if (!self.toLabel) {
//        self.toLabel = [[UILabel alloc] init];
//        [self.toLabel setFont:VETX_FONT_MEDIUM_15];
//        [self.toLabel setTextColor:GREY_COLOR];
//        [self.toLabel setText:@"To"];
//        [self addSubview:self.toLabel];
//        [self.toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self.startTimePicker.mas_bottom).offset(15);
//        }];
//    }
//    
//    if (!self.endTimePicker) {
//        self.endTimePicker = [[HNETimePicker alloc] init];
//        [self.endTimePicker setDate:[NSDate date]];
//        [self addSubview:self.endTimePicker];
//        [self.endTimePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.and.centerX.equalTo(self);
//            make.height.equalTo(@50);
//            make.top.equalTo(self.toLabel.mas_bottom).offset(15);
//        }];
//    }
//    
//    
//    if (!self.start) {
//        self.start = [[RoundedBtn alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 40)];
//        [self.start setTitle:@"Make Appointment" forState:UIControlStateNormal];
//        [self.start setSelected:YES];
//        [self addSubview:self.start];
//        [self.start mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-10);
//            make.centerX.equalTo(self);
//            make.height.equalTo(@40);
//            make.width.equalTo(self.mas_width).offset(-40);
//        }];
//    }
//}


- (void)addConfirmView:(CGRect)startingRect withObject:(NSDictionary *)dict{
    self.topSpace = startingRect.origin.y;
    if (!self.selectedClinicView) {
        self.selectedClinicView = [[UIView alloc] initWithFrame:startingRect];
    }
    [self.selectedClinicView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.selectedClinicView];
    [self.selectedClinicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.topSpace);
        make.height.equalTo(@100);
        make.left.and.right.equalTo(self);
    }];
    
    if (!self.clinicPhotoView) {
        self.clinicPhotoView = [[UIImageView alloc] init];
    }
    [self.clinicPhotoView setUserInteractionEnabled:YES];
    [self.clinicPhotoView setImage:[UIImage imageNamed:@"Ambulance"]];
    [self.selectedClinicView addSubview:self.self.clinicPhotoView];
    [self.clinicPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.selectedClinicView);
        make.width.and.height.equalTo(self.selectedClinicView.mas_height);
    }];
    
    if (!self.clinicNameLabel) {
        self.clinicNameLabel = [[UILabel alloc] init];
    }
    [self.clinicNameLabel setFont:VETX_FONT_BOLD_15];
    [self.clinicNameLabel setTextColor:GREY_COLOR];
    [self.clinicNameLabel setText:[dict objectForKey:@"name"]];
    [self.clinicNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.selectedClinicView addSubview:self.clinicNameLabel];
    [self.clinicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clinicPhotoView.mas_right).offset(10);
        make.bottom.equalTo(self.clinicPhotoView.mas_centerY).offset(-15);
    }];
    
    if (!self.clinicAddressLable) {
        self.clinicAddressLable = [[UILabel alloc] init];
    }
    [self.clinicAddressLable setFont:VETX_FONT_MEDIUM_13];
    [self.clinicAddressLable setTextColor:LIGHT_GREY_COLOR];
    [self.clinicAddressLable setNumberOfLines:2];
    [self.clinicAddressLable setTextAlignment:NSTextAlignmentLeft];
    [self.clinicAddressLable setPreferredMaxLayoutWidth:200.0f];
    [self.selectedClinicView addSubview:self.clinicAddressLable];
    [self.clinicAddressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clinicNameLabel);
        make.centerY.equalTo(self.clinicPhotoView.mas_centerY).offset(10);
    }];
    
    if (!self.bottomLine) {
        self.bottomLine = [[UILabel alloc] init];
    }
    [self.bottomLine setBackgroundColor:LIGHT_GREY_COLOR];
    [self.selectedClinicView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.selectedClinicView);
        make.height.equalTo(@0.5f);
    }];
    
    if (!self.reselectClinic) {
        self.reselectClinic = [[UIButton alloc] init];
    }
    [self.reselectClinic addTarget:self action:@selector(showMapAndTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.selectedClinicView addSubview:self.reselectClinic];
    [self.reselectClinic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.selectedClinicView);
    }];
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClinicTableViewCell *cell = (ClinicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ClinicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Close Map View & Table View and Only show the selected Cell
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperView = [tableView convertRect:rectInTableView toView:[tableView superview]];
    NSString *row = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    NSDictionary *dict = @{@"name": row};
    [self addConfirmView:rectInSuperView withObject:dict];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Making a same view with name label in it and hide map view, search bar and table view
//    [self hideMapAndTableView];
}

//- (void)hideMapAndTableView {
//    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@0);
//    }];
//    [self.map mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@0);
//    }];
//    [self.searchResultTable mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.map.mas_bottom);
//        make.left.and.right.equalTo(self);
//        make.height.equalTo(@0);
//    }];
//    [self.selectedClinicView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//    }];
//    [self.selectDate mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.selectedClinicView.mas_bottom);
//    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self updateConstraints];
//        [self layoutIfNeeded];
//    }];
//}
//
//- (void)showMapAndTableView {
//    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@44);
//    }];
//    [self.map mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@200);
//    }];
//    [self.searchResultTable mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.map.mas_bottom);
//        make.left.and.right.equalTo(self);
//        make.bottom.equalTo(self);
//    }];
//    [self.selectedClinicView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(self.topSpace);
//    }];
//    [self.selectDate mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.searchResultTable.mas_bottom);
//    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self updateConstraints];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self.selectedClinicView removeFromSuperview];
//        }
//    }];
//}

- (void)clickDateBtn {
    [self.dateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    [self.calendarContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@85);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self updateConstraints];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.dateBtn setHidden:YES];
        }
    }];
}

@end
