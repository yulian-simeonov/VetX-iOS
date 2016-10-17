//
//  AddQuestionView.h
//  VetX
//
//  Created by Liam Dyer on 2/17/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostQuestionRequestModel.h"
#import "VTXTextFieldWithBottomLine.h"
#import "VTXTextViewWithBottomLine.h"
#import "Pet.h"

@protocol VTXAddQuestionViewDelegate <NSObject>

- (void)startOneOnOne:(NSNumber *)isVideo;
- (void)postGeneral;
- (void)addQestionImage;
- (void)didSelectedPet:(Pet *)pet;

@end

@interface VTXAddQuestionView : UIView


@property (nonatomic, assign) id<VTXAddQuestionViewDelegate> delegate;
//@property (nonatomic, strong) UICollectionView *petCollectionView;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) VTXTextFieldWithBottomLine *questionTitleField;
@property (nonatomic, strong) VTXTextFieldWithBottomLine *categoryField;
@property (nonatomic, strong) VTXTextFieldWithBottomLine *petField;
@property (nonatomic, strong) VTXTextViewWithBottomLine *questionTextView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) RLMArray <Pet *><Pet> *petArray;

- (void)updateQuestionImageView;
- (void)postQuestionClicked;

@end
