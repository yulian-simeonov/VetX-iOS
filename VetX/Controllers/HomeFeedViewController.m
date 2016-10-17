//
//  HomeFeedViewController.m
//  VetX
//
//  Created by YulianMobile on 1/25/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "Masonry.h"
#import "Constants.h"
#import "HomeFeedTableViewCell.h"
#import "SearchSuggestionViewCell.h"
#import "SignUpLoginViewController.h"
#import "QuestionDetailViewController.h"
#import "QuestionManager.h"
#import "QuestionRequestModel.h"
#import "QuestionModel.h"
#import "SuggestionRequestModel.h"
#import "VTXChatViewController.h"
#import "VXDropDownTableViewController.h"
#import "AddQuestionActionBarView.h"
#import "VTXAddQuestionViewController.h"
#import <RBQFetchedResultsController/RBQFRC.h>
#import <RSKKeyboardAnimationObserver/RSKKeyboardAnimationObserver.h>
#import <Google/Analytics.h>
#import "VTXChatManager.h"
#import "NetworkManager.h"
#import "Flurry.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, RBQFetchedResultsControllerDelegate, DropdownMenuDelegate, AddQuestionActionBarViewDelegate, UIBarPositioningDelegate, UIToolbarDelegate, HomeFeedTableViewCellDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) UIView *blackBackground;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *topToolBar;
@property (nonatomic, strong) SignUpLoginViewController *signupVC;
@property (nonatomic, strong) NSArray* questionSuggestions;
@property (nonatomic, strong) RBQFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *searchSuggestionsTableView;
@property (nonatomic, strong) VXDropDownTableViewController *menu;
@property (nonatomic, strong) AddQuestionActionBarView *addQuestionView;
@property (nonatomic, strong) UIButton *plusBtn;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];

    self.items = @[@"All", @"Behavior", @"Breeds", @"Diet", @"Grooming", @"Health & Wellness", @"Training"];
    self.isExpand = NO;
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataFromServer];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answers.@count > 0"];
    [self setupFetchedResultsController:predicate];
    [[QuestionManager defaultManager] rotateFeedQuestions];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Q&A Feed"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"Q&A Feed" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[QuestionManager defaultManager] stopRotateFeedQuestions];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fetchedResultsController = nil;
    [Flurry endTimedEvent:@"Q&A Feed" withParameters:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    // Setup keyboard notifications to change height of addQuestionView
    __weak typeof(self) weakSelf = self;
    [self rsk_subscribeKeyboardWithWillShowOrHideAnimation:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isShowing) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (self.addQuestionView) {
                [self.addQuestionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (isShowing) {
                        make.bottom.equalTo(self.view.mas_bottom).with.offset(TABBAT_HEIGHT-CGRectGetHeight(keyboardRectEnd));
                    } else {
                        make.bottom.equalTo(self.view.mas_bottom);
                    }
                }];
            }
            [strongSelf.view layoutIfNeeded];
        }
    } onComplete:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBarPositioningDelegate 
