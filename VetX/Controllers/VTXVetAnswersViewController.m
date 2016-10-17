//
//  VTXVetAnswersViewController.m
//  VetX
//
//  Created by YulianMobile on 5/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXVetAnswersViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "Consultation.h"
#import "HomeFeedTableViewCell.h"
#import "QuestionRequestModel.h"
#import "QuestionManager.h"
#import "Question.h"
#import "UserManager.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "VTXTopSegmentedControl.h"
#import "ConsultationRequestTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "VTXChatManager.h"
#import "VTXChatViewController.h"
#import "VTXEmptyView.h"
#import "BottomTabBarController.h"

@interface VTXVetAnswersViewController () <UITableViewDelegate, UITableViewDataSource, VTXSegmentedControlDelegate, VTXEmptyViewDelegate>

@property (nonatomic, strong) UIView *topStatusView;
@property (nonatomic, strong) VTXTopSegmentedControl *menu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) VTXEmptyView *emptyView;

@property (nonatomic, strong) RLMResults<Question *> *answeredQuestions;
@property (nonatomic, strong) RLMResults<Consultation *> *finishedConsultation;
@end

@implementation VTXVetAnswersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];

    [self setupView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[UserManager defaultManager] currentUser]) {
        [self getAnsweredQuestions];
        [self getFinishedConsultation];
        [self reloadData];
    } else {
        [self addEmptyPage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.menu = [[VTXTopSegmentedControl alloc] initWithItems:@[@"Feed Ans", @"Chat Ans"]];
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
        [self.tableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.tableView registerClass:[HomeFeedTableViewCell class] forCellReuseIdentifier:@"QuestionHistoryCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.menu.mas_bottom);
        }];
    }
    
    if (!self.chatTableView) {
        self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.chatTableView.delegate = self;
        self.chatTableView.dataSource = self;
        [self.chatTableView setHidden:YES];
        self.chatTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.chatTableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.chatTableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.chatTableView registerClass:[ConsultationRequestTableViewCell class] forCellReuseIdentifier:@"FinishedConsultationCell"];
        [self.view addSubview:self.chatTableView];
        [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)getAnsweredQuestions {
    __weak typeof(self) weakSelf = self;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(answers, $answer, $answer.answerVet.emailAddress = %@).@count > 0", [UserManager defaultManager].currentUser.emailAddress];
    [[QuestionManager defaultManager] getVetOwnAnswersComplete:^(BOOL finished, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"published" ascending:NO];
            strongSelf.answeredQuestions = [[[Question allObjects] objectsWithPredicate:predicate] sortedResultsUsingDescriptors:@[sortDescriptor]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reloadData];
            });
        }
    }];
    [[Question objectsWithPredicate:predicate] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"published" ascending:NO];
                strongSelf.finishedConsultation = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf reloadData];
                });
            }
        }
    }];
}

- (void)getFinishedConsultation {
    __weak typeof(self) weakSelf = self;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vet.userID = %@ AND finished = YES AND type=%@", [[UserManager defaultManager] currentUser].userID, @"text"];
    [[QuestionManager defaultManager] getConsultationHistory:[[UserManager defaultManager] currentUserID] complete:^(BOOL finished, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"created" ascending:NO];
            self.finishedConsultation = [[[Consultation allObjects] objectsWithPredicate:predicate] sortedResultsUsingDescriptors:@[sortDescriptor]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reloadData];
            });
        }
    }];
    [[Consultation objectsWithPredicate:predicate] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"created" ascending:NO];
                strongSelf.finishedConsultation = [results sortedResultsUsingDescriptors:@[sortDescriptor]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf reloadData];
                });
            }
        }
    }];
}

- (void)reloadData {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(answers, $answer, $answer.answerVet.emailAddress = %@).@count > 0", [UserManager defaultManager].currentUser.emailAddress];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"vet.userID = %@ AND finished = YES AND type=%@", [[UserManager defaultManager] currentUser].userID, @"text"];
    self.answeredQuestions = [[Question objectsWithPredicate:predicate] sortedResultsUsingProperty:@"published" ascending:NO];
    self.finishedConsultation = [[Consultation objectsWithPredicate:predicate2] sortedResultsUsingProperty:@"created" ascending:NO];
    [self.tableView reloadData];
    [self.chatTableView reloadData];
    if (self.answeredQuestions.count != 0 || self.finishedConsultation.count != 0) {
        [self.emptyView removeFromSuperview];
    } else {
        [self addEmptyPage];
    }
}

#pragma mark - Dropdown menu delegate

