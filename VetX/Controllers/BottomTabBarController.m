//
//  BottomTabBarController.m
//  UNE
//
//  Created by YulianMobile on 11/23/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "BottomTabBarController.h"
#import "Constants.h"
#import "SettingsViewController.h"
#import "HomeFeedViewController.h"
#import "AppointmentHistoryViewController.h"
#import "InviteViewController.h"
#import "VetXClubViewController.h"
#import "VetXStoreViewController.h"
#import "MyQuestionViewController.h"
#import "VXVetFeedViewController.h"
#import "VTXMedicalRecordsViewController.h"
#import "ProfileViewController.h"
#import "VTXVetOneOnOneViewController.h"
#import "VTXVetAnswersViewController.h"
#import "QuestionRequestModel.h"
#import "QuestionManager.h"
#import "UserManager.h"
@import FirebaseMessaging;

@interface BottomTabBarController () <UITabBarDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UINavigationController *firstItem;
@property (strong, nonatomic) UINavigationController *secondaryItem;
@property (strong, nonatomic) UINavigationController *thirdItem;
@property (strong, nonatomic) UINavigationController *fourthItem;
@property (strong, nonatomic) UINavigationController *fifthItem;

@end

@implementation BottomTabBarController

- (instancetype)initWithUserMainViews {
    self = [super init];
    if (self) {
        [self setAccessibilityLabel:@"User_Bottom_Bar"];
        [self setIsAccessibilityElement:YES];
        self.firstItem = [self regularFeedItem];
        self.thirdItem = [self myQuestionsItem];
        self.fourthItem = [self recordsItem];
        self.fifthItem = [self profileItem];
        self.viewControllers = @[self.firstItem, self.thirdItem, self.fourthItem, self.fifthItem];
    }
    return self;
}

