//
//  SignUpLoginViewController.m
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "SignUpLoginViewController.h"
#import "Masonry.h"
#import "Constants.h"
#import "LoginView.h"
#import "NSString+EmailVerification.h"
#import "SCLAlertView.h"
#import "SignUpView.h"
#import "UserRequestModel.h"
#import "UserManager.h"
#import "UIImage+ImageOperations.h"
#import "M13Checkbox.h"
#import "BottomTabBarController.h"
#import <Google/Analytics.h>
#import "Flurry.h"
@import SafariServices;

@interface SignUpLoginViewController () <LoginViewDelegate, SingupViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate>

// Variables
@property (nonatomic, assign) BOOL loginAsVet;
@property (nonatomic, assign) UIImage *profileImageToUpload;

// Views
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) SignUpView *signupView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

// Model
@property (nonatomic, strong) UserRequestModel *registerUser;
@property (nonatomic, strong) UserRequestModel *loginUserRequest;

@end

@implementation SignUpLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.loginAsVet = NO;
    [self.view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Sign up & login Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"signup_login" timed:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"sinup_login" withParameters:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    
    if (!self.backgroundView) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
        [self.view addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (!self.signupView) {
        self.signupView = [[SignUpView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.signupView.delegate = self;
        [self.signupView setHidden:YES];
        [self.view addSubview:self.signupView];
        [self.signupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }

    if (!self.loginView) {
        self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView];
        [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark - User Model Delegate 
- (void)didCreateUser:(BOOL)success {
    if (!success) {
        [self showSuccessAlertWithTitle:@"Success" message:@"Create new account successfully"];
    } else {
        [self showErrorAlertWithTitle:@"Error" message:@"Fail to create new account"];
    }
//    [self closeSignupView];
    [self dismissSignupView];

}

#pragma mark - Alert

- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}

- (void)showSuccessAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showSuccess:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - Signup View Delegate

- (void)closeSignupView {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_press"
                                                           label:@"close_signup_login"
                                                           value:nil] build]];

    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[UserManager defaultManager] currentUser].licenseID && ![[[UserManager defaultManager] currentUser].licenseID isEqualToString:@""]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            BottomTabBarController *bottomVC = [[BottomTabBarController alloc] initWithVetMainViews];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bottomVC];
            [nav setNavigationBarHidden:YES];
            [window setRootViewController:nav];
            [window makeKeyAndVisible];
        }
    }];
}

- (void)dismissSignupView {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Close Signup and Login View"
                                                           label:@"Close Signup and Login View"
                                                           value:nil] build]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UserManager defaultManager] currentUser].licenseID && ![[[UserManager defaultManager] currentUser].licenseID isEqualToString:@""]) {
        [self showVetAlert];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                //        if ([[UserManager defaultManager] currentUser].licenseID && ![[[UserManager defaultManager] currentUser].licenseID isEqualToString:@""]) {
                //            [self showVetAlert];
                //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                //            BottomTabBarController *bottomVC = [[BottomTabBarController alloc] initWithVetMainViews];
                //            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bottomVC];
                //            [nav setNavigationBarHidden:YES];
                //            [window setRootViewController:nav];
                //            [window makeKeyAndVisible];
                //        }
            }];
        }
    });
}

- (void)showVetAlert {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"OK" actionBlock:^(void) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }];

    [alert showNotice:self title:@"Thank you" subTitle:@"Thank you for your application to join VetX as a veterinarian!" closeButtonTitle:@"OK" duration:0.0];
}

- (void)backToLogin {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Close Signup View"
                                                           label:@"Close Signup View"
                                                           value:nil] build]];
    [Flurry logEvent:@"Close Signup View"];
    [self.loginView setHidden:NO];
    [self.loginView setAlpha:0.0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.signupView setAlpha:0.0];
        [self.loginView setAlpha:1.0];
    }];
}


- (void)signupUser {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Open Signup View"
                                                           label:@"Open Signup View"
                                                           value:nil] build]];
    [Flurry logEvent:@"Open Signup View"];
    
    [self.signupView setHidden:NO];
    [self.signupView setAlpha:0.0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.signupView setAlpha:1.0];
        [self.loginView setAlpha:0.0];
    }];
}

- (void)signupWithFB:(NSString *)fbToken {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Signup with Facebook"
                                                           label:@"Signup with Facebook"
                                                           value:nil] build]];
    [Flurry logEvent:@"Signup with Facebook"];
    [[UserManager defaultManager] signupWithFB:fbToken andSuccess:^(BOOL success) {
        if (success) {
            [self closeSignupView];
        }
    } andError:^(NSError *error) {
        
    }];
}

- (void)loginUser {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Open Login View"
                                                           label:@"Open Login View"
                                                           value:nil] build]];
    [Flurry logEvent:@"Open Login View"];
    
    [self.loginView setAlpha:0.0];
    [self.loginView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.signupView setAlpha:0.0];
        [self.loginView setAlpha:1.0];
    }];
}


