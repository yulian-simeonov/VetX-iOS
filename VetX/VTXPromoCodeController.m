//
//  VTXPromoCodeController.m
//  VetX
//
//  Created by Mac on 09/08/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXPromoCodeController.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "Masonry.h"
#import "Constants.h"
#import "SCLAlertView.h"
#import "VXPaymentManager.h"
#import "ButtonCell.h"
#import <Braintree/BraintreeUI.h>
#import <AVFoundation/AVFoundation.h>
#import "VTXChatManager.h"
#import "VTXVideoAndChatConfirmationView.h"
#import "VTXAddQuestionView.h"
#import "VTXConfirmationView.h"

@interface VTXPromoCodeController () <UITableViewDelegate, UITableViewDataSource, BTDropInViewControllerDelegate, VTXVideoAndChatConfirmationViewDelegate>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *continuePaymentButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *promocodeButton;

@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) NSString *braintreeToken;
@property (nonatomic, strong) VTXVideoAndChatConfirmationView *oneOnOneConfirmation;

@end

@implementation VTXPromoCodeController {
    NSDictionary *promoDict;
    NSString *promoCode;
    long videoConsultationAmount;
    long textConsultationAmount;
    NSString *totalAmountToPay;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    videoConsultationAmount = 15;
    textConsultationAmount = 10;
    
    totalAmountToPay = [[NSString alloc] init];
    promoDict = [[NSDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:@"Promo Code"];
    self.hidesBottomBarWhenPushed = true;
    [self.navigationController setNavigationBarHidden:false];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Prmo Code Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"promo_code_screen" timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"promo_code_screen" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    if (!self.continuePaymentButton) {
        self.continuePaymentButton = [[UIButton alloc] init];
        self.continuePaymentButton.backgroundColor = [UIColor orangeColor];
        [self.continuePaymentButton setTitle:@"Continue to payment" forState:UIControlStateNormal];
        [self.continuePaymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.continuePaymentButton addTarget:self action:@selector(continueToPaymentTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.continuePaymentButton.titleLabel setFont:VETX_FONT_MEDIUM_17];
        [self.view addSubview:self.continuePaymentButton];
        [self.continuePaymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.equalTo(@44);
        }];
    }
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.tableView registerClass:[ButtonCell class] forCellReuseIdentifier:@"ButtonCell"];
        [self.view addSubview:self.tableView];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.continuePaymentButton.mas_top);
        }];
    }
    
    if (!self.promocodeButton) {
        self.promocodeButton = [[UIButton alloc] init];
        [self.promocodeButton.titleLabel setFont:VETX_FONT_MEDIUM_15];
        [self.promocodeButton setTitle:@"Have a promo code?" forState:UIControlStateNormal];
        [self.promocodeButton setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
        self.promocodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.promocodeButton.backgroundColor = [UIColor clearColor];
        [self.promocodeButton addTarget:self action:@selector(promocodeTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.footerView) {
        self.footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [self.footerView addSubview:self.promocodeButton];
        self.tableView.tableFooterView = self.footerView;
        [self.promocodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.footerView.mas_centerX);
            make.centerY.equalTo(self.footerView.mas_centerY);
            make.height.equalTo(@25);
            make.width.equalTo(@(SCREEN_WIDTH/2));
        }];
    }
    
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] init];
        self.activityIndicator.tintColor = [UIColor darkGrayColor];
        self.activityIndicator.color = [UIColor darkGrayColor];
        self.activityIndicator.hidesWhenStopped = true;
        [self.view addSubview:self.activityIndicator];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
        }];
    }
}

- (void)continueToPaymentTapped {
    if ([self.isVideo boolValue]) {
        [self checkVideoPermission];
    } else {
        [self getBraintreeToken];
    }
}

