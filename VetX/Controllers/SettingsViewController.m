//
//  SettingsViewController.m
//  VetX
//
//  Created by YulianMobile on 1/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import <Google/Analytics.h>
#import "Masonry.h"
#import "Constants.h"
#import "ProfileViewController.h"
#import "Flurry.h"
#import "UserManager.h"
#import "BottomTabBarController.h"
#import "EditPasswordViewController.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setExclusiveTouch:YES];
    [leftButton setFrame:CGRectMake(0, 0, 32, 32)];
    [leftButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [left setTintColor:GREY_COLOR];
    [self.navigationItem setLeftBarButtonItem:left];
    
    
    [self.navigationItem setTitle:@"Settings"];

    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Settings Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"settings" timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [Flurry endTimedEvent:@"settings" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[SettingsTableViewCell class] forCellReuseIdentifier:@"MoreSettingsCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        default:
            return 4;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor colorWithRed:0.690  green:0.690  blue:0.690 alpha:1];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 3, 100, 24)];
    switch (section) {
        case 0:
            title.text = @"Logout";
            break;
        case 1:
            title.text = @"General";
            break;
        case 2:
            title.text = @"Help";
            break;
        default:
            title.text = @"Social Media";
            break;
    }
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:VETX_FONT_BOLD_11];
    [title sizeToFit];
    CGFloat height = CGRectGetHeight(title.frame);
    CGFloat width = CGRectGetWidth(title.frame);
    [title setFrame:CGRectMake(18, (30-height)/2.0f, width, height)];
    [view addSubview:title];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MoreSettingsCell"];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreSettingsCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Logout";
            [cell.arrowImage setHidden:NO];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Version";
            cell.secondLabel.text = @"1.0.0";
            [cell.arrowImage setHidden:YES];
        } else  if (indexPath.row == 1) {
            cell.titleLabel.text = @"Change Password";
            [cell.arrowImage setHidden:NO];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Contact";
        }  else  if (indexPath.row == 1) {
            cell.titleLabel.text = @"Terms & Conditions";
        } else {
            cell.titleLabel.text = @"Privacy Policy";
        }
    } else {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Facebook";
        } else if (indexPath.row == 1){
            cell.titleLabel.text = @"Twitter";
        } else  if (indexPath.row == 2) {
            cell.titleLabel.text = @"Instagram";
        } else {
            cell.titleLabel.text = @"Website";
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    if (indexPath.section == 0) {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Logout User"
                                                               label:@"Logout User"
                                                               value:nil] build]];
        [Flurry logEvent:@"Logout User"];
        if ([[UserManager defaultManager] logoutCurrentUser]) {
            UINavigationController *nav;
            BottomTabBarController *bottomVC = [[BottomTabBarController alloc] initWithUserMainViews];
            nav = [[UINavigationController alloc] initWithRootViewController:bottomVC];
            [nav setNavigationBarHidden:YES];
            [[[UIApplication sharedApplication].delegate window] setRootViewController:nav];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"Go to Edit Password"
                                                                   label:@"Go to Edit Password"
                                                                   value:nil] build]];
            [Flurry logEvent:@"Go to Edit Password"];
            EditPasswordViewController *editPasswordVC = [[EditPasswordViewController alloc] init];
            [self.navigationController pushViewController:editPasswordVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"Send Feedback Email"
                                                                   label:@"Send Feedback Email"
                                                                   value:nil] build]];
            [Flurry logEvent:@"Send Feedback Email"];
            [self sendEmail];
        } else  if (indexPath.row == 3) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"View Terms"
                                                                   label:@"View Terms"
                                                                   value:nil] build]];
            [Flurry logEvent:@"View Terms"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vet.vetxapp.com/ToS.pdf"]];
        } else {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"View Privacy Document"
                                                                   label:@"View Privacy Document"
                                                                   value:nil] build]];
            [Flurry logEvent:@"View Privacy Document"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vet.vetxapp.com/Privacy.pdf"]];
        }
    } else {
        if (indexPath.row == 0) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"Go to FB Page"
                                                                   label:@"Go to FB Page"
                                                                   value:nil] build]];
            [Flurry logEvent:@"Go to FB Page"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/VetX-107001202972635/?fref=ts"]];
        } else if (indexPath.row == 1){
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"Go to Twitter"
                                                                   label:@"Go to Twitter"
                                                                   value:nil] build]];
            [Flurry logEvent:@"Go to Twitter"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/VetXApp"]];
        } else  if (indexPath.row == 2) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"Go to Instagram"
                                                                   label:@"Go to Instagram"
                                                                   value:nil] build]];
            [Flurry logEvent:@"Go to Instagram"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/vetxapp/"]];
        } else {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                                  action:@"Go to Website"
                                                                   label:@"Go to Website"
                                                                   value:nil] build]];
            [Flurry logEvent:@"Go to Website"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vetxapp.com/"]];
            
        }
        
    }
}

- (void)sendEmail
{

    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"feedback"];
        
        NSArray *toRecipients = @[@"support@vetxapp.com"];
        [mailer setToRecipients:toRecipients];
        
        [self presentViewController:mailer animated:YES completion:NULL];
    } else {
        UIAlertView *helpAlert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Default mail app not set up, to contact us please email support@vetxapp.com"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [helpAlert show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Did send feedback email"
                                                           label:@"Did send feedback email"
                                                           value:nil] build]];
    [Flurry logEvent:@"Did send feedback email"];
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}


@end
