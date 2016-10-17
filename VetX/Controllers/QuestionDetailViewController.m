//
//  QuestionDetailViewController.m
//  VetX
//
//  Created by YulianMobile on 2/8/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "QuestionDetailsCell.h"
#import "AnswerDetailsCell.h"
#import <Google/Analytics.h>
#import "Flurry.h"

@interface QuestionDetailViewController () <UITableViewDelegate, UITableViewDataSource, QuestionDetailsCellDelegate>

@property (nonatomic, strong) Question *question;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QuestionDetailViewController

- (instancetype)initWithData:(Question *)question {
    self = [super init];
    if (self) {
        self.question = question;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Question Details"];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Question Detail Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"view_question_details" timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"view_question_details" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view setBackgroundColor:FEED_BACKGROUND_COLOR];

    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setContentInset:UIEdgeInsetsMake(5, 0, 0, 0)];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView setEstimatedRowHeight:350.0f];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.tableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.tableView registerClass:[QuestionDetailsCell class] forCellReuseIdentifier:@"QuestionCell"];
        [self.tableView registerClass:[AnswerDetailsCell class] forCellReuseIdentifier:@"AnswerCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)shareQuestion:(Question *)questionObj {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Share Question"
                                                           label:@"Share Question"
                                                           value:nil] build]];
    [Flurry logEvent:@"Share Question"];
    
    NSString *link = [NSString stringWithFormat:@"https://vetxapp.com/question/%@", questionObj.questionID];
    NSString *shareString = [NSString stringWithFormat:@"\"%@\" %@", questionObj.questionTitle, link];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:nil];
    activity.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activity animated:YES completion:nil];
}

#pragma mark - UITableView Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.question.answers.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QuestionDetailsCell *cell = (QuestionDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
        if (!cell) {
            cell = [[QuestionDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
        }
        // Bind data
        cell.delegate = self;
        [cell bindData:self.question];
        return cell;
    } else {
        AnswerDetailsCell *cell = (AnswerDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        if (!cell) {
            cell = [[AnswerDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnswerCell"];
        }
        // Bind data
        [cell bindData:[self.question.answers objectAtIndex:indexPath.row-1]];
        return cell;
    }
}

@end
