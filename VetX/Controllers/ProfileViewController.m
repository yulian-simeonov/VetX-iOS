//
//  ProfileViewController.m
//  VetX
//
//  Created by YulianMobile on 1/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "Masonry.h"
#import "Constants.h"
#import "ProfileButton.h"
#import "SignUpLoginViewController.h"
#import "EditProfileViewController.h"
#import "EditPasswordViewController.h"
#import "SubscriptionViewController.h"
#import "UserManager.h"
#import "PetTableViewCell.h"
#import "User.h"
#import "SCLAlertView.h"
#import "SettingsViewController.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "VTXEmptyView.h"
#import "VTXAddPetView.h"
#import "UIImage+ImageOperations.h"
#import "AddPetTableViewCell.h"
#import "MBProgressHUD.h"


@interface ProfileViewController () <ProfileViewDelegate, UITableViewDelegate, UITableViewDataSource, VTXEmptyViewDelegate, VTXAddPetViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PetTableCellDelegate>

@property (nonatomic, assign) BOOL addPetImage;
@property (nonatomic, strong) UIImage *petImageToUpload;
@property (nonatomic, strong) SignUpLoginViewController *signupVC;
@property (nonatomic, strong) ProfileView *profileView;
@property (nonatomic, strong) VTXAddPetView *addPetView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VTXEmptyView *emptyView;

@property (nonatomic, strong) RLMArray <Pet *><Pet> *petArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setExclusiveTouch:YES];
    [rightButton setFrame:CGRectMake(0, 0, 32, 32)];
    [rightButton setTintColor:[UIColor whiteColor]];
    [rightButton setImage:[[UIImage imageNamed:@"Settings_Grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(settingsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [left setTintColor:GREY_COLOR];
    [self.navigationItem setRightBarButtonItem:left];
    
    [self.navigationItem setTitle:@"Profile"];

    [self setupView];
    if ([[UserManager defaultManager] currentUser]) {
        [self getCurrentUserData];
        [self setupFetchedResultsController];
    } else {
        [self presendtSignupLogin];
        [self addEmptyPage];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Profile Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"profile_page" timed:YES];
    [[UserManager defaultManager] getLatestCurrentUserInfo];

    if ([[UserManager defaultManager] currentUser]) {
        [self getCurrentUserData];
        [self setupFetchedResultsController];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"profile_page" withParameters:nil];
//    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Signup & Login

- (void)presendtSignupLogin {
    self.signupVC = [[SignUpLoginViewController alloc] init];
    [self presentViewController:self.signupVC animated:YES completion:^{
        
    }];
}

- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - UIBarPositioningDelegate
-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setContentInset:UIEdgeInsetsMake(10,0,0,0)];
        [self.tableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView registerClass:[PetTableViewCell class] forCellReuseIdentifier:@"PetCell"];
        [self.tableView registerClass:[AddPetTableViewCell class] forCellReuseIdentifier:@"AddPetCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(130);
            make.left.bottom.and.right.equalTo(self.view);
        }];
    }
    
    if (!self.profileView) {
        self.profileView = [[ProfileView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        [self.profileView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.profileView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        [self.profileView.layer setShadowOpacity:0.3f];
        [self.profileView.layer setShadowRadius:3.0f];
        self.profileView.delegate = self;
        [self.view addSubview:self.profileView];
        [self.profileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.and.left.equalTo(self.view);
            make.height.equalTo(@130);
        }];
    }
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
}

- (void)setupFetchedResultsController {
//    RLMRealm *realm = [RLMRealm defaultRealm];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", [UserManager defaultManager].currentUserID];
    
    self.petArray = [[UserManager defaultManager] currentUser].pets;
    if (self.petArray.count == 0) {
        [self addEmptyPage];
    } else {
        [self.emptyView removeFromSuperview];
    }
    [self.tableView reloadData];
    __weak typeof(self) weakSelf = self;
    [[User objectsWithPredicate:predicate] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange *changes,  NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                User *user = results[0];
                strongSelf.petArray = user.pets;
                if (strongSelf.petArray.count == 0) {
                    [strongSelf addEmptyPage];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.emptyView removeFromSuperview];
                        [strongSelf.tableView reloadData];
                    });
                }
            }
        }
    }];
}

- (void)getCurrentUserData {
    User *current = [[UserManager defaultManager] currentUser];
    [self.profileView bindUserData:current];
}

- (void)editProfileClicked {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Go to Edit Profile View"
                                                           label:@"Go to Edit Profile View"
                                                           value:nil] build]];
    [Flurry logEvent:@"Go to Edit Profile View"];
    EditProfileViewController *profile = [[EditProfileViewController alloc] init];
    [self presentViewController:profile animated:YES completion:^{
        
    }];
}

- (void)addEmptyPage {
    if (!self.emptyView) {
        self.emptyView = [[VTXEmptyView alloc] init];
        self.emptyView.delegate = self;
        [self.emptyView setEmptyScreenType:EmptyProfile];
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.profileView.mas_bottom);
            make.left.right.and.bottom.equalTo(self.view);
        }];
    }
}