-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)setupViews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (!self.topToolBar) {
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
        [leftBtn setTintColor:[UIColor whiteColor]];
        [leftBtn setImage:[[UIImage imageNamed:@"Filter_Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [leftBtn setWidth:40];
        if (SCREEN_WIDTH >= 400.0f) {
            [leftBtn setImageInsets:UIEdgeInsetsMake(0, -25, 0, 25)];
        } else {
            [leftBtn setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        }
        [leftBtn setTarget:self];
        [leftBtn setAction:@selector(openMenu)];
        self.topToolBar = [[UIToolbar alloc] init];
        self.topToolBar.delegate = self;
        [self.topToolBar setTranslucent:NO];
        [self.topToolBar setBarTintColor:ORANGE_THEME_COLOR];
        [self.topToolBar setItems:@[leftBtn]];
        [self.view addSubview:self.topToolBar];
        [self.topToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.view);
            make.top.equalTo(self.view).offset(20);
        }];
    }
    
    if (!self.searchBar) {
        self.searchBar = [[UISearchBar alloc] init];
        NSString *placeholderText;
        if (SCREEN_WIDTH >= 400.0f) {
            placeholderText = @"Search questions                                                            ";
        } else if (SCREEN_WIDTH < 400.0f && SCREEN_WIDTH >= 350.0f) {
            placeholderText = @"Search questions                                                ";
        } else {
            placeholderText = @"Search questions                                   ";
        }
        [self.searchBar setPlaceholder:placeholderText];
        [self.searchBar setImage:[UIImage imageNamed:@"Clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [self.searchBar setImage:[UIImage imageNamed:@"Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self.searchBar setEnablesReturnKeyAutomatically:YES];
        self.searchBar.delegate = self;
        
        UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
        [txfSearchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [txfSearchField setBackgroundColor:[UIColor colorWithRed:0.925 green:0.482 blue:0.016 alpha:1]];
        for (UIView *subview in [[self.searchBar.subviews lastObject] subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview setAlpha:0.0];
                break;
            }
        }
        [self.view addSubview:self.searchBar];
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(30);
            make.top.equalTo(self.view).offset(20);
            make.right.equalTo(self.view);
        }];
    }

    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.tableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.tableView registerClass:[HomeFeedTableViewCell class] forCellReuseIdentifier:@"FeedCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.topToolBar.mas_bottom);
        }];
    }
    
    if (!self.blackBackground) {
        self.blackBackground = [[UIView alloc] init];
        [self.blackBackground setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self.blackBackground setHidden:YES];
        [self.view addSubview:self.blackBackground];
        [self.blackBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (!self.plusBtn) {
        self.plusBtn = [[UIButton alloc] init];
        [self.plusBtn setBackgroundColor:ORANGE_THEME_COLOR];
        [self.plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.plusBtn.titleLabel setFont:VETX_FONT_REGULAR_42];
        [self.plusBtn.layer setShadowRadius:2.0f];
        [self.plusBtn.layer setShadowOffset:CGSizeMake(2, 2)];
        [self.plusBtn.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.plusBtn.layer setShadowOpacity:0.35];
        [self.plusBtn.layer setCornerRadius:35.0f];
        [self.plusBtn addTarget:self action:@selector(addQuestionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:self.plusBtn];
        [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@70.0f);
            make.right.and.bottom.equalTo(self.view).offset(-10);
        }];
    }
    
    
    if (!self.menu) {
        self.menu = [[VXDropDownTableViewController alloc] init];
        self.menu.delegate = self;
        [self.menu setMenuItems:self.items];
        self.menu.menuItemHeight = 40.0f;
        [self addChildViewController:self.menu];
        [self.view addSubview:self.menu.view];
        [self.menu didMoveToParentViewController:self];
        [self.menu.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.searchBar.mas_bottom);
            make.left.and.right.equalTo(self.view);
        }];
    }
    
    if (!self.addQuestionView) {
        self.addQuestionView = [[AddQuestionActionBarView alloc] init];
        self.addQuestionView.hidden = YES;
        self.addQuestionView.delegate = self;
        [self.view addSubview:self.addQuestionView];
        [self.addQuestionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view.mas_width);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
}

- (void)setupFetchedResultsController:(NSPredicate *)predicate {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"Question"
                                                                        inRealm:realm
                                                                      predicate:predicate];
    RLMSortDescriptor *sortDescriptor = [RLMSortDescriptor sortDescriptorWithProperty:@"score"
                                                                            ascending:NO];
    RLMSortDescriptor *sortDescriptor2 = [RLMSortDescriptor sortDescriptorWithProperty:@"published" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor2, sortDescriptor];
    self.fetchedResultsController = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:@"feed"];
    self.fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetch];
    [self.tableView reloadData];
}

- (void)getDataFromServer {
    QuestionRequestModel *requestionModel = [[QuestionRequestModel alloc] init];
    requestionModel.limit = @100;
    [[QuestionManager defaultManager] getFeedWithParameter:requestionModel];
}

- (void)openMenu {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"OPEN FILTER VIEW"
                                                           label:@"OPEN FILTER VIEW"
                                                           value:nil] build]];
    [Flurry logEvent:@"OPEN FILTER VIEW"];
    [self changeMenuHeight];
}

