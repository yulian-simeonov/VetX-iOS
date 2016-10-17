//
//  VTXVetOneOnOneViewController.m
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXVetOneOnOneViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "Consultation.h"
#import "VTXTopSegmentedControl.h"
#import "UserManager.h"
#import "QuestionManager.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "PendingChatTableViewCell.h"
#import "SignUpLoginViewController.h"
#import "VTXChatManager.h"
#import "VTXVideoViewController.h"
#import "VTXChatViewController.h"
#import <TwilioConversationsClient/TwilioConversationsClient.h>
#import "ConsultationRequestTableViewCell.h"
#import <SCLAlertView_Objective_C/SCLAlertView.h>
#import "VTXEmptyView.h"

@interface VTXVetOneOnOneViewController () <UITableViewDelegate, UITableViewDataSource, VTXSegmentedControlDelegate, PendingChatTableViewCellDelegate, TwilioConversationsClientDelegate, TWCConversationDelegate, TwilioAccessManagerDelegate, VTXEmptyViewDelegate>

@property (nonatomic, strong) UIView *topStatusView;
@property (nonatomic, strong) SignUpLoginViewController *signupVC;
@property (nonatomic, strong) VTXTopSegmentedControl *menu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *answeredTableView;
@property (nonatomic, strong) VTXEmptyView *emptyView;

@property (nonatomic, strong) RLMResults<Consultation *> *unansweredChat;
@property (nonatomic, strong) RLMResults<Consultation *> *answeredChat;

@property (nonatomic) TwilioConversationsClient *conversationsClient;

@end

@implementation VTXVetOneOnOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationReceived:) name:@"pushNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Vet One on one Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"vet_one_on_one" timed:YES];
    
    if ([[UserManager defaultManager] currentUser]) {
        [self getConsultationData];
        [self queryData];
        [self reloadData];
    } else {
        [self presendtSignupLogin];
        [self addEmptyPage];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myNotificationReceived:(NSNotification *)notification {
    if (![[notification.userInfo objectForKey:@"type"] isEqualToString:@"general"]) {
        [self queryData];
        [self getConsultationData];
    }
}

- (void)setupView {
    [self.view setBackgroundColor:FEED_BACKGROUND_COLOR];
    
    if (!self.topStatusView) {
        self.topStatusView = [[UIView alloc] init];
        [self.topStatusView setBackgroundColor:ORANGE_THEME_COLOR];
        [self.view addSubview:self.topStatusView];
        [self.topStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.top.left.and.right.equalTo(self.view);
        }];
    }
    
    if (!self.menu) {
        self.menu = [[VTXTopSegmentedControl alloc] initWithItems:@[@"Requests", @"In Progress"]];
        [self.menu setBackgroundColor:[UIColor whiteColor]];
        [self.menu setSelectedSegmentIndex:0];
        [self.menu setFont:VETX_FONT_REGULAR_15];
        [self.menu setAutoAdjustSelectionIndicatorWidth:NO];
        [self.menu setTintColor:ORANGE_THEME_COLOR];
        [self.menu setTitleColor:FEED_CELL_TITLE_COLOR forState:UIControlStateNormal];
        [self.menu setTitleColor:ORANGE_THEME_COLOR forState:UIControlStateSelected];
        [self.menu setShowsCount:NO];
        [self.menu addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.menu];
        [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.and.right.equalTo(self.view);
            make.height.equalTo(@44);
        }];
    }
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView registerClass:[ConsultationRequestTableViewCell class] forCellReuseIdentifier:@"ConsultationRequestCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.menu.mas_bottom);
        }];
    }
    
    if (!self.answeredTableView) {
        self.answeredTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.answeredTableView.delegate = self;
        self.answeredTableView.dataSource = self;
        [self.answeredTableView setHidden:YES];
        self.answeredTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.answeredTableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.answeredTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.answeredTableView registerClass:[ConsultationRequestTableViewCell class] forCellReuseIdentifier:@"AnsweredChatCell"];
        [self.view addSubview:self.answeredTableView];
        [self.answeredTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.menu.mas_bottom);
        }];
        
    }
}


- (void)addEmptyPage {
    if (!self.emptyView) {
        self.emptyView = [[VTXEmptyView alloc] init];
        [self.emptyView setEmptyScreenType:EmptyAnswers];
        self.emptyView.delegate = self;
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menu.mas_bottom);
            make.left.right.and.bottom.equalTo(self.view);
        }];
    }
}