- (void)selectedSegment:(VTXTopSegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Open Answered Question List"
                                                               label:@"Open Answered Question List"
                                                               value:nil] build]];
        [Flurry logEvent:@"Open Answered Question List"];
        [self.tableView setHidden:NO];
        [self.chatTableView setHidden:YES];
        [self.chatTableView reloadData];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Open Answered Chat List"
                                                               label:@"Open Answered Chat List"
                                                               value:nil] build]];
        [Flurry logEvent:@"Open Answered Chat List"];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
        [self.chatTableView setHidden:NO];
    }
}

#pragma mark - TableView Delegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.answeredQuestions.count;
    } else {
        return self.finishedConsultation.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 240;
    } else {
        return 80.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.tableView) {
        HomeFeedTableViewCell *cell = (HomeFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionHistoryCell"];
        if (!cell) {
            cell = [[HomeFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionHistoryCell"];
        }
        [cell bindQuestionData:[self.answeredQuestions objectAtIndex:indexPath.row]];
        return cell;
    } else {
        ConsultationRequestTableViewCell *cell = (ConsultationRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FinishedConsultationCell"];
        if (!cell) {
            cell = [[ConsultationRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FinishedConsultationCell"];
        }
        [cell bindWithUserData:[self.finishedConsultation objectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView setAllowsSelection:NO];
    if (tableView == self.tableView) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Go To Answered Question Details"
                                                               label:@"Go To Answered Question Details"
                                                               value:nil] build]];
        [Flurry logEvent:@"Go To Answered Question Details"];
        @try {
            Question *question;
            question = [self.answeredQuestions objectAtIndex:indexPath.row];
            QuestionDetailViewController *questionDetails = [[QuestionDetailViewController alloc] initWithData:question];
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:questionDetails animated:YES];
            [self.tableView setAllowsSelection:YES];
        } @catch (NSException *exception) {
            if ([[UserManager defaultManager] currentUser]) {
                [self getAnsweredQuestions];
                [self getFinishedConsultation];
                [self reloadData];
            }
        }
        
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Go To Answered Chat Details"
                                                               label:@"Go To Answered Chat Details"
                                                               value:nil] build]];
        [Flurry logEvent:@"Go To Answered Chat Details"];
        @try {
            [self.tableView setAllowsSelection:NO];
            Consultation *consultation;
            consultation = [self.finishedConsultation objectAtIndex:indexPath.row];
            if ([consultation.type isEqualToString:@"text"]) {
                [self getFirebaseTokenWithConsultation:consultation];
            } 
        } @catch (NSException *exception) {
            if ([[UserManager defaultManager] currentUser]) {
                [self getAnsweredQuestions];
                [self getFinishedConsultation];
                [self reloadData];
            }
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
    // remove bottom extra 20px space.
    return CGFLOAT_MIN;
}


- (void)getFirebaseTokenWithConsultation:(Consultation *)consultation {
    NSString *groupID = consultation.consultationID;
    NSString *transactionID = consultation.transactionID;
    BOOL isFinished = [consultation.finished boolValue];
    [[VTXChatManager defaultManager] getOneOnOneTokenWithGroup:groupID transaction:transactionID type:@"text" completion:^(BOOL success, NSDictionary *result) {
        NSString *token = [result objectForKey:@"token"];
        NSString *userID = [[[result objectForKey:@"data"][0] objectForKey:@"user"] objectForKey:@"id"];
        [self gotoChatWithToken:token user:userID group:groupID finished:isFinished];
    } error:^(NSError *error) {
        NSLog(@"get one on one error: %@", [error localizedDescription]);
        [self.tableView setAllowsSelection:YES];
    }];
}


- (void)gotoChatWithToken:(NSString *)token user:(NSString *)senderID group:(NSString *)groupID finished:(BOOL)isFinished {
    [[VTXChatManager defaultManager] authorizeUserWithFirebaseToken:token completion:^(BOOL success, NSDictionary *result) {
        if (success) {
            VTXChatViewController *chatVC = [[VTXChatViewController alloc] init];
            chatVC.senderId = senderID;
            chatVC.groupID = groupID;
            chatVC.isFinished = isFinished;
            NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                                  [[[UserManager defaultManager] currentUser] firstName],
                                  [[[UserManager defaultManager] currentUser] lastName]];
            chatVC.senderDisplayName = fullName;
            dispatch_async(dispatch_get_main_queue(), ^{
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.navigationController pushViewController:chatVC animated:YES];
                [self.tableView setAllowsSelection:YES];
            });
        }
    } error:^(NSError *error) {
        //!!!: Show Error Alert here
        [self.tableView setAllowsSelection:YES];
    }];
}

@end
