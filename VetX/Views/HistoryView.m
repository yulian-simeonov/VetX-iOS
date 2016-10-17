//
//  HistoryView.m
//  VetX
//
//  Created by YulianMobile on 1/6/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "HistoryView.h"
#import "Constants.h"
#import "Masonry.h"
#import "RoundedBtn.h"
#import "HistoryTableViewCell.h"

@interface HistoryView ()

@property (nonatomic, strong) RoundedBtn *inProgress;
@property (nonatomic, strong) RoundedBtn *completed;


@end

@implementation HistoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if (!self.inProgress) {
        self.inProgress = [[RoundedBtn alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        [self.inProgress setTitle:@"In Progress" forState:UIControlStateNormal];
        [self.inProgress setSelected:YES];
        [self.inProgress addTarget:self action:@selector(inProgressClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.inProgress];
        [self.inProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
            make.top.equalTo(self.mas_top).offset(20);
            make.height.equalTo(@30);
            make.width.equalTo(@110);
        }];
    }
    
    if (!self.completed) {
        self.completed = [[RoundedBtn alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        [self.completed setTitle:@"Complete" forState:UIControlStateNormal];
        [self.completed setSelected:NO];
        [self.completed addTarget:self action:@selector(completeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.completed];
        [self.completed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
            make.top.height.and.width.equalTo(self.inProgress);
        }];
    }
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.tableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inProgress.mas_bottom).offset(15);
            make.left.right.and.bottom.equalTo(self);
        }];
    }
}

- (void)inProgressClicked {
    [self.completed setSelected:NO];
    [self.inProgress setSelected:YES];
    if ([self.delegate respondsToSelector:@selector(clickInProgres)]) {
        [self.delegate performSelector:@selector(clickInProgres)];
    }
}

- (void)completeClicked {
    [self.completed setSelected:YES];
    [self.inProgress setSelected:NO];
    if ([self.delegate respondsToSelector:@selector(clickComplete)]) {
        [self.delegate performSelector:@selector(clickComplete)];
    }
}

@end
