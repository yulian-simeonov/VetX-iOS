//
//  EditProfileViewController.m
//  VetX
//
//  Created by YulianMobile on 1/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "EditProfileView.h"
#import "UserManager.h"
#import "UserRequestModel.h"
#import "SCLAlertView.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "UIImage+ImageOperations.h"
#import "UIButton+AFNetworking.h"


@interface EditProfileViewController () <EditProfileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) UIImage *profileImageToUpload;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) EditProfileView *editView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Edit Profile Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"edit_profile" timed:YES];
    [self bindData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"edit_profile" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view setBackgroundColor:POST_QUESTION_BACKGROUND];
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        [self.headerView setBackgroundColor:ORANGE_THEME_COLOR];
        [self.view addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.right.equalTo(self.view);
            make.height.equalTo(@64);
        }];
    }
    
    if (!self.closeBtn) {
        self.closeBtn = [[UIButton alloc] init];
        [self.closeBtn setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closeBtn.titleLabel setFont:VETX_FONT_BOLD_15];
        [self.closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView).offset(10);
            make.left.equalTo(self.headerView).offset(20);
        }];
    }
    
    if (!self.submitBtn) {
        self.submitBtn = [[UIButton alloc] init];
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitBtn setTitle:@"Save" forState:UIControlStateNormal];
        [self.submitBtn.titleLabel setFont:VETX_FONT_BOLD_15];
        [self.submitBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerView).offset(-20);
            make.centerY.equalTo(self.closeBtn);
        }];
    }
    
    if (!self.editView) {
        self.editView = [[EditProfileView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.editView.delegate = self;
        [self.view addSubview:self.editView];
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.bottom.and.right.equalTo(self.view);
        }];
    }
}

- (void)closeBtnClicked {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Close Edit Profile View"
                                                           label:@"Close Edit Profile View"
                                                           value:nil] build]];
    [Flurry logEvent:@"Close Edit Profile View"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didClickAddProfileBtn {
    [self addProfileImage];
}

- (void)saveBtnClicked {
    // Save data and then dismiss view
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Save Profile"
                                                           label:@"Save Profile"
                                                           value:nil] build]];
    [Flurry logEvent:@"Save Profile"];
    
    UserRequestModel *request = [[UserRequestModel alloc] init];
    NSString *firstName = [self.editView.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.editView.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.editView.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *bio = [self.editView.userBio.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    request.firstName = firstName;
    request.lastName = lastName;
    request.email = email;
    if (![bio isEqualToString:@"Tell us something about yourself..."]) {
        request.userBio = bio;
    }
    [[UserManager defaultManager] updateUserProfile:request image:UIImageJPEGRepresentation(self.profileImageToUpload, 0.75) andSuccess:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
    } andError:^(NSError *error) {
        [self showErrorAlertWithTitle:@"Update Profile Error" message:@"Fail to update your profile, please try again."];
    }];
}

- (void)bindData {
    if (![[UserManager defaultManager] currentUser]) {
        return;
    }
    NSString *firstName = [[UserManager defaultManager] currentUser].firstName;
    NSString *lastName = [[UserManager defaultManager] currentUser].lastName;
    NSString *email = [[UserManager defaultManager] currentUser].emailAddress;
    NSString *bio = [[UserManager defaultManager] currentUser].bio;
    [self.editView.firstNameField setText:firstName];
    [self.editView.lastNameField setText:lastName];
    [self.editView.emailField setText:email];
    if (bio && ![bio isEqualToString:@""]) {
        [self.editView.userBio setText:bio];
    }
    [self.editView.profileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[[UserManager defaultManager] currentUser].profileURL] placeholderImage:[UIImage imageNamed:@"Profile_Placeholder"]];
}


- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}


- (void)addProfileImage {

    
    UIAlertController *addImageOptions = [UIAlertController alertControllerWithTitle:@"Upload Image" message:@"Add an image for your question" preferredStyle:UIAlertControllerStyleActionSheet];
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
        [addImageOptions dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [addImageOptions addAction:camera];
    [addImageOptions addAction:library];
    [addImageOptions addAction:cancenl];
    [self presentViewController:addImageOptions animated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Add Profile Image"
                                                           label:@"Add Profile Image"
                                                           value:nil] build]];
    [Flurry logEvent:@"Add Profile Image"];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat w=400.0;
    CGFloat h=400.0/chosenImage.size.width * chosenImage.size.height;
    UIImage *croppedImage = [chosenImage imagescaledToSize:CGSizeMake(w, h)];
    self.profileImageToUpload = croppedImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.editView.profileImage setImage:croppedImage forState:UIControlStateNormal];
    });
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

@end
