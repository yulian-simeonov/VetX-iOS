//
//  VTXAddPetView.m
//  VetX
//
//  Created by YulianMobile on 3/2/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXAddPetView.h"
#import "Constants.h"
#import "VetXTextField.h"
#import "Masonry.h"
#import "UIButton+AFNetworking.h"


CGFloat const PickerHeight = 200;
CGFloat const VerticalHeight = 10;

@interface VTXAddPetView () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *closeView;
@property (nonatomic, strong) VetXTextField *nameField;
@property (nonatomic, strong) VetXTextField *typeField;
@property (nonatomic, strong) VetXTextField *breedField;
@property (nonatomic, strong) VetXTextField *sexField;
@property (nonatomic, strong) VetXTextField *birthdayField;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSArray *pickerViewData;
@property (nonatomic, strong) VetXTextField *selectedField;

@property (nonatomic, strong) UIPickerView *oneColumnPickerView;
@property (nonatomic, strong) UIDatePicker *birthdayPickerView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end


@implementation VTXAddPetView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    self.selectedDate = [NSDate date];
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
        
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    if (!self.tapGesture) {
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self.tapGesture setNumberOfTapsRequired:1];
        [self.tapGesture addTarget:self action:@selector(resignKeyboard)];
    }
    
    self.sex = @[@"Male - Not Neutered", @"Female - Not Spayed", @"Male - Neutered ", @"Female - Spayed"];
    
    UIView *whiteView = [[UIView alloc] init];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [whiteView addGestureRecognizer:self.tapGesture];
    [self addSubview:whiteView];
    UIEdgeInsets padding = UIEdgeInsetsMake(25, 25, 25, 25);
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    
    if (!self.closeView) {
        self.closeView = [[UIButton alloc] init];
        [self.closeView setTintColor:ORANGE_THEME_COLOR];
        [self.closeView setClipsToBounds:YES];
        [self.closeView setImage:[[UIImage imageNamed:@"ClosePet"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.closeView addTarget:self action:@selector(closeAddPetView) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:self.closeView];
        [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.equalTo(whiteView).offset(15);
            make.height.and.width.equalTo(@32);
        }];
    }
    
    if (!self.petImageProfile) {
        self.petImageProfile = [[UIButton alloc] init];
        [self.petImageProfile setClipsToBounds:YES];
        [self.petImageProfile setContentMode:UIViewContentModeScaleAspectFit];
        [self.petImageProfile setImage:[UIImage imageNamed:@"Pet"] forState:UIControlStateNormal];
        [self.petImageProfile.layer setCornerRadius:40.0f];
        [self.petImageProfile addTarget:self action:@selector(addPetImageClicked) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:self.petImageProfile];
        [self.petImageProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(25);
            make.width.and.height.equalTo(@80);
            make.centerX.equalTo(whiteView);
        }];
    }
    
    if (!self.nameField) {
        self.nameField = [[VetXTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.nameField setPlaceholder:@"Pet Name - Required"];
        [self.nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        self.nameField.delegate = self;
        [whiteView addSubview:self.nameField];
        [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.petImageProfile.mas_bottom).offset(15);
            make.centerX.equalTo(whiteView);
            make.width.equalTo(whiteView.mas_width).offset(-40);
            make.height.equalTo(@40);
        }];
    }
    
    if (!self.typeField) {
        self.typeField = [[VetXTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.typeField setPlaceholder:@"Select Pet Type"];
        [self.typeField setAccessibilityLabel:@"type"];
        [self.typeField addDownArrow];
        self.typeField.delegate = self;
        [whiteView addSubview:self.typeField];
        [self.typeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.and.height.equalTo(self.nameField);
            make.top.equalTo(self.nameField.mas_bottom).offset(VerticalHeight);
        }];
    }
    
    if (!self.breedField) {
        self.breedField = [[VetXTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.breedField setPlaceholder:@"Select Pet Breed"];
        [self.typeField setAccessibilityLabel:@"breed"];
        [self.breedField addDownArrow];
        self.breedField.delegate = self;
        [whiteView addSubview:self.breedField];
        [self.breedField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.and.height.equalTo(self.nameField);
            make.top.equalTo(self.typeField.mas_bottom).offset(VerticalHeight);
        }];
    }
    
    if (!self.sexField) {
        self.sexField = [[VetXTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.sexField setPlaceholder:@"Select Pet Sex"];
        [self.typeField setAccessibilityLabel:@"sex"];
        [self.sexField addDownArrow];
        self.sexField.delegate = self;
        [whiteView addSubview:self.sexField];
        [self.sexField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.and.height.equalTo(self.nameField);
            make.top.equalTo(self.breedField.mas_bottom).offset(10);
        }];
    }
    
    if (!self.birthdayField) {
        self.birthdayField = [[VetXTextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.birthdayField setPlaceholder:@"Birthday"];
        [self.birthdayField setAccessibilityLabel:@"birthday"];
        [self.birthdayField addDownArrow];
        self.birthdayField.delegate = self;
        [whiteView addSubview:self.birthdayField];
        [self.birthdayField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.height.equalTo(self.nameField);
            make.width.equalTo(self.nameField);
            make.top.equalTo(self.sexField.mas_bottom).offset(VerticalHeight);
        }];
    }
    
    if (!self.submitBtn) {
        self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        [self.submitBtn setBackgroundColor:ORANGE_THEME_COLOR];
        [self.submitBtn.titleLabel setFont:VETX_FONT_MEDIUM_17];
        [self.submitBtn setTitle:@"Add Pet" forState:UIControlStateNormal];
        [self.submitBtn addTarget:self action:@selector(addPetClicked) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.nameField);
            make.centerX.width.and.bottom.equalTo(whiteView);
        }];
    }
    
    if (!self.oneColumnPickerView) {
        self.oneColumnPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
        [self.oneColumnPickerView setBackgroundColor:[UIColor whiteColor]];
        self.oneColumnPickerView.delegate = self;
        self.oneColumnPickerView.dataSource = self;
        [self.oneColumnPickerView setShowsSelectionIndicator:YES];
        
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.oneColumnPickerView];
    }
    
    if (!self.birthdayPickerView) {
        self.birthdayPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
        [self.birthdayPickerView setBackgroundColor:[UIColor whiteColor]];
        [self.birthdayPickerView setDatePickerMode:UIDatePickerModeDate];
        [self.birthdayPickerView setDate:[NSDate date]];
        [self.birthdayPickerView addTarget:self action:@selector(didChangeBirthday) forControlEvents:UIControlEventValueChanged];
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.birthdayPickerView];
    }
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    self.typeField.inputAccessoryView = toolBar;
    self.typeField.inputView = self.oneColumnPickerView;
    self.breedField.inputAccessoryView = toolBar;
    self.breedField.inputView = self.oneColumnPickerView;
    self.sexField.inputAccessoryView = toolBar;
    self.sexField.inputView = self.oneColumnPickerView;
    self.birthdayField.inputAccessoryView = toolBar;
    self.birthdayField.inputView = self.birthdayPickerView;
}

