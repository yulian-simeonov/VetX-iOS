//
//  AddQuestionView.m
//  VetX
//
//  Created by Liam Dyer on 2/17/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXAddQuestionView.h"
#import "Constants.h"
#import "UILabel+Util.h"
#import "Masonry.h"
#import <QuartzCore/QuartzCore.h>
#import "PetCellLayout.h"
//#import "PetCollectionViewCell.h"
#import "RoundedBtn.h"
#import "VTXBoneLabel.h"

CGFloat const padding = 20;
CGFloat const verticalPadding = 10;
static NSString *placeholder = @"Go into more detail here...(Optional)";

@interface VTXAddQuestionView() <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UITapGestureRecognizer *tap;

//@property (nonatomic, strong) PetCollectionViewCell *cell;
@property (nonatomic, strong) PetCellLayout *petLayout;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *postTypeView;
@property (nonatomic, strong) UILabel *selectLabel;

@property (nonatomic, strong) UIView *chatView;
@property (nonatomic, strong) UIImageView *chatIcon;
@property (nonatomic, strong) UILabel *chatPrice;
@property (nonatomic, strong) UILabel *chatSecondLabel;
@property (nonatomic, strong) UIButton *selectChat;

@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UILabel *videoPrice;
@property (nonatomic, strong) UILabel *videoSecondLabel;
@property (nonatomic, strong) UIButton *selectVideo;

@property (nonatomic, strong) UIView *generalView;
@property (nonatomic, strong) UIImageView *generalIcon;
@property (nonatomic, strong) UILabel *generalPrice;
@property (nonatomic, strong) UILabel *generalSecondLabel;
@property (nonatomic, strong) UIButton *selectGeneral;

@property (nonatomic, strong) UIView *divider1;
@property (nonatomic, strong) UIView *divider2;

@property (nonatomic, strong) UIPickerView *topicPickerView;
@property (nonatomic, strong) UIPickerView *petPickerView;

@property (nonatomic, strong) NSArray *pickerViewData;
@property (nonatomic, strong) VTXTextFieldWithBottomLine *selectedField;

@end

@implementation VTXAddQuestionView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
        self.items = @[@"All", @"Behavior", @"Breeds", @"Diet", @"Grooming", @"Health & Wellness", @"Training"];
        self.pickerViewData = self.items;
    }
    return self;
}

- (void)setup {
    self.backgroundColor =POST_QUESTION_BACKGROUND;
    
    if (!self.questionTitleField) {
        self.questionTitleField = [[VTXTextFieldWithBottomLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.questionTitleField setPlaceholder:@"e.g. Why does my dog eat grass?"];
        self.questionTitleField.delegate = self;
        [self addSubview:self.questionTitleField];
        [self.questionTitleField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.and.top.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    
    if (!self.categoryField) {
        self.categoryField = [[VTXTextFieldWithBottomLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [self.categoryField addDownArrow];
        [self.categoryField setPlaceholder:@"Select a topic"];
        self.categoryField.delegate = self;
        [self addSubview:self.categoryField];
        [self.categoryField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.questionTitleField.mas_bottom);
            make.height.left.and.right.equalTo(self.questionTitleField);
        }];
    }
    
    if (!self.petField) {
        self.petField = [[VTXTextFieldWithBottomLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [self.petField addDownArrow];
        [self.petField setPlaceholder:@"Choose a pet (Optional)"];
        self.petField.delegate = self;
        [self addSubview:self.petField];
        [self.petField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.categoryField.mas_bottom);
            make.height.left.and.right.equalTo(self.questionTitleField);
        }];
    }
    
    if (!self.questionTextView) {
        self.questionTextView = [[VTXTextViewWithBottomLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
        self.questionTextView.delegate = self;
        [self.questionTextView setText:placeholder];
        [self addSubview:self.questionTextView];
        [self.questionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.petField.mas_bottom);
            make.left.and.right.equalTo(self.questionTitleField);
            make.height.equalTo(@125);
        }];
    }
    
    if (!self.addImageBtn) {
        self.addImageBtn = [[UIButton alloc] init];
        self.addImageBtn.layer.borderWidth = 2.0f;
        self.addImageBtn.layer.borderColor = [GREY_COLOR CGColor];
        self.addImageBtn.layer.cornerRadius = 20.0f;
        [self.addImageBtn.titleLabel setFont:VETX_FONT_BOLD_20];
        [self.addImageBtn setClipsToBounds:YES];
        [self.addImageBtn setTitleColor:GREY_COLOR forState:UIControlStateNormal];
        [self.addImageBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.addImageBtn.titleLabel setFont:VETX_FONT_MEDIUM_22];
        [self.addImageBtn addTarget:self action:@selector(addImageClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addImageBtn];
        [self.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.questionTextView.mas_bottom).offset(verticalPadding);
            make.width.and.height.equalTo(@40);
            make.centerX.equalTo(self);
        }];
        
    }
    
    if (!self.topicPickerView) {
        self.topicPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
        [self.topicPickerView setBackgroundColor:[UIColor whiteColor]];
        self.topicPickerView.delegate = self;
        self.topicPickerView.dataSource = self;
        [self.topicPickerView setShowsSelectionIndicator:YES];
        
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.topicPickerView];
    }
    
    if (!self.petPickerView) {
        self.petPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
        [self.petPickerView setBackgroundColor:[UIColor whiteColor]];
        self.petPickerView.delegate = self;
        self.petPickerView.dataSource = self;
        [self.petPickerView setShowsSelectionIndicator:YES];
        
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.petPickerView];
    }
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    self.categoryField.inputAccessoryView = toolBar;
    self.categoryField.inputView = self.topicPickerView;
    
    self.petField.inputAccessoryView = toolBar;
    self.petField.inputView = self.petPickerView;
}

