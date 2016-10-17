//
//  VTXAddPetView.h
//  VetX
//
//  Created by YulianMobile on 3/2/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPetRequestModel.h"
#import "Pet.h"

@protocol VTXAddPetViewDelegate <NSObject>

- (void)openImagePicker;
- (void)didAddPet:(AddPetRequestModel *)request;
- (void)closeAddPet;

@end

@interface VTXAddPetView : UIView

@property (nonatomic, assign) id<VTXAddPetViewDelegate> delegate;

@property (nonatomic, strong) AddPetRequestModel *request;
@property (nonatomic, strong) NSMutableArray *type;
@property (nonatomic, strong) NSMutableArray *breed;
@property (nonatomic, strong) NSDictionary *typeBreed;
@property (nonatomic, strong) NSArray *sex;
@property (nonatomic, strong) UIButton *petImageProfile;
@property (nonatomic, strong) UIButton *submitBtn;

- (void)changeToUpdateView:(BOOL)updatePet;

- (void)setPetInfo:(Pet *)pet;

@end