- (void)promocodeTapped {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = ORANGE_THEME_COLOR;
    
    UITextField *textField = [alert addTextField:@"Enter promo code"];
    
    [alert addButton:@"Apply promo code" actionBlock:^{
        if (textField.text.length > 0) {
            [self.activityIndicator startAnimating];
            [[VXPaymentManager defaultManager] postPromoCode:textField.text WithCompletion:^(BOOL success, NSDictionary *result) {
                [self.activityIndicator stopAnimating];
                if (success) {
                    promoDict = result[@"items"];
                    promoCode = textField.text;
                    [self.tableView reloadData];
                } 
            }];
        } else {
            SCLAlertView *alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:300.0f];
            alert1.customViewColor = ORANGE_THEME_COLOR;
            [alert1 showQuestion:self title:@"Error" subTitle:@"Please Enter atleat 3 characters for promo code" closeButtonTitle:@"OK" duration:0.0f]; // Info
            return;
        }
    }];
    
    [alert showEdit:self title:@"Promo code?" subTitle:@"Please enter promo code" closeButtonTitle:@"Cancel" duration:0.0f];
}

- (void)deletePromocodeTapped {
    promoDict = nil;
    promoCode = nil;
    [self.tableView reloadData];
}

- (void)checkVideoPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) { // authorized
        [self getBraintreeToken];
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
        [self askForVideoPermission];
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        [self askForVideoPermission];
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something
                [self getBraintreeToken];
            } else { // Access denied ..do something
                [self askForVideoPermission];
            }
        }];
    }
}

- (void)askForVideoPermission {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Access Camera?" message:@"VetX needs to access your camera to process the 1-on-1 video consultation with our vet." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction *give = [UIAlertAction actionWithTitle:@"Give Access" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    [alert addAction:ok];
    [alert addAction:give];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)getBraintreeToken {
    [[VXPaymentManager defaultManager] getBraintreeTokenWithCompletion:^(BOOL success, NSDictionary *result) {
        if (success) {
            self.braintreeToken = [result objectForKey:@"token"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self openPaymentPage:self.isVideo];
            });
        }
    }];
}

- (void)openPaymentPage:(NSNumber *)isVideo {
    
    // If you haven't already, create and retain a `BTAPIClient` instance with a tokenization
    // key or a client token from your server.
    // Typically, you only need to do this once per session.
    if (!self.braintreeToken) {
        //!!!: Show error alert
        return;
    }
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:self.braintreeToken];
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    dropInViewController.paymentRequest.summaryTitle = @"One-on-One Consultation";
    if ([isVideo isEqual:@1]) {
        [Flurry logEvent:@"Start One on One - Video" withParameters:@{@"isVideo":isVideo}];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Start One on One - Video"
                                                               label:@"Start One on One - Video"
                                                               value:isVideo] build]];
        dropInViewController.paymentRequest.summaryDescription = @"Video consultation with one veterinary.";
        dropInViewController.paymentRequest.displayAmount = totalAmountToPay;
    } else {
        [Flurry logEvent:@"Start One on One - Video" withParameters:@{@"isVideo":isVideo}];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Start One on One - Chat"
                                                               label:@"Start One on One - Chat"
                                                               value:isVideo] build]];
        dropInViewController.paymentRequest.summaryDescription = @"Text consultation with one veterinary.";
        dropInViewController.paymentRequest.displayAmount = totalAmountToPay;
    }
    
    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Cancel Payment"
                                                           label:@"Cancel Payment"
                                                           value:nil] build]];
    [Flurry logEvent:@"Cancel Payment"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - BTDropInViewControllerDelegate
- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Checkout"
                                                           label:@"Checkout"
                                                           value:nil] build]];
    [Flurry logEvent:@"Checkout"];
    NSString *chatType = @"text";
    if ([self.isVideo isEqual:@1]) {
        chatType = @"video";
    }
    if (!promoCode || [promoCode  isEqual: @""]) {
        promoCode = @"";
    }
    [[VXPaymentManager defaultManager] postNonceToServer:paymentMethodNonce.nonce promocode:promoCode type:chatType completion:^(BOOL success, NSDictionary *result) {
        if (success) {
            NSString *transactionID = [result objectForKey:@"id"];
            NSAssert(transactionID, @"Transaction ID is Nil");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.isVideo isEqual:@1]) {
                        // Start Video Call
                        [self getTwilioToken:transactionID];
                    } else {
                        [self getFirebaseToke:transactionID];
                    }
                }];
            });
        } else {
            // Show alert for checkout error
        }
    }];
}

