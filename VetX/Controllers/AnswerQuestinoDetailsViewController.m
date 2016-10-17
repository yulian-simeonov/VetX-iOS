//
//  AnswerQuestinoDetailsViewController.m
//  VetX
//
//  Created by YulianMobile on 5/21/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AnswerQuestinoDetailsViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "QuestionDetailsCell.h"
#import "AnswerDetailsCell.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "QuestionManager.h"
#import "QuestionRequestModel.h"

static NSString *placeholder = @"Please type your answer here...";

@interface AnswerQuestinoDetailsViewController () <UITableViewDelegate, UITableViewDataSource, QuestionDetailsCellDelegate, UITextViewDelegate>

@property (nonatomic, strong) Question *question;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *answerButton;
@property (nonatomic, strong) UITextView *answerField;

@end

@implementation AnswerQuestinoDetailsViewController

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
    
    if (!self.answerButton) {
        self.answerButton = [[UIButton alloc] init];
        [self.answerButton setBackgroundColor:ORANGE_THEME_COLOR];
        [self.answerButton setTitle:@"Answer" forState:UIControlStateNormal];
        [self.answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.answerButton.titleLabel setFont:VETX_FONT_MEDIUM_13];
        [self.answerButton addTarget:self action:@selector(postAnswer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.answerButton];
        [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-5);
            make.height.equalTo(@45);
        }];
    }
    
    if (!self.answerField) {
        self.answerField = [[UITextView alloc] init];
        [self.answerField setText:placeholder];
        self.answerField.delegate = self;
        [self.answerField.layer setBorderWidth:1.0];
        [self.answerField.layer setBorderColor:GREY_COLOR.CGColor];
        [self.answerField.layer setCornerRadius:5.0];
        [self.answerField setClipsToBounds:YES];
        [self.answerField setTextColor:GREY_COLOR];
        [self.answerField setFont:VETX_FONT_MEDIUM_15];
        [self.answerField setDataDetectorTypes:UIDataDetectorTypeAll];
        [self.view addSubview:self.answerField];
        [self.answerField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(5);
            make.right.equalTo(self.view).offset(-5);
            make.bottom.equalTo(self.answerButton.mas_top).offset(-5);
            make.height.equalTo(@180);
        }];
    }
    
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
            make.top.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.answerField.mas_top).offset(-5);
        }];
    }
}

- (void)shareQuestion:(Question *)questionObj {
    // Don't need to share for now
}

- (void)postAnswer {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Post Answer"
                                                           label:@"Post Answer"
                                                           value:nil] build]];
    [Flurry logEvent:@"Post Answer"];
    NSString *answerStr = [self.answerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![answerStr isEqualToString:@""] && ![answerStr isEqualToString:placeholder]) {
        // if answer is not empty, send request to server
        QuestionRequestModel *request = [[QuestionRequestModel alloc] init];
        request.answer = answerStr;
        [[QuestionManager defaultManager] answerQuestion:self.question.questionID answer:request complete:^(BOOL finished, NSError *error) {
            
        }];
    }
    [self.answerField resignFirstResponder];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeholder]) {
        textView.text = @"";
        textView.textColor = DARK_GREY_COLOR; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeholder;
        textView.textColor = GREY_COLOR; //optional
    }
    [textView resignFirstResponder];
}


#pragma mark - UITableView Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionDetailsCell *cell = (QuestionDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    if (!cell) {
        cell = [[QuestionDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
    }
    // Bind data
    [cell bindData:self.question];
    return cell;
}

@end