- (void)postQuestionClicked {
    if (!self.postTypeView) {
        self.postTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.postTypeView setBackgroundColor:ORANGE_THEME_COLOR];
    }
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.postTypeView];
    [self.postTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([[[UIApplication sharedApplication] windows] objectAtIndex:0]);
    }];

    if (!self.selectLabel) {
        self.selectLabel = [[UILabel alloc] init];
        [self.selectLabel setBackgroundColor:ORANGE_THEME_COLOR];
        [self.selectLabel setTextColor:[UIColor whiteColor]];
        [self.selectLabel setTextAlignment:NSTextAlignmentCenter];
        [self.selectLabel setText:@"Connect With A Vet"];
        [self.selectLabel setFont:VETX_FONT_MEDIUM_17];
        [self.postTypeView addSubview:self.selectLabel];
        [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.left.equalTo(self.postTypeView);
            make.top.equalTo(self.postTypeView).offset(20);
            make.height.equalTo(@44);
        }];
    }
    
    if (!self.closeButton) {
        self.closeButton = [[UIButton alloc] init];
        [self.closeButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeTypeView) forControlEvents:UIControlEventTouchUpInside];
        [self.postTypeView addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectLabel);
            make.left.equalTo(self.selectLabel).offset(20);
            make.width.and.height.equalTo(@20);
        }];
    }

    
    if (!self.generalView) {
        self.generalView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.5+40, SCREEN_WIDTH, SCREEN_HEIGHT*0.5-40)];
        [self.generalView setBackgroundColor:[UIColor whiteColor]];
        [self.postTypeView addSubview:self.generalView];
        [self.generalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectLabel.mas_bottom);
            make.left.and.width.equalTo(self.selectLabel);
            make.height.equalTo(self.postTypeView).multipliedBy(0.333).offset(-20);
            
        }];
    }
    
    if (!self.generalIcon) {
        self.generalIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Newspaper-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.generalIcon setTintColor:ORANGE_THEME_COLOR];
        [self.generalView addSubview:self.generalIcon];
        [self.generalIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.generalView.mas_centerY).offset(-20);
            make.centerX.equalTo(self.generalView.mas_centerX);
            make.height.and.width.equalTo(@85);
         }];
    }
    
    if (!self.generalPrice) {
        self.generalPrice = [[UILabel alloc] init];
        [self.generalPrice setText:@"Post General Question\nFree"];
        [self.generalPrice setTextColor:ORANGE_THEME_COLOR];
        [self.generalPrice setTextAlignment:NSTextAlignmentCenter];
        [self.generalPrice setNumberOfLines:2];
        [self.generalPrice setFont:VETX_FONT_BOLD_15];
        [self.generalView addSubview:self.generalPrice];
        [self.generalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.generalIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.generalView);
        }];
    }
    
    if (!self.generalSecondLabel) {
        self.generalSecondLabel = [[UILabel alloc] init];
        [self.generalSecondLabel setText:@"Estimated Response Time: Aproximately 25 minutes"];
        [self.generalSecondLabel setTextColor:ORANGE_THEME_COLOR];
        [self.generalSecondLabel setNumberOfLines:1];
        [self.generalSecondLabel setFont:VETX_FONT_REGULAR_11];
        [self.generalSecondLabel setTextAlignment:NSTextAlignmentCenter];
        [self.generalView addSubview:self.generalSecondLabel];
        [self.generalSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.generalView);
            make.top.equalTo(self.generalPrice.mas_bottom).offset(5);
        }];
    }
    
    if (!self.selectGeneral) {
        self.selectGeneral = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
        [self.selectGeneral addTarget:self action:@selector(postGeneralQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self.generalView addSubview:self.selectGeneral];
        [self.selectGeneral mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.generalView);
        }];
    }
    
    if (!self.divider1) {
        self.divider1 = [[UIView alloc] init];
        [self.divider1 setBackgroundColor:ORANGE_THEME_COLOR];
        [self.postTypeView addSubview:self.divider1];
        [self.divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.postTypeView);
            make.top.equalTo(self.generalView.mas_bottom).offset(-0.5);
            make.height.equalTo(@1);
        }];
    }

    if (!self.chatView) {
        self.chatView = [[UIView alloc] init];
        [self.chatView setBackgroundColor:[UIColor whiteColor]];
        [self.postTypeView addSubview:self.chatView];
        [self.chatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.generalView.mas_bottom);
            make.left.width.and.height.equalTo(self.generalView);
        }];
    }
    
    if (!self.chatIcon) {
        self.chatIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ChatIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.chatIcon setTintColor:ORANGE_THEME_COLOR];
        [self.chatView addSubview:self.chatIcon];
        [self.chatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.chatView.mas_centerY).offset(-20);
            make.centerX.equalTo(self.chatView);
            make.height.equalTo(@90);
            make.width.equalTo(@110);
        }];
    }
    
    if (!self.chatPrice) {
        self.chatPrice = [[UILabel alloc] init];
        [self.chatPrice setText:@"Text Consultation\n$10"];
        [self.chatPrice setTextColor:ORANGE_THEME_COLOR];
        [self.chatPrice setNumberOfLines:2];
        [self.chatPrice setFont:VETX_FONT_BOLD_15];
        [self.chatPrice setTextAlignment:NSTextAlignmentCenter];
        [self.chatView addSubview:self.chatPrice];
        [self.chatPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chatIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.chatView);
        }];
    }
    
    if (!self.chatSecondLabel) {
        self.chatSecondLabel = [[UILabel alloc] init];
        [self.chatSecondLabel setText:@"Estimated Response Time: Aproximately 5 minutes"];
        [self.chatSecondLabel setTextColor:ORANGE_THEME_COLOR];
        [self.chatSecondLabel setNumberOfLines:1];
        [self.chatSecondLabel setFont:VETX_FONT_REGULAR_11];
        [self.chatSecondLabel setTextAlignment:NSTextAlignmentCenter];
        [self.chatView addSubview:self.chatSecondLabel];
        [self.chatSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.chatView);
            make.top.equalTo(self.chatPrice.mas_bottom).offset(5);
        }];
    }
    
    if (!self.selectChat) {
        self.selectChat = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
        [self.selectChat setBackgroundColor:[UIColor clearColor]];
        [self.selectChat addTarget:self action:@selector(chatOneOnOne) forControlEvents:UIControlEventTouchUpInside];
        [self.chatView addSubview:self.selectChat];
        [self.selectChat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.chatView);
        }];
    }
    

    if (!self.divider2) {
        self.divider2 = [[UIView alloc] init];
        [self.divider2 setBackgroundColor:ORANGE_THEME_COLOR];
        [self.postTypeView addSubview:self.divider2];
        [self.divider2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.postTypeView);
            make.top.equalTo(self.chatView.mas_bottom).offset(-0.5);
            make.height.equalTo(@1);
        }];
    }
    
    if (!self.videoView) {
        self.videoView = [[UIView alloc] init];
        [self.videoView setBackgroundColor:[UIColor whiteColor]];
        [self.postTypeView addSubview:self.videoView];
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chatView.mas_bottom);
            make.left.width.and.height.equalTo(self.chatView);
        }];
    }
    
    if (!self.videoIcon) {
        self.videoIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"VideoIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.videoIcon setTintColor:ORANGE_THEME_COLOR];
        [self.videoView addSubview:self.videoIcon];
        [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.videoView.mas_centerY).offset(-20);
            make.centerX.equalTo(self.videoView);
            make.height.equalTo(@55);
            make.width.equalTo(@85);
        }];
    }
    
    if (!self.videoPrice) {
        self.videoPrice = [[UILabel alloc] init];
        [self.videoPrice setText:@"Video Call\n$15"];
        [self.videoPrice setTextColor:ORANGE_THEME_COLOR];
        [self.videoPrice setNumberOfLines:2];
        [self.videoPrice setFont:VETX_FONT_BOLD_15];
        [self.videoPrice setTextAlignment:NSTextAlignmentCenter];
        [self.videoView addSubview:self.videoPrice];
        [self.videoPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.videoIcon.mas_bottom).offset(5);
            make.centerX.equalTo(self.videoView);
        }];
    }
    
    if (!self.videoSecondLabel) {
        self.videoSecondLabel = [[UILabel alloc] init];
        [self.videoSecondLabel setText:@"Estimated Response Time: Aproximately 2 minutes"];
        [self.videoSecondLabel setTextColor:ORANGE_THEME_COLOR];
        [self.videoSecondLabel setNumberOfLines:1];
        [self.videoSecondLabel setFont:VETX_FONT_REGULAR_11];
        [self.videoSecondLabel setTextAlignment:NSTextAlignmentCenter];
        [self.videoView addSubview:self.videoSecondLabel];
        [self.videoSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.videoView);
            make.top.equalTo(self.videoPrice.mas_bottom).offset(5);
        }];
    }
    
    if (!self.selectVideo) {
        self.selectVideo = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
        [self.selectVideo setBackgroundColor:[UIColor clearColor]];
        [self.selectVideo addTarget:self action:@selector(videoOneOnOne) forControlEvents:UIControlEventTouchUpInside];
        [self.videoView addSubview:self.selectVideo];
        [self.selectVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.videoView);
        }];
    }
 
}