- (void)showSearchSuggestions {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"OPEN SEARCH VIEW"
                                                           label:@"OPEN SEARCH VIEW"
                                                           value:nil] build]];
    [Flurry logEvent:@"OPEN SEARCH VIEW"];
    if (!self.searchSuggestionsTableView) {
        self.searchSuggestionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.searchSuggestionsTableView.delegate = self;
        self.searchSuggestionsTableView.dataSource = self;
        self.searchSuggestionsTableView.rowHeight = UITableViewAutomaticDimension;
        [self.searchSuggestionsTableView setEstimatedRowHeight:50.0f];
        self.searchSuggestionsTableView.backgroundColor = FEED_BACKGROUND_COLOR;
        self.searchSuggestionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.searchSuggestionsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.searchSuggestionsTableView registerClass:[SearchSuggestionViewCell class] forCellReuseIdentifier:@"SearchCell"];
        [self.view addSubview:self.searchSuggestionsTableView];
        [self.searchSuggestionsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom);
        }];
    }
    self.addQuestionView.hidden = NO;
    [self.view bringSubviewToFront:self.addQuestionView];
}

- (void)hideSearchSuggestions {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"HIDE SEARCH VIEW"
                                                           label:@"HIDE SEARCH VIEW"
                                                           value:nil] build]];
    [Flurry logEvent:@"HIDE SEARCH VIEW"];
    self.addQuestionView.hidden = YES;
    if (self.searchSuggestionsTableView) {
        [self.searchSuggestionsTableView removeFromSuperview];
        self.searchSuggestionsTableView = nil;
    }
}

#pragma mark - Table View Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return [self.fetchedResultsController numberOfSections];
    }
    
    // self.searchSuggestionsTableView
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.fetchedResultsController numberOfRowsForSectionIndex:section];
    }
    
    // self.searchSuggestionsTableView
    return [self.questionSuggestions count] ? [self.questionSuggestions count] : 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 240.0f;
    }

    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        HomeFeedTableViewCell *cell = (HomeFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
        if (!cell) {
            cell = [[HomeFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedCell"];
        }
        cell.delegate = self;
        Question *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [cell bindQuestionData:question];
        return cell;
    }
    
    // self.searchSuggestionsTableView
    SearchSuggestionViewCell *cell = (SearchSuggestionViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    QuestionModel *question = [self.questionSuggestions objectAtIndex:indexPath.row];
    [cell bindQuestionData:question];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Handle search suggestion taps
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[QuestionManager defaultManager] stopRotateFeedQuestions];
    Question *question;
    if (tableView == self.tableView) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Go To Question Details"
                                                               label:@"Go To Question Details"
                                                               value:nil] build]];
        [Flurry logEvent:@"Go To Question Details"];
        question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Tap Search Result"
                                                               label:@"Tap Search Result"
                                                               value:nil] build]];
        [Flurry logEvent:@"Tap Search Result"];
        QuestionModel *questionModel = [self.questionSuggestions objectAtIndex:indexPath.row];
        question = [[Question alloc] initWithMantleQuestionModel:questionModel];
    }
    QuestionDetailViewController *questionDetails = [[QuestionDetailViewController alloc] initWithData:question];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:questionDetails animated:YES];
}

- (void)shareQuestion:(Question *)question {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Share Question"
                                                           label:@"Share Question"
                                                           value:nil] build]];
    [Flurry logEvent:@"Share Question"];
    
    NSString *link = [NSString stringWithFormat:@"https://vetxapp.com/question/%@", question.questionID];
    NSString *shareString = [NSString stringWithFormat:@"\"%@\" %@", question.questionTitle, link];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:nil];
    activity.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activity animated:YES completion:nil];
}

#pragma mark - RBQFetchedResultsController Delegate