- (void)createUser:(NSNumber *)isVet {
    self.registerUser = [[UserRequestModel alloc] init];
    
    self.registerUser.firstName = [[self.signupView.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] capitalizedString];
    self.registerUser.lastName = [[self.signupView.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] capitalizedString];
    if ([self.registerUser.firstName isEqualToString:@""] ||
        [self.registerUser.lastName isEqualToString:@""]) {
        [self showErrorAlertWithTitle:@"Error" message:@"Please input your First and Last name."];
        return;
    }
    self.registerUser.email = [self.signupView.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![self.registerUser.email validateEmail]) {
        [self showErrorAlertWithTitle:@"Error" message:@"Please input the right email address."];
        return;
    }
    self.registerUser.password = [self.signupView.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.registerUser.confirmPassword = [self.signupView.confirmField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.registerUser.password.length < 6) {
        [self showErrorAlertWithTitle:@"Error" message:@"Please input a password with at least 6 characters."];
        return;
    }
    
    if (![self.registerUser.password isEqualToString:self.registerUser.confirmPassword]) {
        [self showErrorAlertWithTitle:@"Error" message:@"The passwords you input don't match."];
        return;
    }
    
    if ([isVet isEqual:@1]) {
        self.registerUser.isVet = @"isVet";
        self.registerUser.vetLicenseID = [self.signupView.vetLicense.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.registerUser.clinicID = @"vetx";
        if ([self.registerUser.vetLicenseID isEqualToString:@""] ||
            self.registerUser.vetLicenseID.length < 6) {
            [self showErrorAlertWithTitle:@"Error" message:@"Please input a valid license number."];
            return;
        }
    }
    NSData *imageData = UIImageJPEGRepresentation(self.profileImageToUpload, 0.75);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Did Register New User"
                                                           label:@"Did Register New User"
                                                           value:nil] build]];
    [Flurry logEvent:@"Did Register New User"];
    
    [[UserManager defaultManager] registerUser:self.registerUser
                                         photo:imageData
                                    andSuccess:^(BOOL finished) {
        if (finished) {
            [self dismissSignupView];
        }
    } andError:^(NSError *error) {
        if (error) {
            if ([[error localizedDescription] isEqualToString:@"Request failed: found (302)"]) {
                [self showErrorAlertWithTitle:@"Register Error" message:[NSString stringWithFormat:@"Fail to register new account: email has been registered"]];
            } else {
                [self showErrorAlertWithTitle:@"Register Error" message:[NSString stringWithFormat:@"Fail to register new account, please check your input and try again."]];
            }
            
        }
    }];
}

#pragma mark - Login View Delegate
- (void)didGoBack {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didLogin {
    [self.view endEditing:YES];
    self.loginUserRequest = [[UserRequestModel alloc] init];
    self.loginUserRequest.email = [self.loginView.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.loginUserRequest.password = [self.loginView.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![self.loginUserRequest.email validateEmail]) {
        [self showErrorAlertWithTitle:@"Error" message:@"Please input the right email address."];
        return;
    }
    
    if (self.loginUserRequest.password.length < 6) {
        [self showErrorAlertWithTitle:@"Error" message:@"Please input a password with at least 6 characters."];
        return;
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Did Login User"
                                                           label:@"Did Login User"
                                                           value:nil] build]];
    [Flurry logEvent:@"Did Login User"];
    
    [[UserManager defaultManager] loginUser:self.loginUserRequest andSuccess:^(BOOL finished) {
        if (finished) {
            
            [self closeSignupView];
        }
    } andError:^(NSError *error) {
        if (error) {
            [self showErrorAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"Login in error, please check your email and password."]];
        }
    }];
}

- (void)openTerms:(NSURL *)url {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:NO];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:NO completion:nil];
}

- (void)didClickForgotPassword {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Forgot Password"
                                                           label:@"Forgot Passwrod"
                                                           value:nil] build]];
    [Flurry logEvent:@"Forgot Password"];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = ORANGE_THEME_COLOR;

    UITextField *textField = [alert addTextField:@"Enter your email"];
    
    [alert addButton:@"Forgot" actionBlock:^(void) {
        [[UserManager defaultManager] forgotPassword:textField.text];
    }];
    
    [alert showEdit:self title:@"Forgot Password?" subTitle:@"Please input your email address, we will send a temporary password to you." closeButtonTitle:@"Cancel" duration:0.0f];
}

#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    // Load finished
}
-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // Done button pressed
}

- (void)addProfileImage {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Add Profile Image When Register"
                                                           label:@"Add Profile Image When Register"
                                                           value:nil] build]];
    [Flurry logEvent:@"Add Profile Image When Register"];
    
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
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat w=400.0;
    CGFloat h=400.0/chosenImage.size.width * chosenImage.size.height;
    UIImage *croppedImage = [chosenImage imagescaledToSize:CGSizeMake(w, h)];
    self.profileImageToUpload = croppedImage;
    [self.signupView.profileImage setImage:croppedImage forState:UIControlStateNormal];
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

@end