- (void)tapBackground {
    [self endEditing:YES];
}

- (void)doneTouched:(id)sender {
    [self endEditing:YES];
    
    @try {
        if (self.selectedField == self.categoryField) {
            NSInteger row = [self.topicPickerView selectedRowInComponent:0];
            NSString *selectedStr = [[self.pickerViewData objectAtIndex:row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.categoryField setText:selectedStr];
        } else {
            @try {
                if (self.petArray.count > 0) {
                    NSInteger row = [self.petPickerView selectedRowInComponent:0];
                    if ([self.delegate respondsToSelector:@selector(didSelectedPet:)]) {
                        [self.delegate performSelector:@selector(didSelectedPet:) withObject:[self.petArray objectAtIndex:row]];
                    }
                    [self.petField setText:[self.petArray objectAtIndex:row].name];
                }
            } @catch (NSException *exception) {
                NSLog(@"No pet added");
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Done selection: %@", exception);
    } @finally {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
    
}

- (void)closeTypeView {
    [self.postTypeView removeFromSuperview];
}

- (void)updateQuestionImageView {
    [self.addImageBtn.layer setCornerRadius:2.0];
    [self.addImageBtn.layer setBorderWidth:0.0];
    [self.addImageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionTextView.mas_bottom).offset(verticalPadding);
        make.width.and.height.equalTo(@100);
        make.centerX.equalTo(self);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)addImageClicked {
    if ([self.delegate respondsToSelector:@selector(addQestionImage)]) {
        [self.delegate performSelector:@selector(addQestionImage)];
    }
}

- (void)chatOneOnOne {
    [self.postTypeView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(startOneOnOne:)]) {
        [self.delegate performSelector:@selector(startOneOnOne:) withObject:@0];
    }
}

- (void)videoOneOnOne {
    [self.postTypeView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(startOneOnOne:)]) {
        [self.delegate performSelector:@selector(startOneOnOne:) withObject:@1];
    }
}

- (void)postGeneralQuestion {
    [self.postTypeView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(postGeneral)]) {
        [self.delegate performSelector:@selector(postGeneral)];
    }
}

#pragma mark - Text field delegate 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField != self.questionTitleField) {
        [self showPickerViewWithData:(VTXTextFieldWithBottomLine *)textField];
    }
}

- (void)showPickerViewWithData:(VTXTextFieldWithBottomLine *)textField {
    self.selectedField = textField;
    if (textField == self.categoryField) {
        [self.topicPickerView reloadAllComponents];
    } else {
        [self.petPickerView reloadAllComponents];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
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
        textView.text = @"Please input your answer here...";
        textView.textColor = GREY_COLOR; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - UIPickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.topicPickerView) {
        return self.pickerViewData.count;
    } else  {
        return self.petArray.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.topicPickerView) {
        return [NSString stringWithFormat:@"%@", self.items[row]];
    } else {
        return [self.petArray objectAtIndex:row].name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.topicPickerView) {
        [self.categoryField setText:[NSString stringWithFormat:@"%@", self.items[row]]];
    } else {
        if ([self.delegate respondsToSelector:@selector(didSelectedPet:)]) {
            [self.delegate performSelector:@selector(didSelectedPet:) withObject:[self.petArray objectAtIndex:row]];
        }
        [self.petField setText:[self.petArray objectAtIndex:row].name];
    }
}


@end
