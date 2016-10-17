//
//  VTXViewController.m
//  VetX
//
//  Created by Liam Dyer on 2/17/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXViewController.h"
#import "Constants.h"

@interface VTXViewController ()

@end

@implementation VTXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
    
    // Do any additional setup after loading the view.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setExclusiveTouch:YES];
    [leftButton setFrame:CGRectMake(0, 0, 32, 32)];
    [leftButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [left setTintColor:GREY_COLOR];
    [self.navigationItem setLeftBarButtonItem:left];
}

- (void)backButtonClicked {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
