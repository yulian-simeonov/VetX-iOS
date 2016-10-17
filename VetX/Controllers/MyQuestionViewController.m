//
//  MyQuestionViewController.m
//  VetX
//
//  Created by YulianMobile on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "HomeFeedTableViewCell.h"
#import "QuestionRequestModel.h"
#import "QuestionManager.h"
#import "Question.h"
#import "UserManager.h"
#import <TwilioConversationsClient/TwilioConversationsClient.h>
#import "VTXTopSegmentedControl.h"
#import "PendingChatTableViewCell.h"
#import "PendingQuestionTableViewCell.h"
#import "SignUpLoginViewController.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "VTXEmptyView.h"
#import "VTXAddQuestionViewController.h"
#import "Consultation.h"
#import "VTXChatManager.h"
#import "VTXVideoViewController.h"
#import "VTXChatViewController.h"
#import "QuestionDetailViewController.h"
#import "MBProgressHUD.h"

@interface MyQuestionViewController () <UITableViewDelegate, UITableViewDataSource, VTXSegmentedControlDelegate, VTXEmptyViewDelegate, TwilioConversationsClientDelegate, TWCConversationDelegate, TwilioAccessManagerDelegate, PendingChatTableViewCellDelegate>

@property (nonatomic, strong) SignUpLoginViewController *signupVC;
@property (nonatomic, strong) UIView *topStatusView;
@property (nonatomic, strong) VTXTopSegmentedControl *menu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *answeredTableView;
@property (nonatomic, strong) VTXEmptyView *emptyView;

@property (nonatomic, strong) RLMResults<Question *> *answered;
@property (nonatomic, strong) RLMResults<Question *> *unanswered;
@property (nonatomic, strong) RLMResults<Consultation *> *unansweredChat;
@property (nonatomic, strong) RLMResults<Consultation *> *answeredChat;

@property (nonatomic) TwilioConversationsClient *conversationsClient;


@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    if ([[UserManager defaultManager] currentUser]) {
        [self queryData];
        [self getQuestionsData];
        [self getConsultationData];
    } else {
        [self presendtSignupLogin];
        [self addEmptyPage];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationReceived:) name:@"pushNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Question History Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"question_history" timed:YES];
    
    if ([[UserManager defaultManager] currentUser]) {
        [self getQuestionsData];
        [self getConsultationData];
        [self queryData];
        [self reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"question_history" withParameters:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myNotificationReceived:(NSNotification *)notification {
    if (![[notification.userInfo objectForKey:@"type"] isEqualToString:@"general"]) {
        [self queryData];
        [self getQuestionsData];
        [self getConsultationData];
    }
}

#pragma mark - Signup & Login
- (void)presendtSignupLogin {
    
    self.signupVC = [[SignUpLoginViewController alloc] init];
    [self presentViewController:self.signupVC animated:YES completion:^{
        
    }];
    
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
        self.menu = [[VTXTopSegmentedControl alloc] initWithItems:@[@"Pending", @"Answered"]];
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.tableView registerClass:[HomeFeedTableViewCell class] forCellReuseIdentifier:@"QuestionHistoryCell"];
        [self.tableView registerClass:[PendingChatTableViewCell class] forCellReuseIdentifier:@"PendingChatCell"];
        [self.tableView registerClass:[PendingQuestionTableViewCell class] forCellReuseIdentifier:@"PendingQuestionCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.menu.mas_bottom);
        }];
    }
    
    if (!self.answeredTableView) {
        self.answeredTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        self.answeredTableView.delegate = self;
        self.answeredTableView.dataSource = self;
        [self.answeredTableView setHidden:YES];
        self.answeredTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.answeredTableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.answeredTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.answeredTableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.answeredTableView registerClass:[HomeFeedTableViewCell class] forCellReuseIdentifier:@"QuestionHistoryCell"];
        [self.view addSubview:self.answeredTableView];
        [self.answeredTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.menu.mas_bottom);
        }];
 
    }
}

