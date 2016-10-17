//
//  AddQuestionView.m
//  VetX
//
//  Created by Liam Dyer on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AddQuestionActionBarView.h"
#import "Constants.h"
#import "Masonry.h"
#import <QuartzCore/QuartzCore.h>
#import <Google/Analytics.h>
#import "Flurry.h"

@implementation AddQuestionActionBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = ORANGE_THEME_COLOR;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = VETX_FONT_BOLD_13;
    textLabel.text = @"Don't see your question here?";
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIButton *addQuestionButton = [[UIButton alloc] init];
    addQuestionButton.backgroundColor = [UIColor whiteColor];
    [addQuestionButton setTitle:@"Add It" forState:UIControlStateNormal];
    [addQuestionButton setTitleColor:GREY_COLOR forState:UIControlStateNormal];
    addQuestionButton.titleLabel.font = VETX_FONT_BOLD_13;
    [self addSubview:addQuestionButton];
    [addQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.width.equalTo(@100);
    }];
    addQuestionButton.layer.cornerRadius = 15;
    addQuestionButton.clipsToBounds = YES;
    
    [addQuestionButton addTarget:self
                          action:@selector(buttonClicked)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked {
    if (self.delegate) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Tap Add Question Button"
                                                               label:@"Tap Add Question Button"
                                                               value:nil] build]];
        [Flurry logEvent:@"Tap Add Question Button"];
        [self.delegate addQuestionButtonClicked];
    }
}

@end
