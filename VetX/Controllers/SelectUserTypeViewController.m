//
//  SelectUserTypeViewController.m
//  VetX
//
//  Created by YulianMobile on 2/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "SelectUserTypeViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "BottomTabBarController.h"
#import "VetXVerticalButton.h"

@interface SelectUserTypeViewController ()

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) VetXVerticalButton *selectUser;
@property (nonatomic, strong) VetXVerticalButton *selectVet;

@end

@implementation SelectUserTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setAccessibilityLabel:@"SelectUserTypeView"];
    if (!self.selectLabel) {
        self.selectLabel = [[UILabel alloc] init];
        [self.selectLabel setBackgroundColor:[UIColor colorWithRed:0.776  green:0.780  blue:0.780 alpha:1]];
        [self.selectLabel setTextColor:[UIColor whiteColor]];
        [self.selectLabel setTextAlignment:NSTextAlignmentCenter];
        [self.selectLabel setText:@"Select one:"];
        [self.selectLabel setFont:VETX_FONT_BOLD_30];
        [self.view addSubview:self.selectLabel];
        [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.width.equalTo(self.view);
            make.height.equalTo(@80);
        }];
    }
    if (!self.selectUser) {
        self.selectUser = [[VetXVerticalButton alloc] init];
        [self.selectUser setTitle:@"I am a pet owner" forState:UIControlStateNormal];
        //!!!: Need to change color later
        [self.selectUser setBackgroundColor:[UIColor colorWithRed:0.004  green:0.573  blue:0.624 alpha:1]];
        [self.selectUser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.selectUser setImage:[UIImage imageNamed:@"RegularUser"] forState:UIControlStateNormal];
        [self.selectUser.titleLabel setFont:VETX_FONT_BOLD_30];
        [self.selectUser addTarget:self action:@selector(continueAsPetOwner) forControlEvents:UIControlEventTouchUpInside];
        [self.selectUser setAccessibilityLabel:@"RegularUser"];
        [self.view addSubview:self.selectUser];
        [self.selectUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.view);
            make.top.equalTo(self.selectLabel.mas_bottom);
            make.height.equalTo(self.view).multipliedBy(0.5).offset(-40);
        }];
    }
    
    if (!self.selectVet) {
        self.selectVet = [[VetXVerticalButton alloc] init];
        [self.selectVet setTitle:@"I am a Veterinarian" forState:UIControlStateNormal];
        //!!!: Need to change color later
        [self.selectVet setBackgroundColor:[UIColor colorWithRed:0  green:0.251  blue:0.337 alpha:1]];
        [self.selectVet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.selectVet setImage:[UIImage imageNamed:@"Vet"] forState:UIControlStateNormal];
        [self.selectVet.titleLabel setFont:VETX_FONT_BOLD_30];
        [self.selectVet addTarget:self action:@selector(continueAsVet) forControlEvents:UIControlEventTouchUpInside];
        [self.selectVet setAccessibilityLabel:@"VetUser"];
        [self.view addSubview:self.selectVet];
        [self.selectVet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.and.height.equalTo(self.selectUser);
            make.bottom.equalTo(self.view);
        }];
    }
}

- (void)continueAsPetOwner {
    [self.selectUser setSelected:YES];
    // Show regular user's feed
    [[NSUserDefaults standardUserDefaults] setObject:@"User" forKey:@"UserType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self navigateToRegularFeed];
}

- (void)navigateToRegularFeed {
    BottomTabBarController *menu = [[BottomTabBarController alloc] initWithUserMainViews];
    [self.navigationController pushViewController:menu animated:YES];
}

- (void)continueAsVet {
    [self.selectVet setSelected:YES];
    // Show unanswered questions feed for vet
    [[NSUserDefaults standardUserDefaults] setObject:@"Vet" forKey:@"UserType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self navigateToVetFeed];
}

- (void)navigateToVetFeed {
    BottomTabBarController *menu = [[BottomTabBarController alloc] initWithVetMainViews];
    [self.navigationController pushViewController:menu animated:YES];
}
@end
