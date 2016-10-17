//
//  VetXMenuViewController.m
//  VetX
//
//  Created by Zongkun Dou on 1/12/16.
//  Copyright © 2016 Zongkun Dou. All rights reserved.
//

#import "VetXMenuViewController.h"
#import "HomeFeedViewController.h"
#import "HistoryViewController.h"
#import "ProfileViewController.h"
#import "InviteViewController.h"
#import "AppointmentViewController.h"
#import "SettingsViewController.h"
#import "VetXNavigationViewController.h"
#import "MenuTableViewCell.h"

@interface VetXMenuViewController ()

@end

@implementation VetXMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Tan";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        HomeFeedViewController *homeViewController = [[HomeFeedViewController alloc] init];
        VetXNavigationViewController *navigationController = [[VetXNavigationViewController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.row == 1) {
        AppointmentViewController *secondViewController = [[AppointmentViewController alloc] init];
        VetXNavigationViewController *navigationController = [[VetXNavigationViewController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.row == 2) {
        HistoryViewController *historyViewController = [[HistoryViewController alloc] init];
        VetXNavigationViewController *navigationController = [[VetXNavigationViewController alloc] initWithRootViewController:historyViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.row == 3) {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
        VetXNavigationViewController *navigationController = [[VetXNavigationViewController alloc] initWithRootViewController:profileViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.row == 4){
        InviteViewController *inviteViewController = [[InviteViewController alloc] init];
        VetXNavigationViewController *navigationController = [[VetXNavigationViewController alloc] initWithRootViewController:inviteViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else {
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
        VetXNavigationViewController *navigationController = [[VetXNavigationViewController alloc] initWithRootViewController:settingsViewController];
        self.frostedViewController.contentViewController = navigationController;
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Consultation", @"Appointment", @"History", @"Profile", @"Invite", @"Settings"];
//        cell.textLabel.text = titles[indexPath.row];
        NSString *title = titles[indexPath.row];
        switch (indexPath.row) {
            case 0:
                [cell setTitle:title icon:[[UIImage imageNamed:@"Menu-Consultation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                break;
            case 1:
                [cell setTitle:title icon:[[UIImage imageNamed:@"Planner"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                break;
            case 2:
                [cell setTitle:title icon:[UIImage imageNamed:@"BottomNav_History"]];
                break;
            case 3:
                [cell setTitle:title icon:[[UIImage imageNamed:@"Menu-Profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                break;
            case 4:
                [cell setTitle:title icon:[[UIImage imageNamed:@"Menu-Invite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                break;
            default:
                [cell setTitle:title icon:[UIImage imageNamed:@"Settings_Grey"]];
                break;
        }
    }
    
    return cell;
}


@end