- (void)didClickBtn {
    [self.tabBarController setSelectedIndex:0];
}

- (void)checkVideoPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
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

- (void)queryData {
    __weak typeof(self) weakSelf = self;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished = NO AND vet = nil"];
    [[Consultation objectsWithPredicate:predicate] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"created" ascending:YES];
            strongSelf.unansweredChat = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reloadData];
                [strongSelf.tableView reloadData];
            });
        }
    }];
    NSPredicate *predicated2 = [NSPredicate predicateWithFormat:@"finished = NO AND vet != nil AND type = %@", @"text"];
    [[Consultation objectsWithPredicate:predicated2] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"created" ascending:YES];
            strongSelf.answeredChat = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reloadData];
                [strongSelf.tableView reloadData];
            });
        }
    }];
    [self reloadData];
}

- (void)reloadData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished = NO AND vet = nil"];
    self.unansweredChat = [[Consultation  objectsWithPredicate:predicate] sortedResultsUsingProperty:@"created" ascending:NO];
    NSPredicate *predicated2 = [NSPredicate predicateWithFormat:@"finished = NO AND vet != nil AND type = %@", @"text"];
    self.answeredChat = [[Consultation  objectsWithPredicate:predicated2] sortedResultsUsingProperty:@"created" ascending:NO];
    [self.tableView reloadData];
    [self.answeredTableView reloadData];
    if (self.answeredChat.count != 0 || self.unansweredChat.count != 0) {
        [self.emptyView removeFromSuperview];
    } else {
        [self addEmptyPage];
    }
}


#pragma mark - Signup & Login

- (void)presendtSignupLogin {
    
    self.signupVC = [[SignUpLoginViewController alloc] init];
    self.signupVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.signupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [self presentViewController:self.signupVC animated:YES completion:^{
        
    }];
    
}

- (void)getConsultationData {
    __weak typeof(self) weakSelf = self;
    [[QuestionManager defaultManager] getUnansweredChatGroup:nil complete:^(BOOL finished, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reloadData];
        });
    }];
    [[QuestionManager defaultManager] getConsultationHistory:[[UserManager defaultManager] currentUserID] complete:^(BOOL finished, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reloadData];
        });
    }];
}

#pragma mark - Dropdown menu delegate

