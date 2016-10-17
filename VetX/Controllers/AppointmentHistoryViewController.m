//
//  AppointmentHistoryViewController.m
//  VetX
//
//  Created by YulianMobile on 2/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AppointmentHistoryViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "VXDropDownTableViewController.h"
#import "AppointmentHistoryTableViewCell.h"
#import "AppointmentViewController.h"

@interface AppointmentHistoryViewController () <DropdownMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) VXDropDownTableViewController *menu;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AppointmentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isExpand = NO;
    self.items = @[@"Upcoming", @"Past"];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupView {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setExclusiveTouch:YES];
    [rightBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn setTintColor:GREY_COLOR];
    [rightBtn setImage:[[UIImage imageNamed:@"Calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(makeAppointment) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:right];
    [self.navigationItem setTitle:@"APPOINTMENT"];
    
    [self.view setBackgroundColor:FEED_BACKGROUND_COLOR];
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[AppointmentHistoryTableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(50);
            make.left.right.and.bottom.equalTo(self.view);
        }];
    }
    
    if (!self.menu) {
        self.menu = [[VXDropDownTableViewController alloc] init];
        self.menu.delegate = self;
        [self.menu setMenuItems:self.items];
        self.menu.menuItemHeight = 50.0f;
        [self addChildViewController:self.menu];
        [self.view addSubview:self.menu.view];
        [self.menu didMoveToParentViewController:self];
        [self.menu.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.and.right.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
}

- (void)makeAppointment {
    AppointmentViewController *makeAppointment = [[AppointmentViewController alloc] init];
    [self presentViewController:makeAppointment animated:YES completion:^{
        
    }];
}

#pragma mark - Dropdown menu delegate

- (void)didSelectItemIndex:(NSIndexPath *)indexPath {
    [self changeMenuHeight];
}

- (void)changeMenuHeight {
    self.isExpand = !self.isExpand;
    CGFloat heigt;
    if (self.isExpand) {
        heigt = (self.items.count+1) * 50.0f;
    } else {
        heigt = 50.0f;
    }
    [self.menu.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:heigt]);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.menu.view layoutIfNeeded];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TableView Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppointmentHistoryTableViewCell *cell = (AppointmentHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[AppointmentHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