- (void)setPetInfo:(Pet *)pet {
    if (!pet) {
        [self.nameField setText:@""];
        [self.typeField setText:@""];
        [self.breedField setText:@""];
        [self.birthdayField setText:@""];
        [self.sexField setText:@""];
        [self.petImageProfile setImage:[UIImage imageNamed:@"Pet"] forState:UIControlStateNormal];
    } else {
        [self.nameField setText:pet.name];
        [self.breedField setText:pet.breed];
        [self.typeField setText:pet.type];
        NSString *sexString = @"";
        [self.petImageProfile setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:pet.imageURL] placeholderImage:[UIImage imageNamed:@"Pet"]];
        switch ([pet getSexType]) {
            case FemaleSpayed:
                sexString = @"Female Spayed";
                self.request.petSex = @"female";
                self.request.isFixed = YES;
                break;
            case FemaleNotSpayed:
                sexString = @"Female Not Spayed";
                self.request.petSex = @"female";
                self.request.isFixed = NO;
                break;
            case MaleNeutered:
                sexString = @"Male Neutered";
                self.request.petSex = @"male";
                self.request.isFixed = YES;
                break;
            case MaleNotNeutered:
                sexString = @"Male Not Neutered";
                self.request.petSex = @"male";
                self.request.isFixed = NO;
                break;
            default:
                break;
        }
        [self.sexField setText:sexString];
        [self.birthdayField setText:[pet getPetBirthday]];
        self.request.petID = pet.petID;
        self.request.petName = pet.name;
        self.request.petType = pet.type;
        self.request.petBreed = pet.breed;
        self.request.petBirthday = pet.birthday;
    }
}

