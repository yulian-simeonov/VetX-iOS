//
//  AddQuestionView.h
//  VetX
//
//  Created by Liam Dyer on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddQuestionActionBarViewDelegate;

@interface AddQuestionActionBarView : UIView

@property (nonatomic, strong) id<AddQuestionActionBarViewDelegate> delegate;

@end

@protocol AddQuestionActionBarViewDelegate <NSObject>

- (void)addQuestionButtonClicked;

@end