- (void)getQuestionsData {
    QuestionRequestModel *request = [[QuestionRequestModel alloc] init];
    request.userID = [[UserManager defaultManager] currentUserID];
    __weak typeof(self) weakSelf = self;
    [[QuestionManager defaultManager] getUserQuestionsHistory:request complete:^(BOOL finished, NSError *error) {
        if (finished && !error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reloadData];
            });
        }
    }];
}

- (void)getConsultationData {
    __weak typeof(self) weakSelf = self;
    [[QuestionManager defaultManager] getUnansweredChatGroup:[[UserManager defaultManager] currentUserID] complete:^(BOOL finished, NSError *error) {
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

- (void)queryData {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.userID = %@ AND answers.@count = 0", [[UserManager defaultManager] currentUser].userID];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"user.userID = %@ AND answers.@count >= 1", [[UserManager defaultManager] currentUser].userID];
    
    __weak typeof(self) weakSelf = self;
    [[Question objectsWithPredicate:predicate] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"published" ascending:NO];
                strongSelf.unanswered = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf reloadData];
                    [strongSelf.tableView reloadData];
                    [strongSelf.emptyView removeFromSuperview];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
            }
        }
    }];
    [[Question objectsWithPredicate:predicate2] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"published" ascending:NO];
                strongSelf.answered = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf reloadData];
                    [strongSelf.emptyView removeFromSuperview];
                    [strongSelf.answeredTableView reloadData];
                });
            }
        }
    }];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"user.userID = %@ AND finished = NO", [[UserManager defaultManager] currentUser].userID];
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"user.userID = %@ AND finished = YES AND type=%@", [[UserManager defaultManager] currentUser].userID, @"text"];
    [[Consultation objectsWithPredicate:predicate3] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"created" ascending:NO];
                strongSelf.unansweredChat = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf reloadData];
                    [strongSelf.emptyView removeFromSuperview];
                    [strongSelf.tableView reloadData];
                });
            }
        }
    }];
    [[Consultation objectsWithPredicate:predicate4] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"created" ascending:NO];
                strongSelf.answeredChat = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf reloadData];
                    [strongSelf.emptyView removeFromSuperview];
                    [strongSelf.answeredTableView reloadData];
                });
            }
        }
    }];
    
    [self reloadData];
    if (self.unanswered.count == 0 && self.unansweredChat.count == 0) {
        [self addEmptyPage];
    } else {
        [self.emptyView removeFromSuperview];
        [self.tableView reloadData];
    }
}

- (void)addEmptyPage {
    if (!self.emptyView) {
        self.emptyView = [[VTXEmptyView alloc] init];
        [self.emptyView setEmptyScreenType:EmptyQuestion];
        self.emptyView.delegate = self;
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menu.mas_bottom);
            make.left.right.and.bottom.equalTo(self.view);
        }];
    }
}

- (void)reloadData {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.userID = %@ AND answers.@count = 0", [[UserManager defaultManager] currentUser].userID];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"user.userID = %@ AND answers.@count >= 1", [[UserManager defaultManager] currentUser].userID];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"user.userID = %@ AND finished = NO", [[UserManager defaultManager] currentUser].userID];
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"user.userID = %@ AND finished = YES AND type=%@", [[UserManager defaultManager] currentUser].userID, @"text"];
    self.unanswered = [[Question objectsWithPredicate:predicate] sortedResultsUsingProperty:@"published" ascending:NO];
    self.answered = [[Question objectsWithPredicate:predicate2] sortedResultsUsingProperty:@"published" ascending:NO];
    self.unansweredChat =[[Consultation  objectsWithPredicate:predicate3] sortedResultsUsingProperty:@"created" ascending:NO];
    self.answeredChat =[[Consultation  objectsWithPredicate:predicate4] sortedResultsUsingProperty:@"created" ascending:NO];
    if (self.unanswered.count != 0 || self.unansweredChat.count != 0 || self.answered.count != 0 || self.answeredChat.count != 0) {
        [self.emptyView removeFromSuperview];
    }
    [self.tableView reloadData];
    [self.answeredTableView reloadData];
}