- (void)resignKeyboard {
    [self endEditing:YES];
}

- (void)didChangeBirthday {
    self.selectedDate = self.birthdayPickerView.date;
    [self.birthdayField setText:[self.dateFormatter stringFromDate:self.selectedDate]];
}

- (void)addPetImageClicked {
    if ([self.delegate respondsToSelector:@selector(openImagePicker)]) {
        [self.delegate performSelector:@selector(openImagePicker)];
    }
}

- (void)addPetClicked {
    self.request.petBirthday = self.selectedDate;
    if ([self.delegate respondsToSelector:@selector(didAddPet:)]) {
        [self.delegate performSelector:@selector(didAddPet:) withObject:self.request];
    }
}

- (void)closeAddPetView {
    if ([self.delegate respondsToSelector:@selector(closeAddPet)]) {
        [self.delegate performSelector:@selector(closeAddPet)];
    }
}

- (void)doneTouched:(id)sender {
    [self endEditing:YES];
    @try {
        NSInteger row = [self.oneColumnPickerView selectedRowInComponent:0];
        NSString *selectedStr = [[self.pickerViewData objectAtIndex:row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (self.selectedField == self.breedField) {
            self.request.petBreed = selectedStr;
        } else if (self.selectedField == self.typeField) {
            self.request.petType = selectedStr;
            if (self.typeBreed) {
                self.breed = [self.typeBreed objectForKey:selectedStr];
            }
        } else if (self.selectedField == self.sexField) {
            switch (row) {
                case 0:
                    self.request.petSex = @"male";
                    self.request.isFixed = NO;
                    break;
                case 1:
                    self.request.petSex = @"female";
                    self.request.isFixed = NO;
                    break;
                case 2:
                    self.request.petSex = @"male";
                    self.request.isFixed = YES;
                    break;
                default:
                    self.request.petSex = @"female";
                    self.request.isFixed = YES;
                    break;
            }
            self.sexField.text = selectedStr;
        } else {
            return;
        }
        [self.selectedField setText:selectedStr];
    } @catch (NSException *exception) {
        NSLog(@"Exception when click done button: %@", exception);
    } @finally {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - UIPickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewData.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.oneColumnPickerView) {
        return 1;
    } else {
        return 2;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.selectedField == self.birthdayField) {
        // Show birthday string
        return @"";
    } else {
        return self.pickerViewData[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSString *selectedStr = [[self.pickerViewData objectAtIndex:row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.selectedField == self.nameField) {
        self.request.petName = selectedStr;
    } else if (self.selectedField == self.breedField) {
        self.request.petBreed = selectedStr;
    } else if (self.selectedField == self.typeField) {
        self.request.petType = selectedStr;
        if (self.typeBreed) {
            self.breed = [self.typeBreed objectForKey:selectedStr];
        }
    } else if (self.selectedField == self.sexField) {
        switch (row) {
            case 0:
                self.request.petSex = @"male";
                self.request.isFixed = NO;
                break;
            case 1:
                self.request.petSex = @"female";
                self.request.isFixed = NO;
                break;
            case 2:
                self.request.petSex = @"male";
                self.request.isFixed = YES;
                break;
            default:
                self.request.petSex = @"female";
                self.request.isFixed = YES;
                break;
        }
        self.sexField.text = selectedStr;
    }
    [self.selectedField setText:selectedStr];
}

- (void)changeToUpdateView:(BOOL)updatePet {
    if (updatePet) {
        [self.submitBtn setTitle:@"Update Pet" forState:UIControlStateNormal];
    } else {
        [self.submitBtn setTitle:@"Add Pet" forState:UIControlStateNormal];
    }
}

#pragma mark - UITextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignKeyboard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameField) {
        self.request.petName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField != self.nameField) {
        [self showPickerViewWithData:(VetXTextField *)textField];
    }
}

- (void)showPickerViewWithData:(VetXTextField *)textField {
    self.selectedField = textField;
    if (textField == self.typeField) {
        self.pickerViewData = [self.type copy];
    } else if (textField == self.breedField) {
        self.pickerViewData = [self.breed copy];
    } else if (textField == self.sexField) {
        self.pickerViewData = self.sex;
    }
    [self.oneColumnPickerView reloadAllComponents];
}


- (void)showAgePicker {
    [self.oneColumnPickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@(PickerHeight));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