- (void)controllerWillChangeContent:(RBQFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(RBQFetchedResultsController *)controller
   didChangeObject:(RBQSafeRealmObject *)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
            if ([[tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                [tableView reloadRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(RBQFetchedResultsController *)controller
  didChangeSection:(RBQFetchedResultsSectionInfo *)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tableView;
    
    if (type == NSFetchedResultsChangeInsert) {
        NSLog(@"Inserting section at %lu", (unsigned long)sectionIndex);
        NSIndexSet *insertedSection = [NSIndexSet indexSetWithIndex:sectionIndex];
        
        [tableView insertSections:insertedSection withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        NSLog(@"Deleting section at %lu", (unsigned long)sectionIndex);
        NSIndexSet *deletedSection = [NSIndexSet indexSetWithIndex:sectionIndex];
        
        [tableView deleteSections:deletedSection withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerDidChangeContent:(RBQFetchedResultsController *)controller
{
    @try {
        [self.tableView endUpdates];
    }
    @catch (NSException *ex) {
        NSLog(@"RBQFecthResultsTVC caught exception updating table view: %@. Falling back to reload.", ex);
        
        [self.fetchedResultsController reset];
        
        [self.tableView reloadData];
    }
}

#pragma mark - UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Start Search Question"
                                                           label:@"Start Search Question"
                                                           value:nil] build]];
    [Flurry logEvent:@"Start Search Question"];
    [searchBar setShowsCancelButton:YES animated:YES];
    [self showSearchSuggestions];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"search"
                                                           label:@"Cancel Search"
                                                           value:nil] build]];
    [Flurry logEvent:@"Cancel Search"];
    [self.view endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self hideSearchSuggestions];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    SuggestionRequestModel *requestModel = [[SuggestionRequestModel alloc] init];
    requestModel.text = searchText;
    [[QuestionManager defaultManager] getSuggestionsWithParameter:requestModel andSuccess:^(NSArray *questions) {
        self.questionSuggestions = questions;
        [self.searchSuggestionsTableView reloadData];
    }];
}

- (void)clickPlusButton {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Tap Add Question Plus Button"
                                                           label:@"Tap Add Question Plus Button"
                                                           value:nil] build]];
    [Flurry logEvent:@"Tap Add Question Plus Button"];
    [self addQuestionButtonClicked];
}

# pragma mark - AddQuestionViewDelegate

- (void)addQuestionButtonClicked {
    
    [[QuestionManager defaultManager] stopRotateFeedQuestions];
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self hideSearchSuggestions];
    
    if (![[NetworkManager defaultManager] accessToken]) {
        [self presendtSignupLogin];
    } else {
        VTXAddQuestionViewController *viewController = [[VTXAddQuestionViewController alloc] init];
        [viewController initQuestionTitle:self.searchBar.text];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Signup & Login

- (void)presendtSignupLogin {
    
    self.signupVC = [[SignUpLoginViewController alloc] init];
    [self presentViewController:self.signupVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - Dropdown Menu Delegate 
- (void)didSelectItemIndex:(NSIndexPath *)indexPath {
    NSString *filterTopic = [self.items objectAtIndex:indexPath.row];
    if ([filterTopic isEqualToString:@"All"]) {
        [[QuestionManager defaultManager] rotateFeedQuestions];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answers.@count > 0"];
        [self setupFetchedResultsController:predicate];
    } else {
        [[QuestionManager defaultManager] stopRotateFeedQuestions];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@ AND answers.@count > 0", filterTopic];
        [self setupFetchedResultsController:predicate];
    }
    [self changeMenuHeight];
}

- (void)changeMenuHeight {
    self.isExpand = !self.isExpand;
    [self.view endEditing:YES];
    [self searchBarCancelButtonClicked:self.searchBar];
    [self.searchBar resignFirstResponder];
    if (self.isExpand) {
        [[QuestionManager defaultManager] stopRotateFeedQuestions];
        [self.blackBackground setHidden:NO];
        [self.menu.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.top.equalTo(self.tableView);
            make.left.and.right.equalTo(self.view);
        }];
    } else {
        [[QuestionManager defaultManager] rotateFeedQuestions];
        [self.blackBackground setHidden:YES];
        [self.menu.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.top.equalTo(self.searchBar.mas_bottom);
            make.left.and.right.equalTo(self.view);
        }];
    }
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.menu.view layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


@end