- (void)selectedSegment:(VTXTopSegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Vet One on One Request"
                                                               label:@"Vet One on One Request"
                                                               value:nil] build]];
        [Flurry logEvent:@"Vet One on One Request"];
        [self.tableView setHidden:NO];
        [self.answeredTableView setHidden:YES];
        [self.answeredTableView reloadData];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Vet One on One In Progress"
                                                               label:@"Vet One on One In Progress"
                                                               value:nil] build]];
        [Flurry logEvent:@"Vet One on One In Progress"];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
        [self.answeredTableView setHidden:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.answeredTableView) {
        return self.answeredChat.count;
    } else {
        return self.unansweredChat.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (tableView == self.answeredTableView) {
            ConsultationRequestTableViewCell *cell = (ConsultationRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AnsweredChatCell"];
            if (!cell) {
                cell = [[ConsultationRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnsweredChatCell"];
            }
            [cell bindWithUserData:[self.answeredChat objectAtIndex:indexPath.row] indexPath:indexPath];
            return cell;
        } else {
            ConsultationRequestTableViewCell *cell = (ConsultationRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ConsultationRequestCell"];
            if (!cell) {
                cell = [[ConsultationRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PendingChatCell"];
            }
            [cell bindWithUserData:[self.unansweredChat objectAtIndex:indexPath.row] indexPath:indexPath];
            return cell;
        }
    } @catch (NSException *exception) {
        if ([[UserManager defaultManager] currentUser]) {
            [self getConsultationData];
            [self queryData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setAllowsSelection:NO];
    @try {
        Consultation *consultation;
        if (tableView == self.answeredTableView) {
            consultation = [self.answeredChat objectAtIndex:indexPath.row];
        } else {
            consultation = [self.unansweredChat objectAtIndex:indexPath.row];
        }
        [self joinInChatGroup:consultation];
    } @catch (NSException *exception) {
        if ([[UserManager defaultManager] currentUser]) {
            [self getConsultationData];
            [self queryData];
        }
    }
}

#pragma mark - Pending Chat Table Cell Delegate
- (void)didClickReplyBtn:(NSIndexPath *)indexPath {
    @try {
        Consultation *consultation = [self.unansweredChat objectAtIndex:indexPath.row];
        [self joinInChatGroup:consultation];
    } @catch (NSException *exception) {
        [[VTXChatManager defaultManager] cleanConsutlationCache];
    } @finally {
        if ([[UserManager defaultManager] currentUser]) {
            [self getConsultationData];
            [self queryData];
        }
    }
}

- (void)didClickEndChatBtn:(NSIndexPath *)indexPath {
    @try {
        __weak typeof(self) weakSelf = self;
        Consultation *consultation = [self.unansweredChat objectAtIndex:indexPath.row];
        [[QuestionManager defaultManager] endConsultation:consultation.consultationID withUser:[[UserManager defaultManager] currentUserID] andSuccess:^(BOOL finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf queryData];
                    [strongSelf reloadData];
                });
            }
        } andError:^(NSError *error) {
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"Consultation not available");
        [[VTXChatManager defaultManager] cleanConsutlationCache];
    } @finally {
        if ([[UserManager defaultManager] currentUser]) {
            [self getConsultationData];
            [self queryData];
        }
    }
    
}

- (void)joinInChatGroup:(Consultation *)consultation {
    NSString *groupID = consultation.consultationID;
    if (!groupID) {
        [self showErrorAlertWithTitle:@"Error to join in consultation" message:@"Sorry, something wrong happened, please try again."];
        return;
    }
    [[VTXChatManager defaultManager] joinGroup:groupID completion:^(BOOL success, NSDictionary *result) {
        @try {
            NSString *type = [[result objectForKey:@"data"][0] objectForKey:@"type"];
            NSString *token = [result objectForKey:@"token"];
            NSString *user = [[[result objectForKey:@"data"][0] objectForKey:@"user"] objectForKey:@"id"];
            NSString *receiverID;
            if ([[result objectForKey:@"data"][0] objectForKey:@"user"]) {
                receiverID = [[[result objectForKey:@"data"][0] objectForKey:@"vet"] objectForKey:@"id"];
            } else {
                receiverID = @"";
            }
            NSString *senderID = [[UserManager defaultManager] currentUserID];
            if ([type isEqualToString:@"text"]) {
                [self gotoChatWithToken:token user:senderID receiver:receiverID group:groupID];
            } else {
                VTXVideoViewController *videoVC = [[VTXVideoViewController alloc] initWithToken:token invitee:user];
                videoVC.inviteeIdentity = user;
                videoVC.currentIdentity = [[UserManager defaultManager] currentUserID];
                [self.navigationController presentViewController:videoVC animated:YES completion:^{
                    [self.tableView setAllowsSelection:YES];
                    [self.answeredTableView setAllowsSelection:YES];
                }];
            }
        } @catch (NSException *exception) {
            // Show error alert
            [self.tableView setAllowsSelection:YES];
            [self.answeredTableView setAllowsSelection:YES];
        }
    } error:^(NSError *error) {
        [self.tableView setAllowsSelection:YES];
        [self.answeredTableView setAllowsSelection:YES];
    }];
}

- (void)gotoChatWithToken:(NSString *)token user:(NSString *)senderID receiver:(NSString *)receiver group:(NSString *)groupID {
    [[VTXChatManager defaultManager] authorizeUserWithFirebaseToken:token completion:^(BOOL success, NSDictionary *result) {
        if (success) {
            VTXChatViewController *chatVC = [[VTXChatViewController alloc] init];
            chatVC.senderId = senderID;
            chatVC.groupID = groupID;
            chatVC.receiverID = receiver;
            NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                                  [[[UserManager defaultManager] currentUser] firstName],
                                  [[[UserManager defaultManager] currentUser] lastName]];
            chatVC.senderDisplayName = fullName;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController setNavigationBarHidden:NO];
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatVC animated:YES];
                [self.tableView setAllowsSelection:YES];
                [self.answeredTableView setAllowsSelection:YES];
            });
        }
    } error:^(NSError *error) {
        //!!!: Show Error Alert here
    }];
}

- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}

@end
