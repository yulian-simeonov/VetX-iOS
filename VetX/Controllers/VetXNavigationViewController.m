//
//  VetXNavigationViewController.m
//  VetX
//
//  Created by Zongkun Dou on 1/12/16.
//  Copyright © 2016 Zongkun Dou. All rights reserved.
//

#import "VetXNavigationViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "VetXMenuViewController.h"

@interface VetXNavigationViewController ()

@property (strong, readwrite, nonatomic) VetXMenuViewController *menuViewController;


@end

@implementation VetXNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