- (void)showSpinner {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

- (void)hideSpinner {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
}

#pragma mark - Empty Page Delegate
- (void)didClickBtn {
    // Add Question Here
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_press"
                                                           label:@"myquestion_add_question_btn"
                                                           value:nil] build]];
    [Flurry logEvent:@"myquestion_add_question_btn"];
    if (![[UserManager defaultManager] currentUser]) {
        [self presendtSignupLogin];
    } else {
        VTXAddQuestionViewController *viewController = [[VTXAddQuestionViewController alloc] init];
        [viewController initQuestionTitle:@""];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

//- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
//}

#pragma mark - Dropdown menu delegate


- (void)selectedSegment:(VTXTopSegmentedControl *)segment {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_press"
                                                           label:@"switch_segment"
                                                           value:nil] build]];
    [Flurry logEvent:@"switch_segment"];
    
    if (segment.selectedSegmentIndex == 0) {
        [self.tableView setHidden:NO];
        [self.answeredTableView setHidden:YES];
        [self.answeredTableView reloadData];
    } else {
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
        [self.answeredTableView setHidden:NO];
    }
    
}

- (void)getFirebaseTokenWithConsultation:(Consultation *)consultation {
    NSString *groupID = consultation.consultationID;
    NSString *transactionID = consultation.transactionID;
    BOOL isFinished = [consultation.finished boolValue];
    __weak typeof(self) weakSelf = self;
    [[VTXChatManager defaultManager] getOneOnOneTokenWithGroup:groupID transaction:transactionID type:@"text" completion:^(BOOL success, NSDictionary *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSString *token = [result objectForKey:@"token"];
            NSString *userID = [[[result objectForKey:@"data"][0] objectForKey:@"user"] objectForKey:@"id"];
            NSString *receiverID;
            if ([[result objectForKey:@"data"][0] objectForKey:@"user"]) {
                receiverID = [[[result objectForKey:@"data"][0] objectForKey:@"vet"] objectForKey:@"id"];
            } else {
                receiverID = @"";
            }
            [strongSelf gotoChatWithToken:token user:userID receiver:receiverID group:groupID finished:isFinished];
        }
    } error:^(NSError *error) {
        NSLog(@"get one on one error: %@", [error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideSpinner];
            [self.tableView setAllowsSelection:YES];
        });
    }];
}

- (void)getTwilioTokenWithConsultation:(Consultation *)consultation {
    NSString *groupID = consultation.consultationID;
    NSString *transactionID = consultation.transactionID;
    __weak typeof(self) weakSelf = self;
    [[VTXChatManager defaultManager] getOneOnOneTokenWithGroup:groupID transaction:transactionID type:@"video" completion:^(BOOL success, NSDictionary *result) {
        @try {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                NSString *token = [result objectForKey:@"token"];
                VTXVideoViewController *videoVC;
                NSLog(@"video consultation result: %@", result);
                if ([[result objectForKey:@"data"][0] objectForKey:@"vet"]) {
                    NSString *user = [[[result objectForKey:@"data"][0] objectForKey:@"vet"] objectForKey:@"id"];
                    videoVC = [[VTXVideoViewController alloc] initWithToken:token invitee:user];
//                    videoVC.inviteeIdentity = user;
                } else {
                    videoVC = [[VTXVideoViewController alloc] initWithToken:token];
                }
                videoVC.consultation = consultation;
                videoVC.currentIdentity = [result objectForKey:@"identity"];
                [strongSelf hideSpinner];
                [strongSelf.navigationController presentViewController:videoVC animated:YES completion:^{
                    [strongSelf.tableView setAllowsSelection:YES];
                }];
            }
        } @catch (NSException *exception) {
            // Show error alert
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideSpinner];
                [self.tableView setAllowsSelection:YES];
            });
        }
        
    } error:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideSpinner];
            [self.tableView setAllowsSelection:YES];
        });
    }];
}

