//
//  EditPasswordViewController.m
//  VetX
//
//  Created by YulianMobile on 1/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "ChangePasswordView.h"
#import "Constants.h"
#import "Masonry.h"
#import "SCLAlertView.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "UserManager.h"

@interface EditPasswordViewController () <ChangePasswordDelegate>

@property (nonatomic, strong) ChangePasswordView *changeView;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setExclusiveTouch:YES];
    [leftBtn setFrame:CGRectMake(0, 0, 32, 32)];
    [leftBtn setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [left setTintColor:GREY_COLOR];
    [self.navigationItem setLeftBarButtonItem:left];
    [self.navigationItem setTitle:@"Change Password"];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Change Password Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"change_password" timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"change_password" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (!self.changeView) {
        self.changeView = [[ChangePasswordView alloc] init];
        self.changeView.delegate = self;
        [self.view addSubview:self.changeView];
        [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changePswdClicked {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Update Password"
                                                           label:@"Update Password"
                                                           value:nil] build]];
    [Flurry logEvent:@"Update Password"];
    NSString *oldPassword = [self.changeView.oldPswdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.changeView.pswdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPswd = [self.changeView.retypePswdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!confirmPswd || ![confirmPswd isEqualToString:password]) {
        [self showErrorAlertWithTitle:@"Fail to update password" message:@"The new password doesn't match"];
    } else if (confirmPswd.length < 6) {
       [self showErrorAlertWithTitle:@"Fail to update password" message:@"Please input at least 6 characters new password"];
    }
    [[UserManager defaultManager] updateOldPassword:oldPassword withPassword:password confirm:confirmPswd andSuccess:^(BOOL finished) {
        [self backBtnClicked];
    } andError:^(NSError *error) {
       [self showErrorAlertWithTitle:@"Fail to update password" message:[error localizedDescription]];
    }];
}

#pragma mark - Alert

- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}

@end