- (instancetype)initWithVetMainViews {
    self = [super init];
    if (self) {
        [self setAccessibilityLabel:@"Vet_Bottom_Bar"];
        [self setIsAccessibilityElement:YES];
        // Unanswered questions, feed, history, store, more settings
        self.firstItem = [self unAnsweredFeedItem];
        self.thirdItem = [self oneOnOneItem];
        self.fourthItem = [self myAnswersItem];
        self.fifthItem = [self profileItem];
        self.viewControllers = @[self.firstItem, self.thirdItem, self.fourthItem, self.fifthItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.tabBar.tintColor = ORANGE_THEME_COLOR;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationReceived:) name:@"pushNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myNotificationReceived:(NSNotification *)notification {
    //!!!: Need to reformat this part of code!!!!
    if ([[notification.userInfo objectForKey:@"type"] isEqualToString:@"general"]) {
        NSInteger current = [[[self.tabBar.items objectAtIndex:0] badgeValue] integerValue];
        current += 1;
        [[self.tabBar.items objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%zd", current]];
        QuestionRequestModel *requestionModel = [[QuestionRequestModel alloc] init];
        requestionModel.limit = @100;
        [[QuestionManager defaultManager] getFeedWithParameter:requestionModel];
    } else {
        NSInteger current = [[[self.tabBar.items objectAtIndex:1] badgeValue] integerValue];
        current += 1;
        [[self.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%zd", current]];
        if ([[UserManager defaultManager] currentUser] && [[[UserManager defaultManager] currentUser] licenseID]) {
            [[QuestionManager defaultManager] getUnansweredChatGroup:nil complete:^(BOOL finished, NSError *error) {
                
            }];
        } else {
            if ([[UserManager defaultManager] currentUserID]) {
                QuestionRequestModel *request = [[QuestionRequestModel alloc] init];
                request.userID = [[UserManager defaultManager] currentUserID];
                [[QuestionManager defaultManager] getUserQuestionsHistory:request complete:^(BOOL finished, NSError *error) {
                    
                }];
                [[QuestionManager defaultManager] getUnansweredChatGroup:[[UserManager defaultManager] currentUserID] complete:^(BOOL finished, NSError *error) {
                    
                }];
                [[QuestionManager defaultManager] getConsultationHistory:[[UserManager defaultManager] currentUserID] complete:^(BOOL finished, NSError *error) {
                    
                }];
            }
        }
    }
    
}

#pragma mark - Tab Bar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    item.badgeValue = nil;
}

#pragma mark - Tab Bar Controller Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if ([viewController isEqual:self.firstItem] || [viewController isEqual:self.secondaryItem]) {
        [self.firstItem setNavigationBarHidden:YES];
        [self.firstItem popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Init Tabs
- (UINavigationController *)regularFeedItem {
    HomeFeedViewController *first = [[HomeFeedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:first];
    [nav setNavigationBarHidden:YES];
    nav.tabBarItem.image = [[UIImage imageNamed:@"Newspaper"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"Newspaper"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [nav.tabBarItem setIsAccessibilityElement:YES];
    [nav.tabBarItem setAccessibilityLabel:@"Feed_Tab"];
    return nav;
}

- (UINavigationController *)unAnsweredFeedItem {
    VXVetFeedViewController *first = [[VXVetFeedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:first];
    [nav setNavigationBarHidden:YES];
    nav.tabBarItem.image = [[UIImage imageNamed:@"Newspaper"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"Newspaper"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [nav.tabBarItem setIsAccessibilityElement:YES];
    [nav.tabBarItem setAccessibilityLabel:@"Feed_Tab"];
    return nav;
}

- (UINavigationController *)appointmentItem {
    AppointmentHistoryViewController *second = [[AppointmentHistoryViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:second];
    [nav setNavigationBarHidden:NO];
    nav.tabBarItem.image = [UIImage imageNamed:@"Appts_Grey"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [nav.tabBarItem setIsAccessibilityElement:YES];
    [nav.tabBarItem setAccessibilityLabel:@"Appointment_Tab"];
    return nav;
}

- (UINavigationController *)myQuestionsItem {
    MyQuestionViewController *third = [[MyQuestionViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:third];
    [nav setNavigationBarHidden:YES];
    nav.tabBarItem.image = [[UIImage imageNamed:@"Comments-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"Comments-1"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    return nav;
}

- (UINavigationController *)oneOnOneItem {
    VTXVetOneOnOneViewController *third = [[VTXVetOneOnOneViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:third];
    [nav setNavigationBarHidden:YES];
    nav.tabBarItem.image = [[UIImage imageNamed:@"Inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"Inbox"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    return nav;
}

- (UINavigationController *)myAnswersItem {
    VTXVetAnswersViewController *third = [[VTXVetAnswersViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:third];
    [nav setNavigationBarHidden:YES];
    nav.tabBarItem.image = [[UIImage imageNamed:@"Comments-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"Comments-1"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    return nav;
}

- (UINavigationController *)inviteItem {
    InviteViewController *fourth = [[InviteViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fourth];
    [nav setNavigationBarHidden:NO];
    nav.tabBarItem.image = [UIImage imageNamed:@"Club_Grey"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    return nav;
}

- (UINavigationController *)recordsItem {
    VTXMedicalRecordsViewController *profileVC = [[VTXMedicalRecordsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [nav setNavigationBarHidden:NO];
    nav.tabBarItem.image = [[UIImage imageNamed:@"Portfolio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"Portfolio"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    return nav;
}

- (UINavigationController *)profileItem {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profile];
    [nav setNavigationBarHidden:NO];
    nav.tabBarItem.image = [[UIImage imageNamed:@"User"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"User"];
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    return nav;
}

- (UINavigationController *)vetxClubItem {
    VetXClubViewController *clubVC = [[VetXClubViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:clubVC];
    [nav setNavigationBarHidden:NO];
    nav.tabBarItem.image = [UIImage imageNamed:@"Club_Grey"];
    nav.tabBarItem.title = @"VetX Club";
    return nav;
}


- (UINavigationController *)vetxStoreItem {
    VetXStoreViewController *storeVC = [[VetXStoreViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:storeVC];
    [nav setNavigationBarHidden:NO];
    nav.tabBarItem.image = [UIImage imageNamed:@"Settings_Grey"];
    nav.tabBarItem.title = @"VetX Club";
    return nav;
}
@end