- (void)getFirebaseToke:(NSString *)transactionID {
    NSString *question = [self.questionTitleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[VTXChatManager defaultManager] getFirebaseTokenWithQuestion:question transaction:transactionID completion:^(BOOL success, NSDictionary *result) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addConsultationConfirmationView:@"chat"];
            });
        }
    } error:^(NSError *error) {
        
    }];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Cancel Payment"
                                                           label:@"Cancel Payment"
                                                           value:nil] build]];
    [Flurry logEvent:@"Cancel Payment"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getTwilioToken:(NSString *)transactionID {
    NSString *question = [self.questionTitleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[VTXChatManager defaultManager] getTwilioTokenWithQuestion:question transaction:transactionID completion:^(BOOL success, NSDictionary *result) {
        if (success) {
            // Go to video chat page.
            if ([self.isVideo isEqual:@1]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addConsultationConfirmationView:@"video"];
                });
            }
        }
    } error:^(NSError *error) {
        
    }];
}

- (void)addConsultationConfirmationView:(NSString *)type {
    if (!self.oneOnOneConfirmation) {
        self.oneOnOneConfirmation = [[VTXVideoAndChatConfirmationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    if ([type isEqualToString:@"chat"]) {
        [self.oneOnOneConfirmation setOneOnOneConfirmationType:ConsultationChat];
    } else {
        [self.oneOnOneConfirmation setOneOnOneConfirmationType:ConsultationVideo];
    }
    self.oneOnOneConfirmation.delegate = self;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [[[window subviews] objectAtIndex:0] addSubview:self.oneOnOneConfirmation];
}

- (void)didClickConfirm {
    [self.oneOnOneConfirmation removeFromSuperview];
    [self goBack];
}

- (void)goBack {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- TableView datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (promoDict[@"discount"]) {
        self.tableView.tableFooterView.hidden = true;
        return 5;
    } else {
        self.tableView.tableFooterView.hidden = false;
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ButtonCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.leftButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [cell.leftButton.titleLabel setFont:VETX_FONT_MEDIUM_14];
    cell.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [cell.rightButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [cell.rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [cell.rightButton.titleLabel setFont:VETX_FONT_MEDIUM_14];
    cell.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    if (indexPath.section == 0) {
        [cell.leftButton setTitle: @"ONE-ON-ONE Consultation" forState:UIControlStateNormal];
        if ([self.isVideo boolValue]) {
            totalAmountToPay = [NSString stringWithFormat:@"%ld", videoConsultationAmount];
            [cell.rightButton setTitle: [NSString stringWithFormat:@"$%ld", videoConsultationAmount] forState:UIControlStateNormal];
        } else {
            totalAmountToPay = [NSString stringWithFormat:@"%ld", textConsultationAmount];
            [cell.rightButton setTitle: [NSString stringWithFormat:@"$%ld", textConsultationAmount] forState:UIControlStateNormal];
        }
    } else if (indexPath.section == 1) {
        [cell.leftButton.titleLabel setFont:VETX_FONT_REGULAR_14];
        [cell.rightButton setTitle:@"" forState:UIControlStateNormal];
        if ([self.isVideo boolValue]) {
            [cell.leftButton setTitle: @"Video consultation with one veterinary" forState:UIControlStateNormal];
        } else {
            [cell.leftButton setTitle: @"Text Consultation with one veterinary" forState:UIControlStateNormal];
        }
        
    } else if (indexPath.section == 2) {
        [cell.leftButton setTitle: @"Discount amount" forState:UIControlStateNormal];
        [cell.rightButton setTitle: [NSString stringWithFormat:@"- $%@", promoDict[@"discount"]] forState:UIControlStateNormal];
    } else if (indexPath.section == 3) {
        [cell.leftButton setTitle:  @"Payable amount" forState:UIControlStateNormal];
        totalAmountToPay = [NSString stringWithFormat: @"$%d", 10 - [promoDict[@"discount"] intValue]];
        [cell.rightButton setTitle: totalAmountToPay forState:UIControlStateNormal];
    } else if (indexPath.section == 4) {
        cell.leftButton.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
        cell.leftButton.backgroundColor = [UIColor lightGrayColor];
        cell.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [cell.leftButton setTitle:  promoCode forState:UIControlStateNormal];
        [cell.rightButton setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
        [cell.rightButton addTarget:self action:@selector(deletePromocodeTapped) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

#pragma end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