- (void)gotoChatWithToken:(NSString *)token user:(NSString *)senderID receiver:(NSString *)receiver group:(NSString *)groupID finished:(BOOL)isFinished {
    __weak typeof(self) weakSelf = self;
    [[VTXChatManager defaultManager] authorizeUserWithFirebaseToken:token completion:^(BOOL success, NSDictionary *result) {
        if (success) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VTXChatViewController *chatVC = [[VTXChatViewController alloc] init];
                    chatVC.senderId = senderID;
                    chatVC.groupID = groupID;
                    chatVC.receiverID = receiver;
                    chatVC.isFinished = isFinished;
                    NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                                          [[[UserManager defaultManager] currentUser] firstName],
                                          [[[UserManager defaultManager] currentUser] lastName]];
                    chatVC.senderDisplayName = fullName;
                    chatVC.hidesBottomBarWhenPushed = YES;
                    [strongSelf hideSpinner];
                    [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
                    [strongSelf.navigationController pushViewController:chatVC animated:YES];
                    [strongSelf.tableView setAllowsSelection:YES];
                });
            }
        }
    } error:^(NSError *error) {
        //!!!: Show Error Alert here
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideSpinner];
            [self.tableView setAllowsSelection:YES];
        });
    }];
}



#pragma mark - TableView Delegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.answeredTableView) {
        if (section == 0) {
            return self.answeredChat.count;
        } else {
            return self.answered.count;
        }
    } else {
        if (section == 0) {
            return self.unansweredChat.count;
        } else {
            return self.unanswered.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.answeredTableView) {
        if (indexPath.section == 1) {
            return 240.0f;
        } else {
            return 70.0f;
        }
    }
    return 140.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (tableView == self.answeredTableView) {
            if (indexPath.section == 0) {
                PendingChatTableViewCell *cell = (PendingChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PendingChatCell"];
                if (!cell) {
                    cell = [[PendingChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PendingChatCell"];
                }
                
                if (self.answeredChat.count < indexPath.row) {
                    [self reloadData];
                } else {
                    [cell bindData:[self.answeredChat objectAtIndex:indexPath.row] indexPath:indexPath];
                }
                [cell finishedConsultation];
                return cell;
            } else {
                HomeFeedTableViewCell *cell = (HomeFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionHistoryCell"];
                if (!cell) {
                    cell = [[HomeFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionHistoryCell"];
                }
                if (self.answered.count < indexPath.row) {
                    [self reloadData];
                } else {
                    [cell bindQuestionData:[self.answered objectAtIndex:indexPath.row]];
                }
//                [cell bindQuestionData:[self.answered objectAtIndex:indexPath.row]];
                return cell;
            }
        } else {
            if (indexPath.section == 0) {
                PendingChatTableViewCell *cell = (PendingChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PendingChatCell"];
                if (!cell) {
                    cell = [[PendingChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PendingChatCell"];
                }
                cell.delegate = self;
                if (self.unansweredChat.count < indexPath.row) {
                    [self reloadData];
                } else {
                    [cell bindData:[self.unansweredChat objectAtIndex:indexPath.row] indexPath:indexPath];
                }
                return cell;
            } else {
                PendingQuestionTableViewCell *cell = (PendingQuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PendingQuestionCell"];
                if (!cell) {
                    cell = [[PendingQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PendingQuestionCell"];
                }
                if (self.unanswered.count < indexPath.row) {
                    [self reloadData];
                } else {
                    [cell bindData:(NSDictionary *)[self.unanswered objectAtIndex:indexPath.row]];
                }
                return cell;
            }
        }
    } @catch (NSException *exception) {
        if ([[UserManager defaultManager] currentUser]) {
            [self getQuestionsData];
            [self getConsultationData];
            [self queryData];
            [self reloadData];
        }
    }
}

#pragma mark - Pending Chat Table Cell Delegate
- (void)didClickReplyBtn:(NSIndexPath *)indexPath {
    Consultation *consultation = [self.unansweredChat objectAtIndex:indexPath.row];
    if ([consultation.type isEqualToString:@"text"]) {
        [self getFirebaseTokenWithConsultation:consultation];
    } else {
        [self getTwilioTokenWithConsultation:consultation];
    }
}

- (void)didClickEndChatBtn:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"End 1-on-1?" message:@"This will permanently end this consultation. Are you sure you want to end it?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction *give = [UIAlertAction actionWithTitle:@"End" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
            NSLog(@"Exception to end consultation: %@", exception);
            [[VTXChatManager defaultManager] cleanConsutlationCache];
        } @finally {
            if ([[UserManager defaultManager] currentUser]) {
                [self getQuestionsData];
                [self getConsultationData];
                [self queryData];
                [self reloadData];
            }
        }
    }];
    [alert addAction:ok];
    [alert addAction:give];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        @try {
            [self showSpinner];
            [self.tableView setAllowsSelection:NO];
            Consultation *consultation;
            if (tableView == self.tableView) {
                consultation = [self.unansweredChat objectAtIndex:indexPath.row];
            } else {
                consultation = [self.answeredChat objectAtIndex:indexPath.row];
            }
            if ([consultation.type isEqualToString:@"text"]) {
                [self getFirebaseTokenWithConsultation:consultation];
            } else {
                [self getTwilioTokenWithConsultation:consultation];
            }
        } @catch (NSException *exception) {
            if ([[UserManager defaultManager] currentUser]) {
                [self getQuestionsData];
                [self getConsultationData];
                [self queryData];
                [self reloadData];
            }
        }
    } else {
        @try {
            [self.tableView setAllowsSelection:NO];
            Question *question;
            if (tableView == self.tableView) {
                question = [self.unanswered objectAtIndex:indexPath.row];
            } else {
                question = [self.answered objectAtIndex:indexPath.row];
            }
            QuestionDetailViewController *questionDetails = [[QuestionDetailViewController alloc] initWithData:question];
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:questionDetails animated:YES];
            [self.tableView setAllowsSelection:YES];
        } @catch (NSException *exception) {
            if ([[UserManager defaultManager] currentUser]) {
                [self getQuestionsData];
                [self getConsultationData];
                [self queryData];
                [self reloadData];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *numberLable = [[UILabel alloc] init];
        [numberLable setFont:VETX_FONT_MEDIUM_13];
        [numberLable setTextColor:FEED_CELL_NAME_COLOR];
        if (tableView == self.tableView) {
            if (section == 0) {
                [numberLable setText:[NSString stringWithFormat:@"%zd Ongoing Chat", self.unansweredChat.count]];
            } else {
                [numberLable setText:[NSString stringWithFormat:@"%zd Pending Questions", self.unanswered.count]];
            }
        } else {
            if (section == 0) {
                [numberLable setText:[NSString stringWithFormat:@"%zd Answered Chat", self.answeredChat.count]];
            } else {
                [numberLable setText:[NSString stringWithFormat:@"%zd Answered Questions", self.answered.count]];
            }
        }
        [numberLable sizeToFit];
        CGFloat width = CGRectGetWidth(numberLable.frame);
        [headerView addSubview:numberLable];
        [numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerView);
            make.width.equalTo([NSNumber numberWithDouble:width]);
        }];
        
        UILabel *leftLine = [[UILabel alloc] init];
        [leftLine setBackgroundColor:FEED_CELL_NAME_COLOR];
        [headerView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.equalTo(headerView).offset(15);
            make.right.equalTo(numberLable.mas_left).offset(-10);
            make.centerY.equalTo(headerView);
        }];
        
        UILabel *rightLine = [[UILabel alloc] init];
        [rightLine setBackgroundColor:FEED_CELL_NAME_COLOR];
        [headerView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.equalTo(numberLable.mas_right).offset(10);
            make.right.equalTo(headerView).offset(-15);
            make.centerY.equalTo(headerView);
        }];
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // remove bottom extra 20px space.
    return CGFLOAT_MIN;
}

@end