- (void)settingsBtnClicked {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - Empty Page Delegate
- (void)didClickBtn {
    // Add pet here
    if ([[UserManager defaultManager] currentUser]) {
        [self showAddPetView:nil];
    } else {
        [self presendtSignupLogin];
    }
}

- (void)showAddPetView:(Pet *)pet {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Open Add Pet View"
                                                           label:@"Open Add Pet View"
                                                           value:nil] build]];
    [Flurry logEvent:@"Open Add Pet View"];
    if (!self.addPetView) {
        self.addPetView = [[VTXAddPetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    self.addPetView.type = [[NSMutableArray alloc] initWithArray:@[@"Dog", @"Cat"]];
    self.addPetView.request = [[AddPetRequestModel alloc] init];
    self.addPetView.delegate = self;
    [[UserManager defaultManager] getPetTypeBreedComplete:^(BOOL finished, NSDictionary *data) {
        self.addPetView.typeBreed = data;
        self.addPetView.breed= [data objectForKey:@"Cat"];
    }];
    [self.addPetView setPetInfo:pet];
    [self.view addSubview:self.addPetView];
    [self.addPetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Add pet delegate

- (void)openImagePicker {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Add Pet Profile Image"
                                                           label:@"Add Pet Profile Image"
                                                           value:nil] build]];
    [Flurry logEvent:@"Add Pet Profile Image"];
    UIAlertController *addPetImageOptions = [UIAlertController alertControllerWithTitle:@"Upload Pet Profile Image" message:@"Add a profile image for your lovely pet!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *camera=[[UIImagePickerController alloc]init];
            [camera setSourceType:UIImagePickerControllerSourceTypeCamera];
            camera.allowsEditing=YES;
            [camera setDelegate:self];
            [self presentViewController:camera animated:YES completion:nil];
        }
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *photoLibrary=[[UIImagePickerController alloc]init];
            [photoLibrary setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            photoLibrary.allowsEditing=YES;
            [photoLibrary setDelegate:self];
            [self presentViewController:photoLibrary animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancenl = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [addPetImageOptions addAction:camera];
    [addPetImageOptions addAction:library];
    [addPetImageOptions addAction:cancenl];
    
    [self presentViewController:addPetImageOptions animated:YES completion:^{
        self.addPetImage = YES;
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat w=400.0;
    CGFloat h=400.0/chosenImage.size.width * chosenImage.size.height;
    UIImage *croppedImage = [chosenImage imagescaledToSize:CGSizeMake(w, h)];
    self.petImageToUpload = croppedImage;
    [self.addPetView.petImageProfile setImage:croppedImage forState:UIControlStateNormal];
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}


- (void)didAddPet:(AddPetRequestModel *)request {
    [MBProgressHUD showHUDAddedTo:self.addPetView animated:YES];
    if (!request.petName || [request.petName isEqualToString:@""]) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet name cannot be empty"];
        return;
    } else if (!request.petSex) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet sex cannot be empty"];
        return;
    } else if (!request.petType || !request.petBreed) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet's type and breed cannot be empty"];
        return;
    } else  if (!request.petBirthday) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet's birthday cannot be empty"];
        return;
    }
    [self.addPetView.submitBtn setEnabled:NO];
    
    if (request.petID) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Did Update Pet Information"
                                                               label:@"Did Update Pet Information"
                                                               value:nil] build]];
        [Flurry logEvent:@"Did Update Pet Information"];
        [[UserManager defaultManager] updatePet:request.petID info:request andProfile:UIImageJPEGRepresentation(self.petImageToUpload, 0.75) andSuccess:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UserManager defaultManager] getLatestCurrentUserInfo];
                [MBProgressHUD hideHUDForView:self.addPetView animated:YES];
                [self.tableView reloadData];
                [self.addPetView removeFromSuperview];
                [self.addPetView.submitBtn setEnabled:YES];
            });
        } andError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.addPetView animated:YES];
            [self.addPetView.submitBtn setEnabled:YES];
        }];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Did Add Pet Information"
                                                               label:@"Did Add Pet Information"
                                                               value:nil] build]];
        [Flurry logEvent:@"Did Add Pet Information"];
        [[UserManager defaultManager] addPet:request andProfile:UIImageJPEGRepresentation(self.petImageToUpload, 0.75) andSuccess:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UserManager defaultManager] getLatestCurrentUserInfo];
                [MBProgressHUD hideHUDForView:self.addPetView animated:YES];
                [self.addPetView.submitBtn setEnabled:YES];
                [self.addPetView removeFromSuperview];
                self.petArray = [[UserManager defaultManager] currentUser].pets;
                if (self.petArray.count == 0) {
                    [self addEmptyPage];
                } else {
                    [self.emptyView removeFromSuperview];
                }
                [self.tableView reloadData];
            });
        } andError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.addPetView animated:YES];
            [self.addPetView.submitBtn setEnabled:YES];
        }];
    }
    
}


- (void)closeAddPet {
    [self.addPetView removeFromSuperview];
}

#pragma mark - Table View Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.petArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.petArray.count) {
        PetTableViewCell *cell = (PetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PetCell" forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[PetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PetCell"];
        }
        [cell bindData:self.petArray[indexPath.row] indexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else {
        AddPetTableViewCell *cell = (AddPetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddPetCell" forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[AddPetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPetCell"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.petArray.count) {
        return 145;
    } else {
        return 370;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.petArray.count) {
        [self showAddPetView:nil];
    }
}

- (void)didClickEditBtn:(NSIndexPath *)indexPath {
    [self showAddPetView:self.petArray[indexPath.row]];
}

@end
