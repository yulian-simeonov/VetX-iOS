//
//  VXDropDownTableViewController.m
//  VetX
//
//  Created by YulianMobile on 2/17/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VXDropDownTableViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "DropdownMenuCell.h"
#import <Google/Analytics.h>
#import "Flurry.h"

@interface VXDropDownTableViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) UIView *selectedMenu;
@property (nonatomic, strong) UILabel *selectedTitle;
//@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *divider;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation VXDropDownTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.isExpand = NO;
    
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Filter by Topic Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"filter_view" timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [Flurry endTimedEvent:@"filter_view" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    
    [self.view setClipsToBounds:YES];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMenu)];
    [self.tap setNumberOfTapsRequired:1];
    self.tap.delegate = self;
    [self.view addGestureRecognizer:self.tap];
    
    if (!self.selectedMenu) {
        self.selectedMenu = [[UIView alloc] init];
        [self.selectedMenu setUserInteractionEnabled:YES];
        [self.selectedMenu setClipsToBounds:YES];
        [self.selectedMenu setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.selectedMenu];
        [self.selectedMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.view);
            make.height.equalTo([NSNumber numberWithFloat:self.menuItemHeight]);
        }];
    }
    
    if (!self.selectedTitle) {
        self.selectedTitle = [[UILabel alloc] init];
        [self.selectedTitle setFont:VETX_FONT_BOLD_15];
        [self.selectedTitle setTextColor:BLACK_SEARCH_MENU_FONT];
        [self.selectedTitle setText:@"Filter by Topic"];
        [self.selectedTitle setTextAlignment:NSTextAlignmentCenter];
        [self.selectedMenu addSubview:self.selectedTitle];
        [self.selectedTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.selectedMenu);
        }];
    }

    if (!self.divider) {
        self.divider = [[UILabel alloc] init];
        [self.divider setBackgroundColor:GREY_COLOR];
        [self.selectedMenu addSubview:self.divider];
        [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.selectedMenu);
            make.height.equalTo(@SINGLE_LINE_WIDTH);
        }];
    }
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.tableView setScrollEnabled:NO];
        [self.tableView setAllowsMultipleSelection:NO];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[DropdownMenuCell class] forCellReuseIdentifier:@"MenuCell"];
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedMenu.mas_bottom);
            make.left.and.right.equalTo(self.selectedMenu);
            make.height.equalTo([NSNumber numberWithFloat:(self.items.count*self.menuItemHeight)]).with.priorityMedium();
        }];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.menuItemHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropdownMenuCell *cell = (DropdownMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if (!cell) {
        cell = [[DropdownMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = SEARCH_MENU_COLOR;
    }
    [cell.itemLabel setText:[self.items objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
//    [self.selectedTitle setText:[NSString stringWithFormat:@"Topic: %@", [self.items objectAtIndex:self.selectedIndexPath.row]]];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Did Select Filter Item"
                                                           label:@"Did Select Filter Item"
                                                           value:nil] build]];
    [Flurry logEvent:@"Did Select Filter Item"];
    [self changeSelectedItem:indexPath];
}


- (void)changeSelectedItem:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(didSelectItemIndex:)]) {
        [self.delegate performSelector:@selector(didSelectItemIndex:) withObject:indexPath];
    }
}

- (void)setMenuItems:(NSArray *)items {
    self.items = items;
    [self.tableView reloadData];
}

- (void)showOrHideMenu {
    if ([self.delegate respondsToSelector:@selector(didSelectItemIndex:)]) {
        [self.delegate performSelector:@selector(didSelectItemIndex:) withObject:self.selectedIndexPath];
    }
}

#pragma mark - Tap gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}


@end
